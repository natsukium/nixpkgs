{ lib
, buildPythonPackage
, fetchPypi
, numpy
, torch
}:

buildPythonPackage rec {
  pname = "pytorch-tree-lstm";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uAJtMfUf4Fuu2VlSWLKQjj/Ywz8FaNtlfF21AGwrayw=";
  };

  propagatedBuildInputs = [
    numpy
    torch
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "treelstm" ];

  meta = with lib; {
    description = "A Tree-LSTM model package for PyTorch";
    homepage = "https://pypi.org/project/pytorch-tree-lstm/";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
