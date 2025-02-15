{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  anthropic,
  langchain-core,
  langchain-tests,
  pdm-backend,
  pydantic,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "langchain-anthropic";
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-anthropic==${version}";
    hash = "sha256-ph6ua6aW9wKtQVpErl0jumBOet53cOebARom/ZCtWIo=";
  };

  sourceRoot = "${src.name}/libs/partners/anthropic";

  build-system = [ pdm-backend ];

  dependencies = [
    anthropic
    langchain-core
    pydantic
  ];

  pythonImportsCheck = [ "langchain_anthropic" ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
    syrupy
  ];

  disabledTestPaths = [
    # require network access
    "tests/integration_tests/test_chat_models.py"
    "tests/integration_tests/test_experimental.py"
    "tests/integration_tests/test_llms.py"
    "tests/integration_tests/test_standard.py"
  ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    description = "Integration package connecting AnthropicMessages and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/anthropic";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-anthropic==${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
