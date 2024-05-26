let 
  pkgs = import <nixpkgs> {};
  lg_oss_fetcher = pkgs.callPackage ./lg_oss_fetcher.nix {};
  notices = [
    (lg_oss_fetcher {
  fileId = "1";
  filename = "OSSNotice-5646_webOS 23 KKF for Monitor_1.0_230726.html";
  model = "27SR50F-WA";
  osSeq = "511464";
  type = "Li";
  hash = "";
})

  ];
  sources = [
    (lg_oss_fetcher {
  fileId = "1";
  filename = "webOS 23 KKF for Monitor_1.0_1.tar.gz";
  model = "27SR50F-WA";
  osSeq = "511464";
  type = "Op";
  hash = "sha256-nIKfneJKyn3SXkBWxx9DmHl2ThgWmB6Pr0jPmVzLuTk=";
})
(lg_oss_fetcher {
  fileId = "2";
  filename = "webOS 23 KKF for Monitor_1.0_2.tar.gz";
  model = "27SR50F-WA";
  osSeq = "511464";
  type = "Op";
  hash = "sha256-K0pGscXaJbpQcc15k380J0ISV3Y6JFu6JbnUrOXBARI=";
})
(lg_oss_fetcher {
  fileId = "3";
  filename = "webOS 23 KKF for Monitor_1.0_3.tar.gz";
  model = "27SR50F-WA";
  osSeq = "511464";
  type = "Op";
  hash = "sha256-EwwOMvGlQCZhj/jASECkGQQ51uw9dUM1UdtjNS7Gcrs=";
})

  ];
in
pkgs.stdenv.mkDerivation {
  name = "27SR50F-WA";
  src = sources;
  sourceRoot = ".";
  buildPhase = "mkdir $out && cp -R * $out";
  dontFixup = true;
  dontPatchELF = true;
}
