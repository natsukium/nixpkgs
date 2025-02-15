{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  beautifulsoup4,
  httpx,
  langchain,
  langchain-anthropic,
  langchain-aws,
  langchain-fireworks,
  langchain-google-genai,
  langchain-ollama,
  langchain-openai,
  lmnr,
  maincontentextractor,
  markdownify,
  playwright,
  posthog,
  pydantic,
  python-dotenv,
  requests,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "browser-use";
  version = "0.1.37";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "browser-use";
    repo = "browser-use";
    tag = version;
    hash = "";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = true;

  dependencies = [
    beautifulsoup4
    httpx
    langchain
    langchain-anthropic
    langchain-aws
    langchain-fireworks
    langchain-google-genai
    langchain-ollama
    langchain-openai
    lmnr
    maincontentextractor
    markdownify
    playwright
    posthog
    pydantic
    python-dotenv
    requests
    setuptools
  ];

  pythonImportsCheck = [ "browser_use" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    description = "Make websites accessible for AI agents";
    homepage = "https://github.com/browser-use/browser-use";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
