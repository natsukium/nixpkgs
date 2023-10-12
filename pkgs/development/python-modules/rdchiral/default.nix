{ lib
, buildPythonPackage
, fetchFromGitHub
, rdkit
, python
}:

buildPythonPackage {
  pname = "rdchiral";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "connorcoley";
    repo = "rdchiral";
    rev = "8fae1ffad863d52a427830e1b570612183f0ed2e";
    hash = "sha256-RpGBvUc5TeFMaQXylhuLhmQG3Qy5LclDXBmmtPYpFio=";
  };

  propagatedBuildInputs = [
    rdkit
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} test/test_rdchiral.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "rdchiral" ];

  meta = with lib; {
    description = "Wrapper for RDKit's RunReactants to improve stereochemistry handling";
    homepage = "https://github.com/connorcoley/rdchiral";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
