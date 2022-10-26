{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, rdkit
, scikit-learn
, jax
, jaxlib
, dm-haiku
, optax
, torch
, torchvision
# , dgl
# , dgl-lifesci
, tensorflow
, tensorflow-probability
# , tensorflow-addons
, ...
}:
buildPythonPackage rec {
  pname = "deepchem";
  version = "2.6.1";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    sha256 = "041d5f8f29d9b3da81f7537d34f233c4fd787d8a55043d07974f4a9326a0b723";
  };

  setupPyBuildFlags = [ "--release" ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRemoveDeps = [ "rdkit-pypi" ];

  propagatedBuildInputs = [ scikit-learn rdkit ];

  passthru.optional-dependencies = {
    jax = [
      jax
      jaxlib
      dm-haiku
      optax
    ];
    torch = [
      torch
      torchvision
      # dgl
      # dgl-lifesci
    ];
    tensorflow = [
      tensorflow
      tensorflow-probability
      # tensorflow-addons
    ];
  };

  # main module touches network
  doCheck = false;

  meta = with lib; {
    description = "Deep learning models for drug discovery, quantum chemistry, and the life sciences";
    homepage = "https://deepchem.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
