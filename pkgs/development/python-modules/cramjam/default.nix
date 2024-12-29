{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  autoconf,
  automake,
  cmake,
  libtool,
  libiconv,
  hypothesis,
  numpy,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "pyrus-cramjam";
    tag = "v${version}";
    hash = "sha256-s+dKoZftI+aXcie1quAo/Xmlt1BQrzoCjwesDiaNABY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-AzoWeEXsKpO2AlP3d0PCQnNqJeNx8G829xnA7Ow2sQM=";
  };

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    rustPlatform.cargoSetupHook
    libtool
  ];

  dontUseCmakeConfigure = true;

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  nativeCheckInputs = [
    hypothesis
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [ "cramjam-python/tests" ];

  disabledTestPaths = [
    "cramjam-python/benchmarks/test_bench.py"
    # test_variants.py appears to be flaky
    #
    # https://github.com/NixOS/nixpkgs/pull/311584#issuecomment-2117656380
    "cramjam-python/tests/test_variants.py"
  ];

  pythonImportsCheck = [ "cramjam" ];

  meta = with lib; {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
