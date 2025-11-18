# The Nixpkgs path to use
let
  nivPath = ../nix/sources.nix;
  npinsPath = ../npins/default.nix;
  pinPath = if builtins.pathExists nivPath then
              nivPath
            else if builtins.pathExists npinsPath then
              npinsPath
            else
              abort "Did you forget `niv init` or `npins init`";
in
  (import pinPath).nixpkgs.outPath
