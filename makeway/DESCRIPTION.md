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

In practice mode, to aid debugging, edit `run.sh` to modify `qemu` arguments:

* Add `nokaslr` after the `-append` flag.
* Enable kvm with `-enable-kvm` flag for better performance.
* Add `-s` flag for gdb port 1234.

## Further readings

* [A Systematic Study of Elastic Objects in Kernel Exploitation][1].
* [RetSpill: Igniting User-Controlled Data to Burn Away Linux Kernel Protections][2].
* [SLUBStick: Arbitrary Memory Writes through Practical
Software Cross-Cache Attacks within the Linux Kernel][3]: Especially page 17.

[1]: https://zplin.me/papers/ELOISE.pdf
[2]: https://adamdoupe.com/publications/retspill-ccs2023.pdf
[3]: https://www.stefangast.eu/papers/slubstick.pdf

<!--
Some useful objects:
* snd_info_private_data: need /proc/asound or /dev/snd
* <https://starlabs.sg/blog/2023/07-prctl-anon_vma_name-an-amusing-heap-spray/>:
  Caveat not available on older kernels
* userfaultfd: Since kernel 5.11 onward not enable anymore or need privilege perm.
-->
