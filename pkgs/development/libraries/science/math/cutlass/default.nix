{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudaPackages ? { }
, symlinkJoin
, gtest
, python3
, nvidia-thrust
, cutlass
}:
let
  cuda-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaPackages.cudaVersion}";
    paths = with cudaPackages; [
      cuda_cudart
      cuda_nvcc
      cuda_nvrtc
      libcurand
    ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "cutlass";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-RMSyJukoJeNgLtz65fhWQPNYvsybTCkR1BNVgoNdzCE=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "include(\''${CMAKE_CURRENT_SOURCE_DIR}/cmake/googletest.cmake)" "add_subdirectory(${gtest.src} .. EXCLUDE_FROM_ALL)"
  '';

  nativeBuildInputs = [
    cmake
    cuda-redist
  ];

  cmakeFlags = [
    "-DCUTLASS_ENABLE_HEADERS_ONLY=${if finalAttrs.doCheck then "OFF" else "ON"}"
  ];

  nativeCheckInputs = [
    python3
    nvidia-thrust
  ];

  # build time is too long
  doCheck = false;

  passthru.tests = {
    ctest = cutlass.overrideAttrs { doCheck = true; };
  };

  meta = with lib; {
    description = "CUDA Templates for Linear Algebra Subroutines";
    homepage = "https://github.com/NVIDIA/cutlass";
    changelog = "https://github.com/NVIDIA/cutlass/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ natsukium ];
  };
})
