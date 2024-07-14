{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  django,
}:
let
  version = "0.1.20";
in
buildPythonPackage {
  pname = "django-mdeditor";
  inherit version;

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "pylixm";
    repo = "django-mdeditor";
    rev = "v${version}";
    hash = "sha256-t57j1HhjNQtBwlbqe4mAHQ9WiNcIhMKYmrZkiqh+k5k=";
  };

  dependencies = [ django ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "mdeditor" ];

  meta = with lib; {
    description = "Markdown Editor plugin application for django based on Editor.md";
    homepage = "https://github.com/pylixm/django-mdeditor";
    changelog = "https://github.com/pylixm/django-mdeditor/releases";
    license = licenses.gpl3;
    maintainers = with maintainers; [ augustebaum ];
  };
}
