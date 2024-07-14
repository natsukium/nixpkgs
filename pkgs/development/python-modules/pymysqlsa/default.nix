{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  pymysql,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "pymysql-sa";
  version = "1.0";

  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit version;
    pname = "pymysql_sa";
    sha256 = "a2676bce514a29b2d6ab418812259b0c2f7564150ac53455420a20bd7935314a";
  };

  dependencies = [
    pymysql
    sqlalchemy
  ];

  meta = with lib; {
    description = "PyMySQL dialect for SQL Alchemy";
    homepage = "https://pypi.python.org/pypi/pymysql_sa";
    license = licenses.mit;
  };
}
