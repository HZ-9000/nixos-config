{ outputs }:
{
  storm = {
    lanzaboote = outputs.nixosConfigurations.storm.config.boot.lanzaboote.enable or false;
    preservation = outputs.nixosConfigurations.storm.config.preservation.enable or false;
    btrbk = outputs.nixosConfigurations.storm.config.services.btrbk.instances.btrbk.onCalendar;
    systemdBoot = outputs.nixosConfigurations.storm.config.boot.loader.systemd-boot.enable;
  };
  stormlight = {
    lanzaboote = outputs.nixosConfigurations.stormlight.config.boot.lanzaboote.enable;
    preservation = outputs.nixosConfigurations.stormlight.config.preservation.enable;
    btrbk = outputs.nixosConfigurations.stormlight.config.services.btrbk.instances.btrbk.onCalendar;
    systemdBoot = outputs.nixosConfigurations.stormlight.config.boot.loader.systemd-boot.enable;
  };
}
