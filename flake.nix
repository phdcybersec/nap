{
  description = "Code snippets in your terminal 🛌";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:

    utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {

      packages = utils.lib.flattenTree {
        nap = let
          lib = pkgs.lib;
        in pkgs.buildGoModule {
          
          pname = "nap";
          version = "0.1.1";

          # to update this hash:
          # 1. replace by `lib.fakeSha256`
          # 2. run `nix build`
          # 3. copy the new hash (it will be printed in the error message,
          #    """
          #       hash mismatch in fixed-output derivation [...]
          #       specified: [...]")
          #       got: [...]
          #    """
          # 4. replace the hash by the new one          
          vendorSha256 = "sha256-puCqql77kvdWTcwp8z6LExBt/HbNRNe0f+wtM0kLoWM=";

          src = ./.;

          excludedPackages = ".nap";


          meta = {
            description = "Code snippets in your terminal 🛌";
            homepage = "https://github.com/maaslalani/nap";
            license = lib.licenses.mit;
            maintainers = [ "maaslalani" ];
            platforms = lib.platforms.linux ++ lib.platforms.darwin;
          };

        };
      };

      defaultPackage = packages.nap;
      defaultApp = packages.nap;

      devShell = pkgs.mkShell {
        name = "nap-go-shell";

        buildInputs = with pkgs; [ 
          go
        ];

      };
    }
  );
}
