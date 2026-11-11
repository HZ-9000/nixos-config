{ myvars, ... }:
let
  inherit (myvars) theme;

  branch = {
    keyColor = theme.palette.mPrimary;
  };
  frame = {
    type = "custom";
    outputColor = theme.palette.mPrimary;
  };
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      display.separator = " ";

      logo.color = {
        "1" = theme.palette.mPrimary;
        "2" = theme.palette.mSecondary;
        "3" = theme.palette.mPrimary;
        "4" = theme.palette.mSecondary;
        "5" = theme.palette.mPrimary;
        "6" = theme.palette.mSecondary;
      };

      modules = [
        {
          type = "custom";
          format = "";
        }
        {
          type = "custom";
          format = "";
        }
        (
          frame
          // {
            format = "┌──────────────── Hardware ────────────────┐";
          }
        )
        (
          branch
          // {
            type = "cpu";
            key = " ├─  ";
          }
        )
        (
          branch
          // {
            type = "gpu";
            key = " ├─ 󰍛 ";
          }
        )
        (
          branch
          // {
            type = "memory";
            key = " └─ 󰘚 ";
          }
        )
        (
          frame
          // {
            format = "└──────────────────────────────────────────┘";
          }
        )
        (
          frame
          // {
            format = "┌──────────────── Software ────────────────┐";
          }
        )
        (
          branch
          // {
            type = "os";
            key = " ├─ 󰌽 ";
          }
        )
        (
          branch
          // {
            type = "kernel";
            key = " ├─  ";
          }
        )
        (
          branch
          // {
            type = "wm";
            key = " ├─ 󰨇 ";
          }
        )
        (
          branch
          // {
            type = "theme";
            key = " ├─ 󰉼 ";
          }
        )
        (
          branch
          // {
            type = "icons";
            key = " ├─ 󰀻 ";
          }
        )
        (
          branch
          // {
            type = "font";
            key = " ├─ 󰛖 ";
          }
        )
        (
          branch
          // {
            type = "terminal";
            key = " ├─ 󰞷 ";
          }
        )
        (
          branch
          // {
            type = "shell";
            key = " └─ 󰞷 ";
          }
        )
        (
          frame
          // {
            format = "└──────────────────────────────────────────┘";
          }
        )
      ];
    };
  };
}
