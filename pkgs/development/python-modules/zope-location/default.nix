{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  zope-proxy,
}:

buildPythonPackage rec {
  pname = "zope.location";
  version = "5.0";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AW/qk0uX2tKwimTqfy+8PeVduwdMRh9m2HHHC/OqrqU=";
  };

  dependencies = [ zope-proxy ];

  # ignore circular dependency on zope-schema
  preBuild = ''
    sed -i '/zope.schema/d' setup.py
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.location/";
    description = "Zope Location";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
