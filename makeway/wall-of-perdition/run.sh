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
    -m 128M \
    -nographic \
    -no-reboot \
    -kernel "/challenge/bzImage" \
    -append "console=ttyS0 qiet loglevel=3 oops=panic panic=-1 pti=on" \
    -monitor /dev/null \
    -initrd "$tmpdir/initramfs.cpio.gz" \
    -cpu qemu64,+smep,+smap \
    -smp cores=1
