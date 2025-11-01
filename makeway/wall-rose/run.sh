#!/opt/pwn.college/bash
set -e

tmpdir=$(mktemp -d)

if [ ! -f "$exp" ]; then
    exp=/bin/true
fi

if [ -f "$exp" ] && [ -r "$exp" ]; then
  cp "$exp" $tmpdir/exp
  genisoimage  \
    -o $tmpdir/pwn.iso \
    -file-mode 0400 \
    "$tmpdir/exp" \
    /flag \
    $NULL
fi

qemu-system-x86_64 \
    -L /challenge/bios \
    -kernel /challenge/bzImage \
    -initrd /challenge/initramfs.cpio.gz \
    -cpu kvm64,+smep,+smap \
    -monitor none \
    -m 1024M \
    -append "console=ttyS0 oops=panic panic=1 quiet" \
    -monitor /dev/null \
    -nographic \
    -no-reboot \
    -net user -net nic -device e1000 \
    -cdrom $tmpdir/pwn.iso \
    $NULL

