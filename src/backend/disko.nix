{ lib, ... }:

{
  disko.devices = {
    disk = {
      # 3.6T HDD - backup
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            backup = {
              size = "100%";
              type = "primary";
              # you can also set a label, e.g. "BACKUP"
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data/backup";
                mountOptions = [
                  "defaults"
                  "noatime"
                ];
              };
            };
          };
        };
      };

      # 1.8T SATA SSD - main data
      sdb = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            # Small EFI or generic FAT partition (optional/useful if this disk ever needs to be bootable)
            ESP = {
              size = "1G";
              type = "EF00"; # EFI system partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/mnt/extra-efi"; # or null if you really don't want it mounted
                mountOptions = [ "defaults" ];
              };
            };

            main = {
              size = "100%";
              type = "primary";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data/main";
                mountOptions = [
                  "defaults"
                  "noatime"
                ];
              };
            };
          };
        };
      };

      # 238G NVMe - fast data
      nvme1n1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            # Small EFI or spare FAT
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/mnt/nvme-efi"; # or null if unused
                mountOptions = [ "defaults" ];
              };
            };

            fast = {
              size = "100%";
              type = "primary";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data/fast";
                mountOptions = [
                  "defaults"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };

  # Optional: ensure mountpoints exist in the filesystem hierarchy
  fileSystems."/data/backup".neededForBoot = false;
  fileSystems."/data/main".neededForBoot = false;
  fileSystems."/data/fast".neededForBoot = false;

  # If you keep those auxiliary EFI mounts; otherwise remove these
  fileSystems."/mnt/extra-efi".neededForBoot = false;
  fileSystems."/mnt/nvme-efi".neededForBoot = false;
}
