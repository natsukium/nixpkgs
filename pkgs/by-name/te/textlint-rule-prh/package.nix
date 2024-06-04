{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  runCommand,
  textlint-rule-prh,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "textlint-rule-prh";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "textlint-rule";
    repo = "textlint-rule-prh";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-K2WkHh7sLnhObM2ThvdXVbZymLInjSB6XTshxALotKU=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-tZMMadWue85L+5c7swKgFqUsLSARjS4EK0Cwi1FjX88=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install
    rm -r test
    mkdir -p $out/lib/node_modules/textlint-rule-prh
    cp -r . $out/lib/node_modules/textlint-rule-prh/

    runHook postInstall
  '';

  passthru.tests = {
    "textlint-rule-prh-test" =
      runCommand "textlint-rule-prh-test"
        { nativeBuildInputs = [ (textlint.withPackages [ textlint-rule-prh ]) ]; }
        ''
          cp ${./textlintrc.json} .textlintrc
          cp ${./prh-rule.yaml} prh-rule.yaml
          grep prh <(textlint ${./test.md}) > $out
        '';
  };

  meta = {
    description = "Textlint rule for prh";
    homepage = "https://github.com/textlint-rule/textlint-rule-prh";
    changelog = "https://github.com/textlint-rule/textlint-rule-prh/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = textlint.meta.platforms;
  };
})
