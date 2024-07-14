{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  nose,
  pyparsing,
  decorator,
  six,
  future,
}:

buildPythonPackage rec {
  pname = "pycontracts";
  version = "1.8.14";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    pname = "PyContracts";
    inherit version;
    sha256 = "03q5m595ysjrc9h57m7prrca6b9l4yrzvdijnzxnhd61p7jzbh49";
  };

  buildInputs = [ nose ];
  dependencies = [
    pyparsing
    decorator
    six
    future
  ];

  meta = with lib; {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = "https://pypi.python.org/pypi/PyContracts";
    license = licenses.lgpl2;
  };
}
