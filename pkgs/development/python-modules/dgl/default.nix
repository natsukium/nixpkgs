{lib, stdenv, buildPythonPackage, fetchFromGitHub, cmake , IOKit, setuptools, cython, pipInstallHook, python}:


buildPythonPackage rec {
  pname = "dgl";
  version = "0.9.1";
  format = "other";

  # No source distribution files available in pypi
  src = fetchFromGitHub {
    owner = "dmlc";
    repo = pname;
    rev = version;
    sha256 = "13mv1rvi6gqlza1g661q4ia3f08vh7sz7i2540ari8x3sr99b3s3";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [cmake pipInstallHook];
  cmakeFlags = lib.optional stdenv.isDarwin [
    "-DUSE_OPENMP=off"
    "-DCMAKE_C_FLAGS='-DXBYAK_DONT_USE_MAP_JIT'"
    "-DCMAKE_CXX_FLAGS='-DXBYAK_DONT_USE_MAP_JIT'"
    "-DUSE_AVX=OFF"
    "-DUSE_LIBXSMM=OFF"
  ] ;
  buildInputs = [setuptools cython] ++ lib.optional stdenv.isDarwin IOKit;

  postBuild = ''
    cd ../python
    ${python.interpreter} setup.py bdist_wheel
  '';
}
