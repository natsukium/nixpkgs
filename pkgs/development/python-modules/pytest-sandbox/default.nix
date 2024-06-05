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
    rev = "1382273a7b24bfd4ac4a7fc5fdb1568069dd7cb1";
    hash = "sha256-br6NLisnOM5fxgOucPa0t49QKk6Pk58st+KzO2PwhrU=";
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
