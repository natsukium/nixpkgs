{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "kaleido";
  version = "0.2.1.post1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "Kaleido";
    rev = "v${version}";
    hash = "sha256-D9ttX1EefoM9KN6kdXqk/SgGCKE1vv8ayxbl8A1rJHg=";
  };

  preBuild = ''
    echo ${version} > ./repos/kaleido/version
    cp ./README.md ./repos/kaleido/
    cp ./LICENSE.txt ./repos/kaleido/

    cd repos/kaleido/py
  '';

  meta = with lib; {
    description = "Fast static image export for web-based visualization libraries with zero dependencies";
    homepage = "https://github.com/plotly/Kaleido";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
