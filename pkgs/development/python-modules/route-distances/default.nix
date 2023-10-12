{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, poetry-core
, setuptools
, apted
, optuna
, pandas
, pydantic
, python-dateutil
, pytorch-lightning
, pytorch-tree-lstm
, rdkit
, scikit-learn
, tables
, torch
, pythonRelaxDepsHook
, pytestCheckHook
, pytest-datadir
, pytest-mock
}:

buildPythonPackage rec {
  pname = "route-distances";
  version = "1.1.0";
  format = "pyproject";

  # src = fetchPypi {
  #   inherit pname version;
  #   hash = "sha256-Ki4RV2jU++uEkg5ckg4llCu+0f7UlXQyHBJl6Jq9tII=";
  # };

  src = fetchFromGitHub {
    owner = "MolecularAI";
    repo = "route-distances";
    rev = "refs/tags/v${version}";
    hash = "sha256-qEdVRgMhCVPSyXlfKt/X5MYuTGrODnl/FIvzmv/FmDQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python = ">=3.8,<3.10"' 'python = ">=3.8"'
    substituteInPlace route_distances/tools/train_lstm_model.py \
      --replace "gpus=gpus" "num_nodes=gpus"
  '';

  nativeBuildInputs = [
    poetry-core
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pytorch-lightning"
    "torch"
  ];

  pythonRemoveDeps = [
    "optuna"
    "rdkit"
  ];

  propagatedBuildInputs = [
    apted
    # optuna
    pandas
    pydantic
    python-dateutil
    pytorch-lightning
    pytorch-tree-lstm
    rdkit
    scikit-learn
    tables
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-datadir
    pytest-mock
  ];

  pytestFlagsArray = [
    "tests"
  ];

  pythonImportsCheck = [ "route_distances" ];

  meta = with lib; {
    description = "Models for calculating distances between synthesis routes";
    homepage = "https://github.com/MolecularAI/route-distances";
    changelog = "https://github.com/MolecularAI/route-distances/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
