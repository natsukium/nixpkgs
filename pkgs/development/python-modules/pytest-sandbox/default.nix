{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-sandbox";
  version = "0.0.1-unstable-2024-06-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natsukium";
    repo = "pytest-sandbox";
    rev = "237992b892f289f380bb8a629bef35ed56bfd843";
    hash = "sha256-UUo/y8GwkGt59CMuFRdwKbnf0raFLr4mE2NuiNfAHFI=";
  };

  build-system = [ pdm-backend ];

  buildInputs = [ pytest ];

  pythonImportsCheck = [ "pytest_sandbox" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "-m 'not network'" ];

  meta = with lib; {
    description = "Disable network access in pytest and mark xfail";
    homepage = "https://github.com/natsukium/pytest-sandbox";
    changelog = "https://github.com/natsukium/pytest-sandbox/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
