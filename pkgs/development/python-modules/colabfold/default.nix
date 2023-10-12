{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
    ,pytestCheckHook
    ,pythonRelaxDepsHook
    ,absl-py
    ,alphafold-colabfold
    ,appdirs
    ,biopython
    ,dm-haiku
    ,importlib-metadata
    ,jax
    ,matplotlib
    ,numpy
    ,pandas
    ,poetry-core
    ,py3dmol
    ,requests
    ,tensorflow
    ,tqdm
}:

buildPythonPackage rec {
  pname = "colabfold";
  version = "1.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sokrypton";
    repo = "ColabFold";
    rev = "refs/tags/v${version}";
    hash = "sha256-CDAam+CQjyAVqOhiAO9+FYQG/EC9A307TOzWwumD59k=";
  };

  patches = [
    (fetchpatch {
      name = "fix-python-version-constraint.patch";
      url = "https://github.com/sokrypton/ColabFold/commit/5b3fc193e880cd9599f91cd16fcb1fe69f7759f2.patch";
      hash = "sha256-a3SjyvVfc5hqhhyi0N4UlkwATz5c20xNbTcAbGeGJcM=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "tensorflow-cpu" "tensorflow"
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "importlib-metadata"
  ];

  propagatedBuildInputs = [
    absl-py
    appdirs
    biopython
    dm-haiku
    importlib-metadata
    matplotlib
    numpy
    pandas
    py3dmol
    requests
    tensorflow
    tqdm
  ] ++ passthru.optional-dependencies.alphafold-minus-jax;

  passthru.optional-dependencies = {
      alphafold = [
        alphafold-colabfold
        jax
      ];
      alphafold-minus-jax = [
        alphafold-colabfold
      ];
    };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    "test_batch"
    "test_zip"
    "test_single_sequence"
    "test_complex"
    "test_complex_ptm"
    "test_complex_monomer_ptm"
    "test_complex_monomer"
  ];

  pythonImportsCheck = [ "colabfold" ];

  meta = {
    description = "Making Protein folding accessible to all";
    homepage = "https://github.com/sokrypton/ColabFold";
    changelog = "https://github.com/sokrypton/ColabFold/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
