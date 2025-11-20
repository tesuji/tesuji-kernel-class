## Instruction

- You have a busybox shell running as user `user`
- Try exploiting `rose.ko` to achieve privilege escalation
- You may assumed that busybox, the Linux kernel, and Qemu are **not vulnerable**.

## Files

- `/challenge/rose.ko`: The vulnerable driver
- `/challenge/src/rose.c`: The source code of `rose.c`

## Notes

- FG-KASLR is enabled
- **Your exploit should be kernel-agnostic. In other words, it should not rely on any kernel offsets**
