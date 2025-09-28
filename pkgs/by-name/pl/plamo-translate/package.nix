{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "plamo-translate";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pfnet";
    repo = "plamo-translate-cli";
    tag = version;
    hash = "sha256-dpvshY2kw31UtsFjWbf1shPil3ke5b5Wp+i14ndI098=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies =
    with python3Packages;
    [
      mcp
      numba
    ]
    ++ mcp.optional-dependencies.cli
    ++ lib.optional stdenv.hostPlatform.isDarwin mlx-lm;

  pythonImportsCheck = [
    "plamo_translate"
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Command-line interface for translation using the plamo-2-translate model with local execution";
    homepage = "https://github.com/pfnet/plamo-translate-cli";
    changelog = "https://github.com/pfnet/plamo-translate-cli/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "plamo-translate";
    # currently only supports mlx backend
    platform = lib.platforms.darwin;
  };
}
