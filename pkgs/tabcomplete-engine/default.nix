{ pkgs }:

let
  source = pkgs.fetchFromGitHub {
    owner = "Shlok-Bhakta";
    repo = "tabcomplete";
    rev = "f4f4105af971847a5c2266f11554d170201b12d1";
    hash = "sha256-8uZxq0ZaOF5/D+HGXBg/mNv5h85mxO+2o2nuEW5Fwr4=";
    # Runtime source excludes receipts containing machine-specific store paths.
    postFetch = ''
      rm -rf "$out/reports"
    '';
  };
  # Sweep next-edit 0.5B engine, pinned public weights and the Neovim client.
  package = import "${source}/nix/nes/default.nix" { inherit pkgs; };
in
package // { inherit source; }
