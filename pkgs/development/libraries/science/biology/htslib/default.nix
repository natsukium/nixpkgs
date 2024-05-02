{
  lib,
  stdenv,
  fetchurl,
  zlib,
  bzip2,
  xz,
  libdeflate,
  curl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "htslib";
  version = "1.20";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    hash = "sha256-5S2VsU2mjgz9fSf69W/vL4jC6vMqK+UccuFG46qShUQ=";
  };

  buildInputs = [
    zlib
    bzip2
    xz
    curl
    libdeflate
  ];

  configureFlags =
    if !stdenv.hostPlatform.isStatic then
      [ "--enable-libcurl" ] # optional but strongly recommended
    else
      [
        "--disable-libcurl"
        "--disable-plugins"
      ];

  # In the case of static builds, we need to replace the build and install phases
  buildPhase = lib.optional stdenv.hostPlatform.isStatic ''
    make AR=$AR lib-static
    make LDFLAGS=-static bgzip htsfile tabix
  '';

  installPhase = lib.optional stdenv.hostPlatform.isStatic ''
    install -d $out/bin
    install -d $out/lib
    install -d $out/include/htslib
    install -D libhts.a $out/lib
    install  -m644 htslib/*h $out/include/htslib
    install -D bgzip htsfile tabix $out/bin
  '';

  nativeCheckInputs = [ perl ];

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "A C library for reading/writing high-throughput sequencing data";
    license = licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
})
