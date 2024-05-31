{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  arviz,
  formulae,
  graphviz,
  pandas,
  pymc,
  blackjax,
  numpyro,
  pytest-sandbox,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bambi";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = "bambi";
    rev = "refs/tags/${version}";
    hash = "sha256-9+uTyV3mQlHOKAjXohwkhTzNe/+I5XR/LuH1ZYvhc8I=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    arviz
    formulae
    graphviz
    pandas
    pymc
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    blackjax
    numpyro
    pytest-sandbox
    pytestCheckHook
  ];

  disabledTests = [
    # TypeError: Only tensors with the same number of dimensions can be joined.
    "test_predict_new_groups"
  ];

  pythonImportsCheck = [ "bambi" ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/bambi";
    description = "High-level Bayesian model-building interface";
    changelog = "https://github.com/bambinos/bambi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    # https://github.com/NixOS/nixpkgs/issues/310940
    broken = true;
  };
}
