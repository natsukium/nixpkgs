{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, deprecated
, ipywidgets
, jinja2
, jupyter
, jupytext
, networkx
, onnxruntime
, pandas
, pillow
, rdchiral
, rdkit
, requests
, tables
, tqdm
, matplotlib
, pymongo
, route-distances
, scipy
, timeout-decorator
, grpcio
, tensorflow
, tensorflow-serving-api
}:

buildPythonPackage rec {
  pname = "aizynthfinder";
  version = "3.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-shJ2LhHPLeMkGuAj9vSsCw4Xpja/0ufoWOagnhlQZos=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    deprecated
    ipywidgets
    jinja2
    jupyter
    jupytext
    networkx
    onnxruntime
    pandas
    pillow
    rdchiral
    rdkit
    requests
    tables
    tqdm
  ];

  passthru.optional-dependencies = {
    all = [
      matplotlib
      pymongo
      route-distances
      scipy
      timeout-decorator
    ];
    tf = [
      grpcio
      tensorflow
      tensorflow-serving-api
    ];
  };

  pythonImportsCheck = [ "aizynthfinder" ];

  meta = with lib; {
    description = "Retrosynthetic route finding using neural network guided Monte-Carlo tree search";
    homepage = "https://github.com/MolecularAI/aizynthfinder";
    changelog = "https://github.com/MolecularAI/aizynthfinder/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
