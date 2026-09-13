{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## IDE
    jetbrains.rider

    ## Godot 4 with C# / .NET support
    godot_4-mono
    godot_4-export-templates-bin

    ## .NET SDK for Godot C# projects and Rider
    dotnet-sdk_8
  ];
}
