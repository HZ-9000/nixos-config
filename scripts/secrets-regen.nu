#!/usr/bin/env nu
# Fallback for when no machine can decrypt the current secrets (otherwise use secrets-rekey.nu,
# which keeps the values). See `just secrets-regen` and nixos-installer/README.md.
#
# Adds this host's SSH host key as a recipient in ./nixos-secrets and re-encrypts every secret
# from newly entered values, for every recipient. Commits there; does not push.

use lib/secrets.nu *

const known = [user-password.age root-password.age gh-token.age]

# Prompt twice without echo; returns "" only when allowed
def ask [prompt: string, --allow-empty] {
  loop {
    let a = input -s $'($prompt): '
    print ""
    if ($a | is-empty) {
      if $allow_empty { return "" }
      print -e "Empty, try again."
      continue
    }
    let b = input -s $'($prompt) \(again): '
    print ""
    if $a == $b { return $a }
    print -e "Mismatch, try again."
  }
}

def hash [password: string] {
  $password | ^mkpasswd -s -m yescrypt | str trim
}

def main [host?: string] {
  let host = $host | default (sys host | get hostname)

  # age, mkpasswd without a nix shell per call
  let bins = ^nix build --no-link --print-out-paths nixpkgs#age nixpkgs#mkpasswd
    | lines | each {|p| $p | path join bin }
  $env.PATH = $bins | append $env.PATH
  let age = which age | first | get path

  sync-repo

  # 1. Host identity: the SSH host key (sshd makes it on first boot; preserved under /persistent)
  if (do { ^sudo test -f $host_key } | complete).exit_code != 0 {
    ^sudo install -d -m 755 ($host_key | path dirname)
    ^sudo ssh-keygen -q -t ed25519 -N "" -C $"root@($host)" -f $host_key
    print $"Created ($host_key)"
  }
  let pub = open --raw $"($host_key).pub" | normalize-pubkey
  print $"($host): ($pub)"

  # 2. Register it as a recipient
  register-host $host $pub
  let secrets = ^nix eval --json --file ($repo | path join secrets.nix) | from json | transpose file cfg
  let unknown = $secrets.file | where $it not-in $known
  if ($unknown | is-not-empty) {
    error make { msg: $"Don't know how to regenerate ($unknown | str join ', '); add it to this script." }
  }

  # 3. New values (nothing is written until all are entered)
  let user_hash = hash (ask "Password for the main user")
  let root_pw = ask "Password for root (empty = same as user)" --allow-empty
  let root_hash = if ($root_pw | is-empty) { $user_hash } else { hash $root_pw }
  mut gh_token = input -s "GitHub token (empty = `gh auth token`): "
  print ""
  if ($gh_token | is-empty) { $gh_token = ^gh auth token | str trim }
  let values = {
    "user-password.age": $user_hash
    "root-password.age": $root_hash
    "gh-token.age": $gh_token
  }

  # 4. Encrypt for the recipients in secrets.nix
  for s in $secrets {
    let recipients = $s.cfg.publicKeys | each {|r| [-r $r] } | flatten
    $values | get $s.file | ^$age ...$recipients -o ($repo | path join $s.file)
    print $"Encrypted ($s.file) for ($s.cfg.publicKeys | length) recipient\(s)"
  }
  ^sudo $age -d -i $host_key ($repo | path join user-password.age) | ignore
  print "Host key decrypts user-password.age"

  commit $"Add ($host) and regenerate secrets"
  print-next-steps $host
}
