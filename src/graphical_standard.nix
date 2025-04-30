{
  pkgs,
  ...
}:
let
  theme = "${pkgs.base16-schemes}/share/themes/decaf.yaml";
in
{


  stylix = {
    enable = true;
    base16Scheme = theme;
    image = pkgs.runCommand "image.png" { } ''
      COLOR=$(${pkgs.yq}/bin/yq -r .palette.base00 ${theme})
      ${pkgs.imagemagick}/bin/magick -size 1920x1080 xc:$COLOR $out
    '';
  };

}
