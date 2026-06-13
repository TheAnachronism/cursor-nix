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
  version = "2026.06.12-19-59-36-f6aba9a";

  src = fetchurl {
    url = "https://downloads.cursor.com/lab/${finalAttrs.version}/linux/x64/agent-cli-package.tar.gz";
    hash = "sha256-bn8gLdiHW1adZ0VkvmN28Pb7X35F/dlztZuE8zzJoeQ=";
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
