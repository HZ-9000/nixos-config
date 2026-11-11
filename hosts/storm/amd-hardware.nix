{ pkgs, ... }:
{
  # Ryzen 7 9700X CPU and Radeon RX 7900 XTX GPU.
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware = {
    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;
    graphics.enable32Bit = true; # graphics.enable is set in modules/base/hardware.nix
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top
    nvtopPackages.amd
    radeontop
    liquidctl # NZXT Kraken Elite AIO
  ];

  # Lets liquidctl talk to the AIO's USB HID interface without sudo.
  services.udev.packages = [ pkgs.liquidctl ];
  programs.coolercontrol.enable = true;
}
