{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  mock,
  pytest-sandbox,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "duo-client";
  version = "5.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "duosecurity";
    repo = "duo_client_python";
    rev = "refs/tags/${version}";
    hash = "sha256-7cifxNSBHbX7QZ52Sy1hm5xzZYcLZOkloT6q9P7TO6A=";
  };

  postPatch = ''
    substituteInPlace requirements-dev.txt \
      --replace-fail "dlint" "" \
      --replace-fail "flake8" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [
    freezegun
    mock
    pytest-sandbox
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "duo_client" ];

  meta = with lib; {
    description = "Python library for interacting with the Duo Auth, Admin, and Accounts APIs";
    homepage = "https://github.com/duosecurity/duo_client_python";
    changelog = "https://github.com/duosecurity/duo_client_python/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
