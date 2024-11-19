{
  pkgs, ...
}:
let
  version = "1.0.1-a.14";
in pkgs.appimageTools.wrapType2 {
    inherit version;
    name = "zen"; # NOTE: This will be the name of the executable in $PATH.
    src = pkgs.fetchurl {
        url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-specific.AppImage";
        hash = "sha256-QE7wA/QksNoQOFVmsV4g0qw+abz8jOUxBHsGR/s2Afc=";
    };

    zen-browser-desktop = pkgs.writeTextDir "share/applications/zen.desktop" ''
              [Desktop Entry]
              Version=1.0.1
              Type=Application
              Name=Zen
              Exec=zen
              Icon=~/tools/icons/zen-browser.png
          '';
}
