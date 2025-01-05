{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.haskellPackages.implicit
    pkgs.openscad
  ];
}

