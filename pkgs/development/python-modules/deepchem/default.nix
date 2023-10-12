{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, joblib
, numpy
, pandas
, scikit-learn
, scipy
, rdkit
, pythonAtLeast
, pythonOlder
, pytestCheckHook
, flaky
, jax
, jaxlib
, dm-haiku
, optax
, torch
, torchvision
, pytorch-lightning
, tensorflow
, tensorflow-probability
, vina
, biopython
, pymatgen
, openmm
, pdbfixer
, mdtraj
, pytest-xdist
, gensim

, hh-suite
}:

buildPythonPackage rec {
  pname = "deepchem";
  version = "2.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7" || pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "deepchem";
    repo = "deepchem";
    rev = version;
    hash = "sha256-hT8z4PLgsfDWTWAQnpCUI632lNiaD1QqG/byhKZi8k8=";
  };

  setupPyBuildFlags = [
    "--release"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    joblib
    numpy
    pandas
    rdkit
    scikit-learn
    scipy
  ];

  passthru.optional-dependencies = {
    jax = [
      dm-haiku
      jax
      jaxlib
      optax
    ];
    torch = [
      # dgl
      # dgllife
      pytorch-lightning
      torch
      torchvision
    ];
    tensorflow = [
      tensorflow
      # tensorflow-addons
      tensorflow-probability
    ];
    dqc = [
      # dqc
      # pylibxc2
      torch
      # xitorch
    ];
  };

  pythonRemoveDeps = [
    "rdkit"
  ];

  pythonRelaxDeps = [
    "scipy"
  ];

  nativeCheckInputs = [
    # pytest-xdist
    biopython
    flaky
    gensim
    hh-suite
    mdtraj
    openmm
    pdbfixer
    pymatgen
    pytestCheckHook
    vina
  ];

  pytestFlagsArray = [
    "deepchem"
    "-m 'not jax and not torch and not tensorflow and not dqc'"
    # "-n $NIX_BUILD_CORES"
  ];

  disabledTests = [
    # missing simdna
    "TestDNASim"
    "test_get_motif_scores"
    # missing pyGPGO
    "TestGaussianHyperparamOpt"
    # missing pubchempy
    "test_pubchem_fingerprint"
    # missing mol2vec
    "test_mol2vec_fingerprint"
    # touch the network
    "test_featurization_transformer"
    "test_gnina_initialization"
    "test_gnina_poses_and_scores"
    "test_prepare_inputs"
    "test_scaffolds"
    "test_smiles_to_image_with_max_len"
    "test_mol_ordering"
  ];

  pythonImportsCheck = [ "deepchem" ];

  meta = with lib; {
    description = "Democratizing Deep-Learning for Drug Discovery, Quantum Chemistry, Materials Science and Biology";
    homepage = "https://github.com/deepchem/deepchem";
    changelog = "https://github.com/deepchem/deepchem/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
