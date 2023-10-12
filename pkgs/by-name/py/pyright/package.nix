{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, esbuild
, node-glob
, buildGoModule
}:
let
  esbuild' = esbuild.override {
    buildGoModule = _: buildGoModule (_ // rec {
    version = "0.17.19";
    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "refs/tags/v${version}";
      hash = "sha256-PLC7OJLSOiDq4OjvrdfCawZPfbfuZix4Waopzrj8qsU=";
    };
    vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };

  version = "1.1.327";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "pyright";
    rev = "refs/tags/${version}";
    hash = "sha256-GeLbxZvb3V0OZ5p0gSf7o0zaSS5YCqxmMvejIIr1KKU=";
  };


  dev = buildNpmPackage {
    inherit src version;
    pname = "pyright-dev";

    npmDepsHash = "sha256-CK3gGXRyuHWH29QN//bh6Bhec1m1ot7sLU1aw1M8mVU=";

    dontBuild = true;

    # npmFlags = [ "--legacy-peer-deps" ];
    # makeCacheWritable = true;
    preConfigure = ''
      npm cache yocto-queue
    '';

    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';
  };
in

buildNpmPackage {
  pname = "pyright";
  inherit src version;

  sourceRoot = "source/packages/pyright";

  npmDepsHash = "sha256-Kw6ekttBp5WtDWKnCUkxjyCxdybIWamyYrT7UZsgFjs=";

  nativeBuildInputs = [
    dev
  ];

  # env.ESBUILD_BINARY_PATH = "${lib.getExe esbuild'}";

  meta = with lib; {
    description = "Static Type Checker for Python";
    homepage = "https://github.com/microsoft/pyright";
    changelog = "https://github.com/microsoft/pyright/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "pyright";
  };
}
