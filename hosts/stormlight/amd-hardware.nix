{ pkgs, ... }:
{
  # Ryzen AI 5 340 with Radeon 840M iGPU. amdgpu in the initrd (early KMS),
  # microcode and graphics come from nixos-hardware's
  # framework-amd-ai-300-series module (outputs/x86_64-linux/src/stormlight.nix).
  environment.systemPackages = with pkgs; [
    amdgpu_top
    nvtopPackages.amd
  ];
}
