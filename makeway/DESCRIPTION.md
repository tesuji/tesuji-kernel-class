You should complete Kernel Security module and Kernel Exploitation module
before these challenges.

## Notes

These challenges use `/challenges/run.sh` as a starting point.
They do not use `vm` script at all.

You might run `/challenges/run.sh <bin path>` to copy the exploit binary
to the vm. In most cases, the exploit binary should be **statically** compiled
since there is no glibc runtime inside the init rootfs.

There are hints encoded in base64. However you should avoid hints
and find the bug yourself.

In practice mode, to aid debugging, edit `run.sh` to:
* Remove kaslr.
* Enable kvm with `--enable-kvm` flag for better performance.
* Add `-s` flag for gdb port 1234.

