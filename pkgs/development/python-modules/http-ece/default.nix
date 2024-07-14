{
  lib,
  buildPythonPackage,
  setuptools,
  cryptography,
  fetchPypi,
  mock,
  nose,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "http-ece";
  version = "1.2.0";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    pname = "http_ece";
    inherit version;
    hash = "sha256-tZIPjvuOG1+wJXE+Ozb9pUM2JiAQY0sm3B+Y+F0es94=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"nose",' "" \
      --replace-fail '"coverage",' ""
  '';

  dependencies = [ cryptography ];

  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    mock
    nose
  ];

  meta = with lib; {
    description = "Encipher HTTP Messages";
    homepage = "https://github.com/martinthomson/encrypted-content-encoding";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
