{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  pytest-sandbox,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "awsipranges";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws-samples";
    repo = "awsipranges";
    rev = "refs/tags/${version}";
    hash = "sha256-ve1+0zkDDUGswtQoXhfESMcBzoNgUutxEhz43HXL4H8=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pyopenssl
    pytest-sandbox
    pytestCheckHook
  ];

  pythonImportsCheck = [ "awsipranges" ];

  meta = with lib; {
    description = "Module to work with the AWS IP address ranges";
    homepage = "https://github.com/aws-samples/awsipranges";
    changelog = "https://github.com/aws-samples/awsipranges/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
