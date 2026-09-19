{ ... }:
let

  branch = {
    keyColor = "38;5;240";
  };
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      display.separator = " ";

      modules = [
        {
          type = "custom";
          format = "";
        }
        {
          type = "custom";
          format = "";
        }
        {
          type = "custom";
          format = "┌──────────────── Hardware ────────────────┐";
        }
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
        {
          type = "custom";
          format = "└──────────────────────────────────────────┘";
        }
        {
          type = "custom";
          format = "┌──────────────── Software ────────────────┐";
        }
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
        {
          type = "custom";
          format = "└──────────────────────────────────────────┘";
        }
      ];
    };
  };
}
