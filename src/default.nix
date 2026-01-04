{ ... }:
{
  buildNixos = (import ./builder.nix {}).buildNixos;
  buildNixosISO = (import ./iso-builder.nix {}).buildNixosISO;
  imports = [
    ./graphical_minimal.nix
    ./graphical_standard.nix
  ];

}
