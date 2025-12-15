{ ... }:
{
  nix-bitcoin.generateSecrets = true;

  services.bitcoind = {
    enable = true;
    user = "ismael";
    rpc.users = {
      "ismael".passwordHMAC =
        "4b465b02f3c49cbee276147d04cc2b55$477c08411e701a6716e3228ead8cf30a0bce4e22f399178bdfd5944e3d28574c";
      "jaoleal".passwordHMAC =
        "0eaf33846774662c475489c9fd9657b4$f2867d2ad5374327c25d0d9efc2c9972fcd7070bd85f5ad6b0e0955259a17275";
    };
    dataDir = "/data/main/bitcoin";
  };

  nix-bitcoin.operator = {
    enable = true;

    allowRunAsUsers = [
      "ismael"
    ];
  };
}
