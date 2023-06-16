{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonRelaxDepsHook
, biopython
, numpy
, pyparsing
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "prody";
  version = "2.4.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "ProDy";
    inherit version;
    hash = "sha256-ynYOuKF9J/3LBtF+egnOKgXnNxoFX2knhZnfvY/ZUl8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "name='ProDy'" "name='prody'"
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "biopython"
    "numpy"
  ];

  propagatedBuildInputs = [
    biopython
    numpy
    pyparsing
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prody"
  ];

  meta = {
    description = "A Python Package for Protein Dynamics Analysis";
    homepage = "http://prody.csb.pitt.edu/";
    changelog = "https://github.com/prody/ProDy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
