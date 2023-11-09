{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, chardet
, click
, numpy
, openpyxl
, pandas
, pdfminer-six
, pypdf
, tabulate
, ghostscript
, matplotlib
, opencv4
, pytest-mpl
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "camelot-py";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "camelot-dev";
    repo = "camelot";
    rev = "refs/tags/v${version}";
    hash = "sha256-vR/oX3t2npPTrd7RM1GiZwryp88dlJ0fzSgPS36/QXw=";
  };

  postPatch = ''
    substituteInPlace camelot/backends/ghostscript_backend.py \
      --replace "if not self.installed():" "if False:"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    chardet
    click
    numpy
    openpyxl
    pandas
    pdfminer-six
    pypdf
    tabulate
  ] ++ passthru.optional-dependencies.base;

  passthru.optional-dependencies = {
    all = passthru.optional-dependencies.base ++ passthru.optional-dependencies.plot;
    base = [
      ghostscript
      opencv4
      # pdftopng
    ];
    plot = [
      matplotlib
    ];
  };

  doCheck = false;

  nativeCheckInputs = [
    pytest-mpl
    pytest-xdist
    pytestCheckHook
  ] ++ passthru.optional-dependencies.base;

  preCheck = ''
    substituteInPlace setup.cfg \
      --replace "--cov-config .coveragerc --cov-report term --cov-report xml --cov=camelot" ""
  '';

  pythonImportsCheck = [
    "camelot"
  ];

  meta = with lib; {
    description = "A Python library to extract tabular data from PDFs";
    homepage = "http://camelot-py.readthedocs.io";
    changelog = "https://github.com/camelot-dev/camelot/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ _2gn ];
  };
}
