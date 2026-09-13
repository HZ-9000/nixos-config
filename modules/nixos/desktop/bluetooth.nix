{ pkgs, ... }:
{
  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    bluez
    bluetui
    bluez-tools
  ];
}
