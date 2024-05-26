let 
  pkgs = import <nixpkgs> {};
  _27SR50F-WA = import ./27SR50F-WA.nix;
in
pkgs.stdenv.mkDerivation {
  name = "27SR50F-WA";
  dontUnpack = true;
  buildPhase =  ''
  mkdir $out
  tar -xzf ${_27SR50F-WA}/kkf/linux-nbr4tv.179.tar.gz
  mv linux-5.4/* $out
  '';
  dontFixup = true;
  dontPatchELF = true;
}
