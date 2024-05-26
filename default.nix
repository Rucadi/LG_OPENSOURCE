let 
  pkgs = import <nixpkgs> {};
  lg_fetcher = pkgs.callPackage ./lg_oss_fetcher.nix {};
in
lg_fetcher {
    fileId = 1;
    filename = "ARCH 2.0a Clova_2.1.1.19.zip";
    model = "AIHC71G";
    osSeq = "509695";
    type = "Op";
    hash = "sha256-qRfnL7gMJdIAiw2Qy6DKAgCzSzZ1EPRJDcxHEj8OEL8=";
}