_: {
  # Disable PulseAudio in favour of PipeWire
  services.pulseaudio.enable = false;

  # Real-time audio support for desktop workloads.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.alsa.enablePersistence = true;
}
