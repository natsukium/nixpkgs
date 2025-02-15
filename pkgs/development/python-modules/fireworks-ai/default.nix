{
  lib,
  buildPythonPackage,
  fetchPypi,
  fastapi,
  gitignore-parser,
  httpx,
  httpx-ws,
  httpx-sse,
  openapi-spec-validator,
  pillow,
  prance,
  pydantic,
  safetensors,
  setuptools,
  tabulate,
  torch,
  tqdm,
  versioneer,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fireworks-ai";
  version = "0.15.12";
  pyproject = true;

  src = fetchPypi {
    pname = "fireworks_ai";
    inherit version;
    hash = "sha256-I4ClPZIkTGCP05j42XuXOA2Jnz/3EAkfS1CRe3URnsI=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    httpx
    httpx-ws
    httpx-sse
    pydantic
    pillow
  ];

  optional-dependencies = {
    flumina = [
      fastapi
      gitignore-parser
      openapi-spec-validator
      prance
      safetensors
      tabulate
      torch
      tqdm
    ];
  };

  pythonImportsCheck = [ "fireworks" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python client library for the Fireworks.ai Generative AI Platform";
    homepage = "https://fireworks.ai/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
