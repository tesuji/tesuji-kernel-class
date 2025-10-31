#!/opt/pwn.college/bash
set -e

tmpdir=$(mktemp -d)
if [ ! -f ./exp ]; then
  touch ./exp
fi

if [ -f ./exp ] && [ -r ./exp ]; then
  genisoimage  \
    -o $tmpdir/pwn.iso \
    -file-mode 0400 \
    ./exp \
    /flag \
    $NULL
fi

qemu-system-x86_64 \
  -m 256M \
  -initrd /challenge/initramfs.cpio.gz \
  -kernel /challenge/bzImage \
  -nographic \
  -monitor /dev/null \
  -append "kpti=1 +smep +smap kaslr root=/dev/ram rw console=ttyS0 oops=panic panic=1 quiet" \
  -cdrom $tmpdir/pwn.iso \
  $NULL

