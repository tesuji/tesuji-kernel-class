You should complete Kernel Security module and Kernel Exploitation module
before these challenges.

## Notes

These challenges use `/challenges/run.sh` as a starting point.
They do not `vm` script like you might be used to.

Your exploit binary will be loaded from a file name `exp` in the cwd.
In most cases, the exploit binary should be **statically** compiled since
there is no glibc runtime inside the init rootfs.

In practice mode, to aid debugging, edit `run.sh` to:
* Remove kaslr.
* Enable kvm with `--enable-kvm` flag for better performance.
* Add `-s` flag for gdb port 1234.

