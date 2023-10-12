{ lib
, config
, buildPythonPackage
, fetchFromGitHub
, which
, ninja
, pybind11
, libaio
, setuptools
, wheel
, hjson
, numpy
, packaging
, psutil
, py-cpuinfo
, pydantic
, torch
, tqdm
, pytestCheckHook
, pytest-xdist
, transformers
, mup
, tabulate
, cudaSupport ? config.cudaSupport
}:

buildPythonPackage rec {
  pname = "deepspeed";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DeepSpeed";
    rev = "refs/tags/v${version}";
    hash = "sha256-LZ3jHMWha8mLKyk0nsWKRO7iP29vUY7op/KG9TkH59U=";
  };

  postPatch = ''
    substituteInPlace op_builder/builder.py \
      --replace "-march=native" "" \
      --replace "self.simd_width()" "'-D__SCALAR__'"
  '';

  nativeBuildInputs = [
    ninja
    setuptools
    wheel
  ];

  buildInputs = [
    libaio
    pybind11
  ];

  propagatedBuildInputs = [
    hjson
    numpy
    packaging
    psutil
    py-cpuinfo
    pydantic
    torch
    tqdm
  ];

  env = let
    buildFlag = x: if x then 1 else 0;
  in {
    # https://www.deepspeed.ai/tutorials/advanced-install/#pre-install-deepspeed-ops
    # DS_BUILD_OPS = 1;
    DS_BUILD_AIO = 1;
    DS_BUILD_CCL_COMM = 1;
    DS_BUILD_CPU_ADAM = 1;
    DS_BUILD_CPU_LION = 1;
    DS_BUILD_EVOFORMER_ATTN = buildFlag cudaSupport;
    DS_BUILD_FUSED_ADAM = 0;
    DS_BUILD_FUSED_LION = 0;
    DS_BUILD_CPU_ADAGRAD = 1;
    DS_BUILD_FUSED_LAMB = 0;
    DS_BUILD_QUANTIZER = 0;
    DS_BUILD_RANDOM_LTD = 0;
    # sparse_attn requires a torch version >= 1.5 and < 2.0
    DS_BUILD_SPARSE_ATTN = buildFlag lib.versionOlder torch.version "2";
    DS_BUILD_TRANSFORMER = 0;
    DS_BUILD_TRANSFORMER_INFERENCE = 0;
    DS_BUILD_STOCHASTIC_TRANSFORMER = 0;
  };

  pipInstallFlags = [
    "--global-option=\"-j$NIX_BUILD_CORES\""
  ];

  passthru.optional-dependencies = {
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    transformers
    mup
    tabulate
    which
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # requires network access
    "tests/unit/inference/test_inference.py"
  ];

  pythonImportsCheck = [ "deepspeed" ];

  meta = with lib; {
    description = "DeepSpeed is a deep learning optimization library that makes distributed training and inference easy, efficient, and effective";
    homepage = "https://github.com/microsoft/DeepSpeed";
    changelog = "https://github.com/microsoft/DeepSpeed/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
