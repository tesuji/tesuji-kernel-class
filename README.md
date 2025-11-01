# Special thanks to

`@n132` for this list: <https://n132.github.io/archive>.

# License

The following directories are under AGPLv3 license:
* makeway/wall-of-perdition
* makeway/cache-of-castaways

These directories are under GPLv2 license:
* makeway/wall-rose

All others are under BSD license.

## Challenge Writing Laws

### For kernel pwn challenges with initramfs

```bash
mkdir rootfs && cd rootfs
zcat ../initramfs.cpio.gz | cpio -idmv
find . | cpio -o -H newc | gzip > ../initramfs.cpio.gz
```

Patch /init script:
```bash
mkdir -p /mnt
mount -t iso9660 /dev/sr0 /mnt
cp /mnt/exp /exp
chmod 0777 /exp
cp /mnt/flag /flag
chmod 0400 /flag
```

Add flag to qemu:
```bash
tmpdir=$(mktemp -d)
exp="$1"

if [ -f "$exp" ] && [ -r "$exp" ]; then
  cp "$exp" $tmpdir/exp
  genisoimage  \
    -o $tmpdir/pwn.iso \
    -file-mode 0400 \
    "$tmpdir/exp" \
    /flag \
    $NULL
fi

qemu ... \
    -cdrom $tmpdir/pwn.iso \
    $NULL
```

### If the kernel is compiled without block device support

Re-compress the initramfs.

**Example**: See <makeway/wall-of-perdition/run.sh>.

**Drawbacks**:
* Physical offsets will change between dojo users.

**Failed experiments**:
* Use `mkfifo` and `qemu -serial pipe:/tmp/qemu-secret`, then read secret
  from `/dev/ttyS1`.
