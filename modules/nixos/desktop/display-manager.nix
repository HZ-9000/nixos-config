{ myvars, ... }:
{
  services.xserver.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = myvars.username;
  };
}
