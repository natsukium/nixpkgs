{
  buildPythonPackage,
  setuptools,
  fetchPypi,
  lib,
  param,
  panel,
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "2.2.1";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-omFFuM5D0tk0s8aCbXe5E84QXFKOsuSUyJCz41Jd3zM=";
  };

  dependencies = [ param ];

  # there are not tests with the package
  doCheck = false;

  pythonImportsCheck = [ "pyviz_comms" ];

  passthru.tests = {
    inherit panel;
  };

  meta = with lib; {
    description = "Launch jobs, organize the output, and dissect the results";
    homepage = "https://pyviz.org/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
