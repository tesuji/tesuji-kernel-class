#!/opt/pwn.college/bash
set -e

tmpdir=$(mktemp -d)

pushd $tmpdir >/dev/null
mkdir rootfs && cd rootfs
zcat /challenge/initramfs.cpio.gz | cpio -imd
cp /flag flag
find . | cpio -o -H newc | gzip > ../initramfs.cpio.gz
popd >/dev/null

exec qemu-system-x86_64 \
    -m 4096M \
    -nographic \
    -kernel /challenge/bzImage \
    -append "console=ttyS0 loglevel=3 oops=panic panic=-1 pti=on" \
    -netdev user,id=net \
    -device e1000,netdev=net \
    -no-reboot \
    -monitor /dev/null \
    -cpu qemu64,+smep,+smap \
    -initrd /challenge/initramfs.cpio.gz \
    -initrd "$tmpdir/initramfs.cpio.gz" \
    $NULL

