{
  type ? "TV/AV>TV",
  model ? "86QNED866RE",
  json_path ? ./lg_oss_raw/merged.json
}:
let 
  pkgs = import <nixpkgs> {};
  lg_oss = builtins.fromJSON (builtins.readFile json_path);
  definition = lg_oss."${type}"."${model}";
in
{
  definition = definition;
base = pkgs.writeText "${model}.nix" ''
let 
  pkgs = import <nixpkgs> {};
  lg_oss_fetcher = pkgs.callPackage ./lg_oss_fetcher.nix {};
  notices = [
    ${builtins.foldl' (prev: now: prev + ''
      (lg_oss_fetcher {
        fileId = "${now.fileId}";
        filename = "${now.filename}";
        model = "${now.model}";
        osSeq = "${now.osSeq}";
        type = "${now.type}";
        hash = "";
      })
    '') "" definition.notice}
  ];
  sources = [
    ${builtins.foldl' (prev: now: prev + ''
      (lg_oss_fetcher {
        fileId = "${now.fileId}";
        filename = "${now.filename}";
        model = "${now.model}";
        osSeq = "${now.osSeq}";
        type = "${now.type}";
        hash = "";
      })
    '') "" definition.source}
  ];
in
pkgs.stdenv.mkDerivation {
  name = "${model}";
  src = sources ++ notices;
  buildPhase = "mkdir $out && cp -R * $out";
}
'';
}