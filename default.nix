{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc821" }:

with nixpkgs;
with pkgs.haskell.lib;

let
  ghc = pkgs.haskell.packages.${compiler};
in
  ghc.callCabal2nix "my-web" ./. {
    wai-make-assets=dontCheck ghc.wai-make-assets;
  }
