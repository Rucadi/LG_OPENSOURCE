{ stdenv, cacert, curl, aria2 }:
{
  fileId,
  filename,
  model,
  osSeq,
  type,
  hash
}:
stdenv.mkDerivation {
    name = "${filename}";
    dontUnpack = true;
    nativeBuildInputs = [ curl cacert ];
    buildPhase = ''
    # setup cacert env vars and ssl
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
      export SSL_CERT_DIR=${cacert}/etc/ssl/certs
    # download the package
      curl -s -o "$out" -X POST \
        -d "osSeq=${toString osSeq}" \
        -d "fileType=${toString type}" \
        -d "fileIdx=${toString fileId}" \
        -d "modelName=${toString model}" \
        "https://opensource.lge.com/download/releaseFile"
    '';

    dontInstall = true;
    dontFixup = true;

    outputHash = hash;
    outputHashAlgo = "sha256";
    outputHashMode = "flat";
  }
 