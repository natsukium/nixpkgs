{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, pythonOlder
, cmake
, pkg-config
, sqlite
, stdenv
, darwin
}:

buildPythonPackage rec {
  pname = "vl-convert-python";
  version = "0.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vl-convert";
    rev = "v${version}";
    hash = "sha256-PxdpFbQ7KKXjo1Yls6qpv69YmzUuuAANVGv+rvRPGDQ=";
  };

  # postUnpack = ''
  #   cp source/Cargo.lock source/vl-convert-python/
  # '';

  # sourceRoot = "source/vl-convert-python";

  # cargoRoot = "..";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    # sourceRoot = "${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-2u4RbsjCQK/a6LKD4Q4PLpWDWJl81kNA+CKu93eZ6gM=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    cmake
  ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    cd vl-convert-python
  '';

  meta = with lib; {
    description = "Utilities for converting Vega-Lite specs from the command line and Python";
    homepage = "https://github.com/vega/vl-convert";
    changelog = "https://github.com/vega/vl-convert/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ natsukium ];
  };
}
