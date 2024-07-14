{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  isPy27,
  zope-interface,
  zope-location,
  zope-schema,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope.copy";
  version = "4.3";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-epg2yjqX9m1WGzYPeGUBKGif4JNAddzg75ECe9xPOlc=";
  };

  dependencies = [ zope-interface ];

  doCheck = !isPy27; # namespace conflicts
  nativeCheckInputs = [
    unittestCheckHook
    zope-location
    zope-schema
  ];

  unittestFlagsArray = [
    "-s"
    "src/zope/copy"
  ];

  meta = {
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
