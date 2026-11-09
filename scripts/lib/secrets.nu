# Shared helpers for the agenix scripts in ../ (secrets-rekey.nu, secrets-regen.nu).
#
# Hosts decrypt with their SSH host key. agenix reads it from /persistent directly: with systemd
# initrd, activation (and agenix) runs before preservation bind-mounts /etc/ssh.

export const repo = path self ../../nixos-secrets
export const host_key = "/persistent/etc/ssh/ssh_host_ed25519_key"
# Pre-SSH-key host identity; still tried for decryption until every host has migrated.
export const legacy_age_key = "/persistent/etc/age/keys.txt"

# Clone ./nixos-secrets, or fast-forward it
export def sync-repo [] {
  if ($repo | path join .git | path exists) {
    ^git -C $repo pull --ff-only
  } else {
    ^git clone git@github.com:HZ-9000/nixos-secrets.git $repo
  }
}

# "ssh-ed25519 AAAA... root@host" -> "ssh-ed25519 AAAA..."
export def normalize-pubkey [] {
  str trim | split row --regex '\s+' | first 2 | str join " "
}

# Public SSH host key of this machine, or of a remote host via ssh-keyscan (confirmed first)
export def host-pubkey [host: string] {
  if $host == (sys host | get hostname) {
    return (open --raw $"($host_key).pub" | normalize-pubkey)
  }
  let scanned = ^ssh-keyscan -t ed25519 $host err> /dev/null | lines | where $it !~ '^#'
  if ($scanned | is-empty) {
    error make { msg: $"ssh-keyscan found no ed25519 key for ($host); pass the key explicitly." }
  }
  let pub = $scanned | first | split row " " | skip 1 | str join " " | normalize-pubkey
  print $"ssh-keyscan ($host): ($pub)"
  print $"Compare with `cat ($host_key).pub` on ($host)."
  if (input "Use this key? [y/N] ") !~ '^[yY]' { error make { msg: "Aborted." } }
  $pub
}

# Record the host's key in keys/<host>.pub and secrets.nix (adds it to allHosts if missing)
export def register-host [host: string, pub: string] {
  $"($pub)\n" | save -f ($repo | path join keys $"($host).pub")
  let legacy = $repo | path join keys $"($host).age.pub"
  if ($legacy | path exists) { ^git -C $repo rm -q --cached --ignore-unmatch $legacy; rm $legacy }

  let nixfile = $repo | path join secrets.nix
  mut lines = open --raw $nixfile | lines
  let entry = $'  ($host) = "($pub)";'

  let existing = $lines | enumerate | where item starts-with $'  ($host) = "'
  if ($existing | is-empty) {
    let deploy = $lines | enumerate | where item starts-with '  deploy = "' | first | get index
    $lines = $lines | insert ($deploy + 1) $entry
  } else {
    $lines = $lines | update ($existing | first | get index) $entry
  }

  let start = $lines | enumerate | where item =~ 'allHosts = \[' | first | get index
  let block = $lines | skip ($start + 1) | take until {|l| ($l | str trim) == "];" }
  if ($host not-in ($block | str trim)) {
    $lines = $lines | insert ($start + 1) $'    ($host)'
  }

  $lines | str join "\n" | $in + "\n" | save -f $nixfile
}

# Secret file names declared in secrets.nix
export def secret-files [] {
  ^nix eval --json --file ($repo | path join secrets.nix) --apply builtins.attrNames | from json
}

# Commit the recipient list and every secret
export def commit [message: string] {
  ^git -C $repo add secrets.nix keys ...(secret-files)
  ^git -C $repo commit -m $message
}

export def print-next-steps [host: string] {
  print ""
  print "Next:"
  print "  git -C nixos-secrets push"
  print "  nix flake update nixos-secrets"
  print $"  just switch ($host)"
}
