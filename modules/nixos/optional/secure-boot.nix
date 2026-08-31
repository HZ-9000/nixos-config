{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    # Create and enroll Secure Boot keys while booted normally.
    pkgs.sbctl
  ];

  # Keep systemd-boot active until Secure Boot keys have been created and
  # enrolled. This deliberately avoids Lanzaboote's PKI bundle at rebuild time.
  boot.loader.systemd-boot.enable = true;
}
