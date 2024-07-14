{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  isPyPy,
  ply,
  six,
  decorator,
}:

buildPythonPackage rec {
  pname = "jsonpath-rw";
  version = "1.4.0";
  disabled = isPyPy;

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec";
  };

  dependencies = [
    ply
    six
    decorator
  ];

  # ImportError: No module named tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kennknowles/python-jsonpath-rw";
    description = "Robust and significantly extended implementation of JSONPath for Python, with a clear AST for metaprogramming";
    mainProgram = "jsonpath.py";
    license = licenses.asl20;
  };
}
