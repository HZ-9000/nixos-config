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

def main [host?: string, pubkey?: string] {
  sync-repo

  if $host != null {
    let pub = if $pubkey != null { $pubkey | normalize-pubkey } else { host-pubkey $host }
    register-host $host $pub
    print $"Registered ($host): ($pub)"
  }

  # Identities that may decrypt the current files (host keys are root-only)
  let candidates = [$host_key $legacy_age_key] | append ($env.AGENIX_KEY? | default [])
  let identities = $candidates | where {|p| (do { ^sudo test -f $p } | complete).exit_code == 0 }
  if ($identities | is-empty) {
    error make { msg: $"No identity can decrypt here; tried ($candidates | str join ', '). Set AGENIX_KEY." }
  }
  print $"Decrypting with: ($identities | str join ', ')"

  let agenix = ^nix build --no-link --print-out-paths --inputs-from $root agenix | lines | first | path join bin agenix
  let args = $identities | each {|i| [-i $i] } | flatten
  ^sudo env $"AGENIX_RULES=($repo | path join secrets.nix)" $agenix -r ...$args
  # Written as root; hand them back
  ^sudo chown $"(whoami):(^id -gn | str trim)" ...(secret-files | each {|f| $repo | path join $f })

  commit (if $host != null { $"Add ($host) and rekey secrets" } else { "Rekey secrets" })
  print-next-steps ($host | default (sys host | get hostname))
}
