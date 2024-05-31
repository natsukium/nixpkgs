{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-mock,
  pytest-sandbox,
  pytestCheckHook,
  python-socks,
  pythonOlder,
  setuptools,
  tldextract,
  whodap,
}:

buildPythonPackage rec {
  pname = "asyncwhois";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = "asyncwhois";
    rev = "refs/tags/v${version}";
    hash = "sha256-+FSf2H+IlLJlbZvzSH/Speyt+D2ZdXhQIKJpZYRfIyg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "python-socks[asyncio]" "python-socks"
  '';

  build-system = [ setuptools ];

  dependencies = [
    python-socks
    tldextract
    whodap
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytest-sandbox
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asyncwhois" ];

  meta = with lib; {
    description = "Python module for retrieving WHOIS information";
    homepage = "https://github.com/pogzyb/asyncwhois";
    changelog = "https://github.com/pogzyb/asyncwhois/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
