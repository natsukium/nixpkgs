{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-jupyter-builder,
  hatchling,
  async-lru,
  httpx,
  importlib-metadata,
  ipykernel,
  jinja2,
  jupyter-core,
  jupyter-lsp,
  jupyter-server,
  jupyterlab-server,
  notebook-shim,
  packaging,
  setuptools,
  tomli,
  tornado,
  traitlets,
  pythonOlder,
  nodejs,
  yarn-berry_3,
}:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "4.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab";
    tag = "v${version}";
    hash = "sha256-j1K5aBLLGSWER3S0Vojrwdd+9T9vYbp1+XgxYD2NORY=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-Pv2uVGKcIDZxQ6s3w0zBrlF0ukaLkZ75ihAbjypnycg=";
  };

  env.HATCH_JUPYTER_BUILDER_SKIP_NPM = 1;

  build-system = [
    hatch-jupyter-builder
    hatchling
  ];

  dependencies =
    [
      async-lru
      httpx
      ipykernel
      jinja2
      jupyter-core
      jupyter-lsp
      jupyter-server
      jupyterlab-server
      notebook-shim
      packaging
      setuptools
      tornado
      traitlets
    ]
    ++ lib.optionals (pythonOlder "3.11") [ tomli ]
    ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  makeWrapperArgs = [
    "--set"
    "JUPYTERLAB_DIR"
    "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab" ];

  meta = with lib; {
    changelog = "https://github.com/jupyterlab/jupyterlab/blob/v${version}/CHANGELOG.md";
    description = "Jupyter lab environment notebook server extension";
    license = licenses.bsd3;
    homepage = "https://jupyter.org/";
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-lab";
  };
}
