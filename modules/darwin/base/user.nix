{ myvars, ... }:
{
  users.users."${myvars.username}" = {
    name = myvars.username;
    home = "/Users/${myvars.username}";
  };
}
