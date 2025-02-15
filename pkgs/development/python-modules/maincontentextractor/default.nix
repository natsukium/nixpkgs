{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  beautifulsoup4,
  html2text,
  trafilatura,
}:

buildPythonPackage rec {
  pname = "maincontentextractor";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "MainContentExtractor";
    inherit version;
    hash = "sha256-aXrMBZCfsveG2c99T/W/vxTkwzWcOm6tx+1EA/wuZuU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    html2text
    trafilatura
  ];

  pythonImportsCheck = [ "main_content_extractor" ];

  # pypi tarball does not contain tests
  doCheck = false;

  meta = {
    description = "Library to extract the main content from html";
    homepage = "https://pypi.org/project/MainContentExtractor/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
