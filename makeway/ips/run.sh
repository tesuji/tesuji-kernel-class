#!/opt/pwn.college/bash
set -e

tmpdir=$(mktemp -d)

exp="$1"
if [ ! -f "$exp" ]; then
    exp=/bin/true
fi

if [ -f "$exp" ] && [ -r "$exp" ]; then
  cp "$exp" $tmpdir/exp
  if file $tmpdir/exp | grep -qv ELF; then
    echo "accept elf only" >&2
    exit 1
  fi
  genisoimage  \
    -o $tmpdir/pwn.iso \
    -file-mode 0400 \
    "$tmpdir/exp" \
    /flag \
    $NULL
fi

# XXX: Unfortunately the do_sys_ipc does access user pagetable so cannot enable SMAP.
# However we could enable kvm with that.
qemu-system-x86_64 \
  -m 256M \
  -enable-kvm \
  -initrd /challenge/initramfs.cpio.gz \
  -kernel /challenge/bzImage \
  -nographic \
  -monitor /dev/null \
  -append "kpti=1 kaslr root=/dev/ram rw console=ttyS0 oops=panic panic=1 quiet" \
  -cpu qemu64,smep \
  -cdrom $tmpdir/pwn.iso \
  $NULL

