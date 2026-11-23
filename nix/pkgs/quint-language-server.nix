{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "quint-language-server";
  version = "0.19.0";

  # The repository tags only the quint CLI, not the language server, so pin
  # the "VSCode Release v0.19.0" commit instead of a tag.
  src = fetchFromGitHub {
    owner = "informalsystems";
    repo = "quint";
    rev = "cd48c45ab17f524415f9d72df60d8c3c59c5e4cb";
    hash = "sha256-62A3Q+4xAq0c7sXtpWIOgLO+Y6DdGMKGHKyLVDD3oDY=";
  };

  sourceRoot = "${finalAttrs.src.name}/vscode/quint-vscode/server";

  npmDepsHash = "sha256-BT5KN9E5aRUIJQR0zGlT00tDmRpS2oFF/yOdQOPIGgQ=";

  # Upstream compiles inside the extension's tree, where vscode-languageclient
  # is resolvable from the parent node_modules. The server's own lockfile lacks
  # it, so tsc fails. The import is type-only, and vscode-languageserver
  # exports the same MarkupContent type.
  postPatch = ''
    substituteInPlace src/complete.ts \
      --replace-fail "from 'vscode-languageclient'" "from 'vscode-languageserver'"
  '';

  npmBuildScript = "compile";

  meta = {
    description = "Language server for the Quint specification language";
    homepage = "https://github.com/informalsystems/quint";
    license = lib.licenses.asl20;
    mainProgram = "quint-language-server";
  };
})
