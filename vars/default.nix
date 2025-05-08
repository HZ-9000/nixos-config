{lib}: {
  username = "hz-9000";
  userfullname = "HZ-9000";
  useremail = "hz-9000@proton.me";
  networking = import ./networking.nix {inherit lib;};
  initialHashedPassword = "$6$WreGjotvrl4o.M.p$kOYDJVFKInPMh481pWVnpe/VL23lbJU.ryZZxoD.wmpQQaqVhrI00Uz7s4Rypfp1AVmjGfFB8hprcXUU6vJQz0";
}