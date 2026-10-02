# Disk layout:
#   main (2TB): ESP + ext4 root (OS)
#   data (4TB): single ext4 partition for persistent storage at /data
#
# Replace the by-id paths with your real ones (`ls -l /dev/disk/by-id`).
{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/disk/by-id/REPLACE-WITH-2TB-SSD-ID";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
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

    data = {
      type = "disk";
      device = "/dev/disk/by-id/REPLACE-WITH-4TB-SSD-ID";
      content = {
        type = "gpt";
        partitions.data = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/data";
          };
        };
      };
    };
  };
}
