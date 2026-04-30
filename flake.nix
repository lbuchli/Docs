{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        typstWithDeps = pkgs.typst.withPackages (ps: with ps; [
          cetz_0_4_2
          cetz-plot_0_1_3
          oxifmt_0_2_1
          fletcher_0_5_8
          presentate_0_2_5
        ]);
        fontsConf = pkgs.makeFontsConf {
            fontDirectories = with pkgs; [
                noto-fonts
            ];
        };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "docs";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [
            typstWithDeps
            pkgs.tree
          ];
        FONTCONFIG_FILE = "${fontsConf}";

          buildPhase = ''
            find content/ -type d -name "_*" -prune -o -type f -name "*.typ" -print0 | xargs -0L1 typst compile --root content/
            typst compile --features html --format html --input "content=$(tree -J content/)" index.typ
          '';

          installPhase = ''
            mkdir -p $out
            find content/ -type d -name "_*" -prune -o -type f -name "*.pdf" -exec cp --parents {} $out \;
            cp index.html LICENSE-*.txt $out/
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            typstWithDeps
            tinymist
          ];
        };
      });
}
