#!/usr/bin/env -iS /opt/pwn.college/bash
set -e

tmpdir=$(mktemp -d)

exp="$1"
if [ ! -f "$exp" ]; then
    exp=/bin/true
fi

if [ -f "$exp" ] && [ -r "$exp" ]; then
  cp "$exp" "$tmpdir"/exp
  if file "$tmpdir"/exp | grep -qv ELF; then
    echo "accept elf only" >&2
    exit 1
  fi
fi

pushd "$tmpdir" >/dev/null
mkdir rootfs && cd rootfs
zcat /challenge/initramfs.cpio.gz | cpio -imd
cp /flag flag
ln -f "$tmpdir/exp" ./exp
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
    -initrd "$tmpdir/initramfs.cpio.gz"

