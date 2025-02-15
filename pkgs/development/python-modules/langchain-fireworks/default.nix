{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  fireworks-ai,
  langchain-core,
  langchain-tests,
  openai,
  poetry-core,
  pytestCheckHook,
  requests,
  syrupy,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langchain-fireworks";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-fireworks==${version}";
    hash = "sha256-6Km0cVW1jWfCemGRsI4Pet0SjvdvkHDRxTqN+7/VKRo=";
  };

  sourceRoot = "${src.name}/libs/partners/fireworks";

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    fireworks-ai
    langchain-core
    openai
    requests
  ];

  pythonImportsCheck = [ "langchain_fireworks" ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
    syrupy
  ];

  disabledTestPaths = [
    # require network access
    "tests/integration_tests/test_chat_models.py"
    "tests/integration_tests/test_embeddings.py"
    "tests/integration_tests/test_llms.py"
    "tests/integration_tests/test_standard.py"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "langchain-fireworks==(.*)"
    ];
  };

  meta = {
    description = "Integration package connecting Fireworks and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/fireworks";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-fireworks==${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
