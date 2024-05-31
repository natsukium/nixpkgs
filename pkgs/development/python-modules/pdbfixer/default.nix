{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  numpy,
  openmm,
  pytest-sandbox,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pdbfixer";
  version = "1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openmm";
    repo = "pdbfixer";
    rev = version;
    hash = "sha256-ZXQWdNQyoVgjpZj/Wimcfwcbxk3CIvg3n5S1glNYUP4=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    openmm
  ];

  nativeCheckInputs = [
    pytest-sandbox
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # cli tests require network access
    "test_pdbid"
    "test_url"
  ];

  pythonImportsCheck = [ "pdbfixer" ];

  meta = with lib; {
    description = "PDBFixer fixes problems in PDB files";
    homepage = "https://github.com/openmm/pdbfixer";
    changelog = "https://github.com/openmm/pdbfixer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "pdbfixer";
  };
}
