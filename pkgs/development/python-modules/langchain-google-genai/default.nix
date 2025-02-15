{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  filetype,
  google-generativeai,
  langchain-core,
  pydantic,
  langchain-tests,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langchain-google-genai";
  version = "2.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-google";
    tag = "libs/genai/v${version}";
    sparseCheckout = [ "libs/genai" ];
    hash = "sha256-bHbpev/vitLYZF5+iqSqQadSLzPoZNv5KqL2SjhrydE=";
  };

  sourceRoot = "${src.name}/libs/genai";

  postPatch = ''
    substituteInPlace tests/unit_tests/test_standard.py \
      --replace-fail "langchain_standard_tests" "langchain_tests"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    filetype
    google-generativeai
    langchain-core
    pydantic
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
  ];

  pytestFlags = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_google_genai" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "langchain-google-genai==(.*)"
      ];
    };
    # updates the wrong fetcher rev attribute
    skipBulkUpdate = true;
  };

  meta = {
    description = "Integration package connecting Google's genai package and LangChain";
    homepage = "https://github.com/langchain-ai/langchain-google/tree/libs/genai";
    changelog = "https://github.com/langchain-ai/langchain-aws/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
