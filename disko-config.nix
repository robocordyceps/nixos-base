# Disko partitioning: 2TB SSD as main/OS disk, 4TB SSD as persistent storage.
# Replace both `device` paths with real identifiers, e.g. from `ls -l /dev/disk/by-id/`.
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/REPLACE_WITH_2TB_DISK_ID";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };

      storage = {
        device = "/dev/disk/by-id/REPLACE_WITH_4TB_DISK_ID";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            persist = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/mnt/storage";
                mountOptions = [ "defaults" ];
              };
            };
          };
        };
      };
    };
  };
}
