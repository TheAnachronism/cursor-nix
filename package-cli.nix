{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  stdenv,
  zlib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cursor-cli";
  version = "2026.06.24-00-45-58-9f61de7";

  src = fetchurl {
    url = "https://downloads.cursor.com/lab/${finalAttrs.version}/linux/x64/agent-cli-package.tar.gz";
    hash = "sha256-0lQoOpOeF6hwaWsZzelB95fVbfC0N4msuCLWCFT7D4Y=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
  ];

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cursor-cli $out/bin
    tar --strip-components=1 -xzf $src -C $out/lib/cursor-cli

    ln -s "$out/lib/cursor-cli/cursor-agent" $out/bin/agent
    ln -s "$out/lib/cursor-cli/cursor-agent" $out/bin/cursor-agent

    runHook postInstall
  '';

  meta = {
    description = "Cursor CLI agent for terminal-based AI coding assistance";
    homepage = "https://cursor.com/docs/cli/overview";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "agent";
  };
})
