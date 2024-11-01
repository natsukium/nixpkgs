{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  numpy,
  pillow,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

let
  pname = "pydicom";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom";
    rev = "refs/tags/v${version}";
    hash = "sha256-SvRevQehRaSp+vCtJRQVEJiC5noIJS+bGG1/q4p7/XU=";
  };

  # Pydicom needs pydicom-data to run some tests. If these files aren't downloaded
  # before the package creation, it'll try to download during the checkPhase.
  test_data = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom-data";
    rev = "cbb9b2148bccf0f550e3758c07aca3d0e328e768";
    hash = "sha256-nF/j7pfcEpWHjjsqqTtIkW8hCEbuQ3J4IxpRk0qc1CQ=";
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  disabled = pythonOlder "3.10";

  build-system = [ flit-core ];

  dependencies = [
    numpy
    pillow
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Setting $HOME to prevent pytest to try to create a folder inside
  # /homeless-shelter which is read-only.
  # Linking pydicom-data dicom files to $HOME/.pydicom/data
  preCheck = ''
    export HOME=$TMP/test-home
    mkdir -p $HOME/.pydicom/
    ln -s ${test_data}/data_store/data $HOME/.pydicom/data
  '';

  disabledTests =
    [
      # tries to remove a dicom inside $HOME/.pydicom/data/ and download it again
      "test_fetch_data_files"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # https://github.com/pydicom/pydicom/issues/1386
      "test_array"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # flaky, hard to reproduce failure outside hydra
      "test_time_check"
    ];

  pythonImportsCheck = [ "pydicom" ];

  meta = with lib; {
    description = "Python package for working with DICOM files";
    mainProgram = "pydicom";
    homepage = "https://pydicom.github.io";
    changelog = "https://github.com/pydicom/pydicom/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
