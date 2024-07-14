{
  buildPythonPackage,
  setuptools,
  colorama,
  fetchPypi,
  isPy27,
  lib,
}:

buildPythonPackage rec {
  pname = "log_symbols";
  version = "0.0.14";
  disabled = isPy27;

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mh5d0igw33libfmbsr1ri1p1y644p36nwaa2w6kzrd8w5pvq2yg";
  };

  dependencies = [ colorama ];

  # Tests are not included in the PyPI distribution and the git repo does not have tagged releases
  doCheck = false;
  pythonImportsCheck = [ "log_symbols" ];

  meta = with lib; {
    description = "Colored Symbols for Various Log Levels";
    homepage = "https://github.com/manrajgrover/py-log-symbols";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
