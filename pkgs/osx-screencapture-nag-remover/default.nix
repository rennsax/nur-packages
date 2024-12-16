{
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "screencapture-nag-remover";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "luckman212";
    repo = "screencapture-nag-remover";
    rev = version;
    hash = "sha256-IXpDTAKAECfyRhXDhKJq/8HacmhpJaxIKq0i9XW21o8=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    install -D ./screencapture-nag-remover.sh $out/bin/screencapture-nag-remover

    runHook postInstall
  '';

  # Just use /bin/bash.
  dontPatchShebangs = true;
}
