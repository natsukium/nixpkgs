{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  zope-testing,
  setuptools,
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "9.0.1";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xdzm4LG/W5ziYXaXbCOfQbZYZvaUUih3lWhkLzWqeUc=";
  };

  dependencies = [
    six
    setuptools
    zope-testing
  ];

  # Huge amount of testing dependencies (including Zope2)
  doCheck = false;

  meta = {
    description = "Testing infrastructure for Zope and Plone projects";
    homepage = "https://github.com/plone/plone.testing";
    license = lib.licenses.bsd3;
  };
}
