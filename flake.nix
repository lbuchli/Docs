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
          cetz_0_3_4
          fletcher_0_5_8
        ]);
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "cheatsheets";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [ typstWithDeps ];

          buildPhase = ''
            for file in cheatsheets/*.typ; do
                typst compile "$file"
            done
            chmod +x generate_listing.sh && ./generate_listing.sh > index.html
          '';

          installPhase = ''
            mkdir -p $out
            cp cheatsheets/*.pdf index.html $out/
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
