{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, git
, jupyter-server
, hatch-nodejs-version
, hatchling
, jupyterlab
, nbdime
, nbformat
, pexpect
, pytest-asyncio
, pytest-tornasync
, pytestCheckHook
, pythonOlder
, traitlets
}:

buildPythonPackage rec {
  pname = "jupyterlab-git";
  version = "0.43.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "jupyterlab_git";
    inherit version;
    hash = "sha256-6qV6H0fwtxIE182fMVU8w3YAW/P8hV6MwyHCgeywNlw=";
  };

  nativeBuildInputs = [
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  propagatedBuildInputs = [
    jupyter-server
    nbdime
    git
    nbformat
    pexpect
    traitlets
  ];

  nativeCheckInputs = [
    jupyterlab
    pytest-asyncio
    pytest-tornasync
    pytestCheckHook
  ];

  # All Tests on darwin fail or are skipped due to sandbox
  doCheck = !stdenv.isDarwin;

  disabledTestPaths = [
    "jupyterlab_git/tests/test_handlers.py"
    # PyPI doesn't ship all required files for the tests
    "jupyterlab_git/tests/test_config.py"
    "jupyterlab_git/tests/test_integrations.py"
    "jupyterlab_git/tests/test_remote.py"
    "jupyterlab_git/tests/test_settings.py"
  ];

  disabledTests = [
    "test_Git_get_nbdiff_file"
    "test_Git_get_nbdiff_dict"
  ];

  pythonImportsCheck = [
    "jupyterlab_git"
  ];

  meta = with lib; {
    description = "Jupyter lab extension for version control with Git";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ chiroptical ];
    # https://github.com/jupyterlab/jupyterlab-git/issues/1245
    broken = versionAtLeast jupyterlab.version "4";
  };
}
