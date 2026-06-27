{ ... }:
{
  boot.loader.systemd-boot = {
    # we use Git for version control, so we don't need to keep too many generations.
    configurationLimit = 10;
    # pick the highest resolution for systemd-boot's console.
    consoleMode = "max";
  };

  boot.loader.timeout = 8; # wait for x seconds to select the boot entry
}
