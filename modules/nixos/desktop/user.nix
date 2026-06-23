{ myvars, ... }:
{
  # Additional user settings for desktop environment
  users.users.${myvars.username} = {
    extraGroups = [
      "audio"
      "video"
      "input"
    ];
  };
}
