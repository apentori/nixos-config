/* Custom derivation to avoid hyperland issue*/
{ pkgs ? import <nixpkgs> { } }:
let 
  inherit (pkgs) lib stdenv appimageTools;

  name = "obsidian";
  version = "1.5.12";
  appimage = stend.mkDerivation {
    name =  "${name}-appimage";
    src = pkg.fetchurl {
      url  = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}.AppImage";
    };
    dontBuild = true;
    dontInstall = true;
  };
in appimageTools.wrapType1 {
  name = "${name}-${version}";
  src = appimage;

  meta = with lib; {
    description = "private and flexible writing app";
    homepage= "https://obsidian.md"
    platforms = [ "x86_64-linux" ];
  }
}

