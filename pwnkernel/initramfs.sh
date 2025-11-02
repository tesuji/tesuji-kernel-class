#!/bin/sh
set -e

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev
echo "Loading 9p modules..."
# use /bin prefix to take over busybox's modprobe
/bin/modprobe 9pnet
/bin/modprobe 9pnet_virtio
/bin/modprobe 9p
echo "Mounting host root via 9p..."
mount -t 9p -o trans=virtio /dev/root /newroot
echo "Switching root..."
exec switch_root /newroot /challenge/vm_init

