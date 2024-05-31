{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  writeText,
  catboost,
  cloudpickle,
  ipython,
  lightgbm,
  lime,
  matplotlib,
  nose,
  numba,
  numpy,
  oldest-supported-numpy,
  opencv4,
  pandas,
  pyspark,
  pytest-mpl,
  pytest-sandbox,
  scikit-learn,
  scipy,
  sentencepiece,
  setuptools,
  setuptools-scm,
  slicer,
  tqdm,
  transformers,
  xgboost,
}:

buildPythonPackage rec {
  pname = "shap";
  version = "0.45.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "slundberg";
    repo = "shap";
    rev = "refs/tags/v${version}";
    hash = "sha256-REMAubT9WRe0exfhO4UCLt3FFQHq4HApHnI6i2F/V1o=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cloudpickle
    numba
    numpy
    pandas
    scikit-learn
    scipy
    slicer
    tqdm
  ];

  passthru.optional-dependencies = {
    plots = [
      matplotlib
      ipython
    ];
    others = [ lime ];
  };

  preCheck = ''
    export HOME=$TMPDIR
    rm -r shap
  '';

  nativeCheckInputs = [
    ipython
    matplotlib
    nose
    pytest-mpl
    pytest-sandbox
    pytestCheckHook
    # optional dependencies, which only serve to enable more tests:
    catboost
    lightgbm
    opencv4
    pyspark
    sentencepiece
    #torch # we already skip all its tests due to slowness, adding it does nothing
    transformers
    xgboost
  ];

  # Test startup hangs with 0.43.0 and Hydra ends with a timeout
  doCheck = false;

  disabledTestPaths = [
    # The resulting plots look sane, but does not match pixel-perfectly with the baseline.
    # Likely due to a matplotlib version mismatch, different backend, or due to missing fonts.
    "tests/plots/test_summary.py" # FIXME: enable
  ];

  disabledTests = [
    # The same reason as above test_summary.py
    "test_random_force_plot_negative_sign"
    "test_random_force_plot_positive_sign"
    "test_random_summary_layered_violin_with_data2"
    "test_random_summary_violin_with_data2"
    "test_simple_bar_with_cohorts_dict"
  ];

  pythonImportsCheck = [ "shap" ];

  meta = with lib; {
    description = "A unified approach to explain the output of any machine learning model";
    homepage = "https://github.com/slundberg/shap";
    changelog = "https://github.com/slundberg/shap/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      evax
      natsukium
    ];
  };
}
