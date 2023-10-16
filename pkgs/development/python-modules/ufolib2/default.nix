{ lib
, buildPythonPackage
, fetchPypi
, attrs
, fonttools
, pytestCheckHook
, pythonOlder
, setuptools-scm

# optionals
, cattrs
, lxml
, orjson
, msgpack
}:

buildPythonPackage rec {
  pname = "ufolib2";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ufoLib2";
    inherit version;
    hash = "sha256-OdUJfNe3nOQyCf3nT9/5y/C8vZXnSAWiLHvZ8GXMViw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    fonttools
  ] ++ fonttools.optional-dependencies.ufo;

  passthru.optional-dependencies = {
    lxml = [ lxml ];
    converters = [ cattrs ];
    json = [ cattrs orjson ];
    msgpack = [ cattrs msgpack ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "ufoLib2" ];

  meta = with lib; {
    description = "Library to deal with UFO font sources";
    homepage = "https://github.com/fonttools/ufoLib2";
    changelog = "https://github.com/fonttools/ufoLib2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
