{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ecspresso";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    rev = "refs/tags/v${version}";
    hash = "sha256-3u+WXEvuG/LCZG9qk8sGmITql1o00xZpGNtXmup6cdQ=";
  };

  vendorHash = "sha256-WyjKkNtfZRJUARcn5xdL0MvkhQc0UZORicl8VcpdA1M=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=v${version}"
  ];

  subPackages = [ "cmd/ecspresso" ];

  meta = with lib; {
    description = "A deployment tool for Amazon ECS";
    homepage = "https://github.com/kayac/ecspresso";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "ecspresso";
  };
}
