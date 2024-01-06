{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
}:
mkYarnPackage rec {
  pname = "secretlint";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "secretlint";
    repo = "secretlint";
    rev = "refs/tags/v${version}";
    hash = "sha256-eDpCAZQkcK1lhaWTWzjGQxcx7tX/DxMV4a0GCatHDo0=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace "turbo run build" "turbo run build --no-cache --cache-dir $TMPDIR"
  '';

  packageJson = "${src}/package.json";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-+yOoJh1qSnGDxP9+uk9LyDqAP4w2HjVj09lHWXQOF2Y=";
  };

  preBuild = ''
    export HOME=$TMPDIR
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    runHook postInstall
  '';

  meta = with lib; {
    description = "Pluggable linting tool to prevent committing credential";
    homepage = "https://github.com/secretlint/secretlint";
    changelog = "https://github.com/secretlint/secretlint/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [natsukium];
    mainProgram = "secretlint";
  };
}
