{
  lib,
  stdenv,
  fetchFromGitHub,
  CoreServices,
}:

stdenv.mkDerivation rec {
  pname = "tbox";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "tboox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cwpZ7F8WzT/46HrckHe0Aug2mxirCkNA68aCxg/FcsE=";
  };

  outputs = [
    "out"
    "static"
    "dev"
  ];

  configureFlags = [ "--demo=n" ];

  # REVIEW: remove this line when upgrading to next version.
  patches = [ ./0001-update-configure.patch ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin CoreServices;

  # NOTE: Hacky script, configure twice and build twice, because xmake's
  # configure script does not support build shared and static libraries
  # together. Luckily, the intermediate products are reused.
  buildCommand = ''
    runPhase unpackPhase
    runPhase patchPhase

    runPhase configurePhase
    runPhase buildPhase
    runPhase installPhase

    prependToVar configureFlags --kind=shared
    runPhase configurePhase
    runPhase buildPhase
    runPhase installPhase

    moveToOutput "lib/*.a" $static

    mkdir -p $dev/lib/pkgconfig
    cat > $dev/lib/pkgconfig/libtbox.pc << EOF
    Name: tbox
    Version: ${version}
    Description: A glib-like cross-platform C library
    Libs: -L$out/lib -ltbox
    Cflags: -I$dev/include
    EOF
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Glib-like multi-platform c library";
    homepage = "https://docs.tboox.org";
    license = licenses.asl20;
  };
}
