#!/usr/bin/env nu
# Re-encrypt every agenix secret in ./nixos-secrets for the recipients in secrets.nix, keeping
# the values. Run it on a machine that can already decrypt (an existing host, or with
# AGENIX_KEY pointing at the deploy key). See `just secrets-rekey` and nixos-secrets/README.md.
#
#   secrets-rekey.nu                       # rekey only (after editing secrets.nix by hand)
#   secrets-rekey.nu storm                 # add/update storm, key fetched with ssh-keyscan
#   secrets-rekey.nu storm "ssh-ed25519 …" # add/update storm with an explicit key
#   secrets-rekey.nu (hostname)            # this machine: reads its own host key
#
# Commits in nixos-secrets; does not push.

use lib/secrets.nu *

const root = path self ..

# Public key (SSH or age) of a private key file, or null if it is neither
def identity-pubkey [path: string, agekeygen: string] {
  let ssh = do { ^sudo (which ssh-keygen | first | get path) -y -f $path } | complete
  if $ssh.exit_code == 0 { return ($ssh.stdout | normalize-pubkey) }
  let age = do { ^sudo $agekeygen -y $path } | complete
  if $age.exit_code == 0 { $age.stdout | str trim } else { null }
}

def main [host?: string, pubkey?: string] {
  sync-repo

  # Identities here that are current recipients, checked before anything is changed
  # (host keys are root-only). A new host can't rekey for itself.
  let agekeygen = ^nix build --no-link --print-out-paths nixpkgs#age | lines | first | path join bin age-keygen
  let recipients = ^nix eval --json --file ($repo | path join secrets.nix) --apply 's: builtins.concatMap (v: v.publicKeys) (builtins.attrValues s)'
    | from json | each { normalize-pubkey } | uniq
  let candidates = [$host_key $legacy_age_key] | append ($env.AGENIX_KEY? | default [])

  # Prompt for the sudo password here: the checks below capture output with `complete`,
  # where a password prompt can't be answered and sudo just fails.
  ^sudo -v
  let checked = $candidates | each {|p|
    let exists = (do { ^sudo test -f $p } | complete).exit_code == 0
    let pub = if $exists { identity-pubkey $p $agekeygen } else { null }
    { path: $p, exists: $exists, pubkey: $pub, recipient: ($pub != null and $pub in $recipients) }
  }
  let identities = $checked | where recipient | get path
  if ($identities | is-empty) {
    print -e ($checked | table)
    print -e $"Recipients in secrets.nix:\n($recipients | str join "\n")"
    error make { msg: ([
      "None of the identities above is a recipient in secrets.nix, so nothing here can decrypt."
      "Run this on a host that already decrypts the secrets (e.g. stormlight), or set AGENIX_KEY to the deploy key."
    ] | str join "\n") }
  }
  print $"Decrypting with: ($identities | str join ', ')"

  if $host != null {
    let pub = if $pubkey != null { $pubkey | normalize-pubkey } else { host-pubkey $host }
    register-host $host $pub
    print $"Registered ($host): ($pub)"
  }

  let agenix = ^nix build --no-link --print-out-paths --inputs-from $root agenix | lines | first | path join bin agenix
  let args = $identities | each {|i| [-i $i] } | flatten
  ^sudo env $"AGENIX_RULES=($repo | path join secrets.nix)" $agenix -r ...$args
  # Written as root; hand them back
  ^sudo chown $"(whoami):(^id -gn | str trim)" ...(secret-files | each {|f| $repo | path join $f })

  commit (if $host != null { $"Add ($host) and rekey secrets" } else { "Rekey secrets" })
  print-next-steps ($host | default (sys host | get hostname))
}
