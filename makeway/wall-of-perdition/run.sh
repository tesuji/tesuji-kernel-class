#!/opt/pwn.college/bash
set -e

tmpdir=$(mktemp -d)

pushd $tmpdir >/dev/null
mkdir rootfs && cd rootfs
zcat /challenge/initramfs.cpio.gz | cpio -imd
cp /flag flag
find . | cpio -o -H newc | gzip > ../initramfs.cpio.gz
popd

exec qemu-system-x86_64 \
    -enable-kvm \
    -m 128M \
    -nographic \
    -no-reboot \
    -kernel "/challenge/bzImage" \
    -append "console=ttyS0 qiet loglevel=3 oops=panic panic=-1 pti=on" \
    -monitor /dev/null \
    -initrd "$tmpdir/initramfs.cpio.gz" \
    -cpu qemu64,+smep,+smap \
    -smp cores=1 \
    $NULL
