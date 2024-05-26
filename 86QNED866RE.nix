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
  hash = "sha256-nIKfneJKyn3SXkBWxx9DmHl2ThgWmB6Pr0jPmVzLuTk=";
})
(lg_oss_fetcher {
  fileId = "2";
  filename = "webOS 23 KHP+_1.0_2.tar.gz";
  model = "86QNED866RE";
  osSeq = "511215";
  type = "Op";
  hash = "sha256-hvM/v8QOeI2OcEDNJ8Gs+oSctLbX6fh9PHPggMl7NJE=";
})
(lg_oss_fetcher {
  fileId = "3";
  filename = "webOS 23 KHP+_1.0_3.tar.gz";
  model = "86QNED866RE";
  osSeq = "511215";
  type = "Op";
  hash = "sha256-EwwOMvGlQCZhj/jASECkGQQ51uw9dUM1UdtjNS7Gcrs=";
})

  ];
in
pkgs.stdenv.mkDerivation {
  name = "86QNED866RE";
  src = sources;
  sourceRoot = ".";
  buildPhase = "mkdir $out && cp -R * $out";
}
