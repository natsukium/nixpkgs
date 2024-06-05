{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-freezer,
  pytest-sandbox,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "easyenergy";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-easyenergy";
    rev = "refs/tags/v${version}";
    hash = "sha256-UHCwxdtziWIZMf3ORIZoQFE3MI8qbBQo5PEbvppvwD4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"' \
      --replace 'addopts = "--cov"' ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-freezer
    pytest-sandbox
    pytestCheckHook
  ];

  pythonImportsCheck = [ "easyenergy" ];

  meta = with lib; {
    description = "Module for getting energy/gas prices from easyEnergy";
    homepage = "https://github.com/klaasnicolaas/python-easyenergy";
    changelog = "https://github.com/klaasnicolaas/python-easyenergy/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
