{
  description = "Flutter flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.android_sdk.accept_license = true;
      };
    in {
      devShell.x86_64-linux =
        let android = pkgs.callPackage ./nix/android.nix { };
        in pkgs.mkShell {
          buildInputs = with pkgs; [
            # from pkgs
            flutter
            jdk11
            #from ./nix/*
            android.platform-tools
            # runtime dep
            xdg-user-dirs
            commitizen
          ];

          # shellHook = ''
            # export GRADLE_USER_HOME=$PWD/.gradle/user
          # '';

          ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
          JAVA_HOME = pkgs.jdk11;
          ANDROID_AVD_HOME = (toString ./.) + "/.android/avd";
          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android.androidsdk}/libexec/android-sdk/build-tools/33.0.0/aapt2";
        };
    };
}
