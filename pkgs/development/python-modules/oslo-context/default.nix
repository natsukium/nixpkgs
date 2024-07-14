{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  debtcollector,
  oslotest,
  stestr,
  pbr,
}:

buildPythonPackage rec {
  pname = "oslo.context";
  version = "5.5.0";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6uAxeymSjxk030xguGD+hiUkfLKXxcxi/vjrWCexL6w=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dependencies = [
    debtcollector
    pbr
  ];

  nativeCheckInputs = [
    oslotest
    stestr
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_context" ];

  meta = with lib; {
    description = "Oslo Context library";
    homepage = "https://github.com/openstack/oslo.context";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
