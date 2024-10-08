{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "double-entry-generator";
  version = "2.7.1";
  src = fetchFromGitHub {
    owner = "deb-sig";
    repo = "double-entry-generator";
    hash = "sha256-2Y8Spj1LAVZsUgChDYDCZ63pTH+nqs2ff9xcmC+gr0c=";
    rev = "v${version}";
  };

  vendorHash = "sha256-Xedva9oGteOnv3rP4Wo3sOHIPyuy2TYwkZV2BAuxY4M=";

  postInstall = ''
    rm $out/bin/hack
  '';

  meta = with lib; {
    description = "Rule-based double-entry bookkeeping importer (from Alipay/WeChat/Huobi etc. to Beancount/Ledger).";
    homepage = "https://github.com/deb-sig/double-entry-generator";
    license = licenses.asl20;
  };
}
