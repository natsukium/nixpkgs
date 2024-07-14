{
  buildPythonPackage,
  setuptools,
  lib,
  fetchPypi,
  xstatic-jquery,
}:

buildPythonPackage rec {
  pname = "xstatic-jquery-ui";
  version = "1.13.0.1";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    pname = "XStatic-jquery-ui";
    inherit version;
    sha256 = "3697e5f0ef355b8f4a1c724221592683c2db031935cbb57b46224eef474bd294";
  };

  # no tests implemented
  doCheck = false;

  dependencies = [ xstatic-jquery ];

  meta = with lib; {
    homepage = "https://jqueryui.com/";
    description = "jquery-ui packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
