{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pybind11,
  setuptools,
  wheel,
  aiohttp,
  diskcache,
  fastapi,
  gptcache,
  msal,
  numpy,
  openai,
  ordered-set,
  platformdirs,
  protobuf,
  pyformlang,
  pytest-sandbox,
  requests,
  tiktoken,
  torch,
  transformers,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "guidance";
  version = "0.1.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "guidance";
    rev = "refs/tags/${version}";
    hash = "sha256-dvIJeSur3DdNBhrEPNPghxqmDEEig59Iz83LWksim6U=";
  };

  nativeBuildInputs = [ pybind11 ];

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    aiohttp
    diskcache
    fastapi
    gptcache
    msal
    numpy
    openai
    ordered-set
    platformdirs
    protobuf
    pyformlang
    requests
    tiktoken
    uvicorn
  ];

  nativeCheckInputs = [
    pytest-sandbox
    pytestCheckHook
    torch
    transformers
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "guidance" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A guidance language for controlling large language models";
    homepage = "https://github.com/guidance-ai/guidance";
    changelog = "https://github.com/guidance-ai/guidance/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
