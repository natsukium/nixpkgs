{
  lib,
  awkward,
  buildPythonPackage,
  cachetools,
  dask,
  dask-histogram,
  distributed,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  hist,
  pandas,
  pyarrow,
  pytest-sandbox,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  typing-extensions,
  uproot,
}:

buildPythonPackage rec {
  pname = "dask-awkward";
  version = "2024.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-awkward";
    rev = "refs/tags/${version}";
    hash = "sha256-Lkbp/XrDHOekMpT71pbxtuozgzU9iiGF2GJZ+tuV/yM=";
  };

  pythonRelaxDeps = [ "awkward" ];

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    awkward
    cachetools
    dask
    typing-extensions
  ];

  passthru.optional-dependencies = {
    io = [ pyarrow ];
  };

  checkInputs = [
    dask-histogram
    distributed
    hist
    pandas
    pytest-sandbox
    pytestCheckHook
    uproot
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "dask_awkward" ];

  disabledTests = [
    # ValueError: not a ROOT file: first four bytes...
    "test_basic_root_works"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Native Dask collection for awkward arrays, and the library to use it";
    homepage = "https://github.com/dask-contrib/dask-awkward";
    changelog = "https://github.com/dask-contrib/dask-awkward/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
