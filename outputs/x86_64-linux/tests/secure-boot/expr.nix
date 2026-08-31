{ outputs }:
{
  storm = {
    preservation = outputs.nixosConfigurations.storm.config.preservation.enable;
    btrbk = outputs.nixosConfigurations.storm.config.services.btrbk.instances.btrbk.onCalendar;
    systemdBoot = outputs.nixosConfigurations.storm.config.boot.loader.systemd-boot.enable;
  };
  stormlight = {
    preservation = outputs.nixosConfigurations.stormlight.config.preservation.enable;
    btrbk = outputs.nixosConfigurations.stormlight.config.services.btrbk.instances.btrbk.onCalendar;
    systemdBoot = outputs.nixosConfigurations.stormlight.config.boot.loader.systemd-boot.enable;
  };
}
