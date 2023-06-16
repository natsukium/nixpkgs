{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, cudaPackages
, cython
, pyarrow
, numpy
}:

buildPythonPackage rec {
  pname = "cudf";
  version = "23.06.00";
  format = "others";

  src = fetchFromGitHub {
    owner = "rapidsai";
    repo = "cudf";
    rev = "v${version}";
    hash = "sha256-CTBXTmVZu0qBZI4qHUxnArCmwwoz3fdxwcdpXhGCpOA=";
  };

  nativeBuildInputs = [
    cmake
    cython
  ];

  buildInputs = [
    cudaPackages.cudatoolkit
  ];

  propagatedBuiltInputs = [
    pyarrow
    numpy
  ];

  pythonImportsCheck = [ "cudf" ];

  meta = with lib; {
    description = "CuDF - GPU DataFrame Library";
    homepage = "https://github.com/rapidsai/cudf";
    changelog = "https://github.com/rapidsai/cudf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
