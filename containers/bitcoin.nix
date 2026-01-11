{ ... }:
{
  nix-bitcoin.generateSecrets = true;

  services.bitcoind = {
    enable = true;
    rpc.users = {
      "ismael".passwordHMAC =
        "4b465b02f3c49cbee276147d04cc2b55$477c08411e701a6716e3228ead8cf30a0bce4e22f399178bdfd5944e3d28574c";
      "jaoleal".passwordHMAC =
        "618818b867914dde03bf2069aec6e28d$8fd18930e914ded4ee262fa6705e1d57554680478d620eebd152f20bed000574";
    };
    dataDir = "/data/main/bitcoin";
  };
}
