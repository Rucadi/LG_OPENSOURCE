let 
  pkgs = import <nixpkgs> {};
  QNED866RE = import ./86QNED866RE.nix;
in
pkgs.stdenv.mkDerivation {
  name = "86QNED866RE";
  dontUnpack = true;
  buildPhase =  ''
  mkdir $out
  cat "${QNED866RE}/chipset/bsp/kernel-nbr4tv.39_2.tar.gz_00" "${QNED866RE}/chipset/bsp/kernel-nbr4tv.39_2.tar.gz_01" "${QNED866RE}/chipset/bsp/kernel-nbr4tv.39_2.tar.gz_02" | tar -xzf -
  mv kernel/* $out
  '';
  dontFixup = true;
  dontPatchELF = true;
}
