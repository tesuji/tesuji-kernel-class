After repeated attacks on poor kernel objects, I've decided to place pwners in a special isolated place - a marooned region of memory. Good luck escaping out of here :^)

## Notes

* You can use `/challenge/run.sh <exploit>` to run the challenge. However because
  the kernel is compiled without block device support, we will have to re-compress
  the initramfs every run. This may lead to unstable physical layout of the image.
* The original event does not provide `mod.c` during the contest.
  But to focus on the bug, here I gift it to you.
