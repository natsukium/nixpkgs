{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, wheel
, numpy
, pandas
, pyyaml
, seaborn
, torch
, torchvision
, tqdm
}:

buildPythonPackage rec {
  pname = "mup";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mup";
    rev = "refs/tags/v${version}";
    hash = "sha256-5mwYh/pYt0jC9x0qQg/Ixrr2exyRuXanrTKoVAjz0tg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    pyyaml
    seaborn
    torch
    torchvision
    tqdm
  ];

  # requires network access
  doCheck = false;

  pythonImportsCheck = [ "mup" ];

  meta = with lib; {
    description = "Maximal update parametrization (µP)";
    homepage = "https://github.com/microsoft/mup";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
