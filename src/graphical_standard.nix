{
  pkgs,
  ...
}:
let
  theme = "${pkgs.base16-schemes}/share/themes/decaf.yaml";
in
{

  environment.systemPackages = with pkgs; [
    #waybar
    #swww
    #nwg-bar
    #fuzzel
    #swaylock
    #swaylock-effects
    #xdg-desktop-portal-gtk
    ##swaybg
    #xwayland-satellite
    #swayidle
    #xdg-desktop-portal-gtk
  ];
  # programs.niri.enable = true;

  #stylix = {
   # enable = true;
    #base16Scheme = theme;
    #};

}
