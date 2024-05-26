let 
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  products_folder_json = builtins.attrNames (builtins.readDir ./products);
in 
builtins.foldl' (prev: now: lib.attrsets.recursiveUpdate prev now) {} (map ( product: builtins.fromJSON (builtins.readFile ./products/${product})) products_folder_json)