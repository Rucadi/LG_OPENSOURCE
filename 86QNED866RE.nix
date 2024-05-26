let 
  pkgs = import <nixpkgs> {};
  lg_oss_fetcher = pkgs.callPackage ./lg_oss_fetcher.nix {};
  notices = [
    (lg_oss_fetcher {
  fileId = "1";
  filename = "OSSNotice-4668_webOS 23 KHP+_1.0_221220.html";
  model = "86QNED866RE";
  osSeq = "511215";
  type = "Li";
  hash = "sha256-wH0hROXjdWJnKInscrBkegKioFWyBRkJeSKIV1DCBCg=";
})

  ];
  sources = [
    (lg_oss_fetcher {
  fileId = "1";
  filename = "webOS 23 KHP+_1.0_1.tar.gz";
  model = "86QNED866RE";
  osSeq = "511215";
  type = "Op";
  hash = "";
})
(lg_oss_fetcher {
  fileId = "2";
  filename = "webOS 23 KHP+_1.0_2.tar.gz";
  model = "86QNED866RE";
  osSeq = "511215";
  type = "Op";
  hash = "";
})
(lg_oss_fetcher {
  fileId = "3";
  filename = "webOS 23 KHP+_1.0_3.tar.gz";
  model = "86QNED866RE";
  osSeq = "511215";
  type = "Op";
  hash = "";
})

  ];
in
pkgs.stdenv.mkDerivation {
  name = "86QNED866RE";
  src = sources ++ notices;
  buildPhase = "mkdir $out && cp -R * $out";
}
