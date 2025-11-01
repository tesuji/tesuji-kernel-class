After repeated attacks on poor kernel objects, I've decided to place pwners in a special isolated place - a marooned region of memory. Good luck escaping out of here :^)

## Notes

* The kernel is compiled without block device support. You will have to
  send the exploit binary manually via console stdin.
* The original event does not provide `mod.c` during the contest.
  But to focus on bug, here I gift it to you.
