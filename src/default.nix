{ ... }:
{
  buildNixos = (import ./builder.nix {}).buildNixos;
  imports = [
    ./graphical_minimal.nix
    ./graphical_standard.nix
  ];

}
