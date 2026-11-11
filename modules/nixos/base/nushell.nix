{ pkgs, ... }:
let
  # Nushell (the login shell, see modules/base/user.nix) never sources /etc/profile, so a
  # TTY or SSH login misses everything NixOS exports there: environment.variables (EDITOR,
  # SSH_ASKPASS, ...) and environment.extraInit (SSH_AUTH_SOCK from programs.ssh.startAgent,
  # so `ssh-add` fails with "Could not open a connection to your authentication agent").
  # This runs /etc/set-environment in sh and loads whatever it changed. The file exports
  # __NIXOS_SET_ENVIRONMENT_DONE, so child shells and sessions that already have the NixOS
  # environment skip it.
  nixosEnvironment = pkgs.writeTextDir "share/nushell/vendor/autoload/nixos-environment.nu" ''
    if ($env.__NIXOS_SET_ENVIRONMENT_DONE? | is-empty) and ("/etc/set-environment" | path exists) {
      let env_of = {|script|
        let result = ^/bin/sh -c $"($script) env -0" | complete
        if $result.exit_code != 0 {
          print --stderr $"nixos-environment.nu: ($result.stderr | str trim)"
          return []
        }
        $result.stdout
        | split row (char nul)
        | compact --empty
        | parse --regex '(?s)^(?<name>[^=]+)=(?<value>.*)$'
      }

      let before = do $env_of ""
      let after = do $env_of ". /etc/set-environment;"

      load-env (
        $after
        | where {|var| $var not-in $before and $var.name not-in [PWD OLDPWD SHLVL _] }
        | reduce --fold {} {|var, acc|
            let value = if $var.name == "PATH" {
              $var.value | split row (char esep) | uniq
            } else {
              $var.value
            }
            $acc | insert $var.name $value
          }
      )
    }
  '';
in
{
  # Nushell searches $XDG_DATA_DIRS/nushell/vendor/autoload, which includes the system profile.
  environment.pathsToLink = [ "/share/nushell/vendor/autoload" ];
  environment.systemPackages = [ nixosEnvironment ];
}
