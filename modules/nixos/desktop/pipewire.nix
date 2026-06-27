{ ... }:
{
  # Disable PulseAudio in favour of PipeWire
  services.pulseaudio.enable = false;

  # Real-time audio support (was only in the orphaned audio.nix home file)
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.alsa.enablePersistence = true;
}
