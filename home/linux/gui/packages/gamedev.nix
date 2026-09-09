{ pkgs, lib, ... }:
let
  androidPackages = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [
      "34"
      "35"
    ];
    abiVersions = [
      "armeabi-v7a"
      "arm64-v8a"
      "x86_64"
    ];
    systemImageTypes = [ "google_apis_playstore" ];
    includeSystemImages = "if-supported";
    includeEmulator = "if-supported";
    includeNDK = true;
    includeCmake = true;
  };

  androidSdk = androidPackages.androidsdk;
  androidHome = "${androidSdk}/libexec/android-sdk";
in
{
  home.packages = with pkgs; [
    ## IDE
    jetbrains.rider

    ## Godot 4 with C# / .NET support
    godot_4-mono
    godot_4-export-templates-bin

    ## .NET SDK for Godot C# projects and Rider
    dotnet-sdk_8

    ## 3D modeling and animation
    blender

    ## Android export, testing, and Play Store packaging
    androidSdk
    jdk17
    gradle
    scrcpy
    bundletool

    ## Mobile-friendly asset tooling
    ffmpeg
    pngquant
  ];

  home.sessionVariables = {
    ANDROID_HOME = androidHome;
    ANDROID_SDK_ROOT = androidHome;
    ANDROID_NDK_ROOT = "${androidHome}/ndk-bundle";
    JAVA_HOME = pkgs.jdk17.home;
  };

  home.file.".local/share/godot/export_templates".source =
    "${pkgs.godot_4-export-templates-bin}/share/godot/export_templates";
}
