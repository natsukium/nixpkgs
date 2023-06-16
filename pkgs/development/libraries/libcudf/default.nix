{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, cudaPackages
, cmake
}:
let
  version = "23.06.00";
  rapids-cmake = fetchurl {
    url = "https://raw.githubusercontent.com/rapidsai/rapids-cmake/branch-${builtins.concatStringsSep "." (lib.take 2 (builtins.splitVersion version))}/RAPIDS.cmake";
    hash = "sha256-QVNdGrckZf4plB5rbF1wJOFmaI8CXwJ4I+4iYrEirKk=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "libcudf";
  inherit version;

  src = fetchFromGitHub {
    owner = "rapidsai";
    repo = "cudf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CTBXTmVZu0qBZI4qHUxnArCmwwoz3fdxwcdpXhGCpOA=";
  };

  sourceRoot = "source/cpp";

  postUnpack = ''
    echo ${rapids-cmake}
    cp ${rapids-cmake} $src/cpp/RAPIDS.cmake
  '';

  nativeBuildInputs = [
    cmake
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [

  ];

  meta = with lib; {
    description = "CuDF - GPU DataFrame Library";
    homepage = "https://github.com/rapidsai/cudf";
    changelog = "https://github.com/rapidsai/cudf/blob/${finalAttr.src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
})
