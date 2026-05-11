{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule rec {
  pname = "fence";
  version = "0.1.57";

  src = pkgs.fetchFromGitHub {
    owner = "Use-Tusk";
    repo = "fence";
    rev = "v${version}";
    hash = "sha256-YX+DqD20hr/+hAXLVddEQjj0J7jybhNNdtQM3tlSPek=";
  };

  vendorHash = "sha256-Qct/M0zuggYzlN0gyO8nF58M5Av3HcYyMjrPab5Crr0=";

  subPackages = [ "cmd/fence" ];

  nativeBuildInputs = [ pkgs.makeWrapper ];

  postFixup = pkgs.lib.optionalString pkgs.stdenv.isLinux ''
    wrapProgram $out/bin/fence \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.bubblewrap pkgs.socat ]}
  '';

  meta = with pkgs.lib; {
    description = "Lightweight, container-free sandbox for running commands with network and filesystem restrictions";
    homepage = "https://fencesandbox.com/";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
