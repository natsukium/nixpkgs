{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  colander,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "colanderclchemy";
  version = "0.3.4";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "006wcfch2skwvma9bq3l06dyjnz309pa75h1rviq7i4pd9g463bl";
  };

  dependencies = [
    colander
    sqlalchemy
  ];

  # Tests are not included in Pypi
  doCheck = false;

  meta = with lib; {
    description = "Autogenerate Colander schemas based on SQLAlchemy models";
    homepage = "https://github.com/stefanofontanelli/ColanderAlchemy";
    license = licenses.mit;
  };
}
