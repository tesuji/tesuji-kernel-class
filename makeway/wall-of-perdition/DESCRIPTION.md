Elastic objects seem to have even more power in many more slabs!

Can you use Retspill and bypass FG-KASLR to solve this ?

## Notes

* You can use `/challenge/run.sh <exploit>` to run the challenge. However because
  the kernel is compiled without block device support, we will have to re-compress
  the initramfs every run. This may lead to unstable physical layout of the image.
* The original event does not provide `firewall.c` during the contest.
  But to focus on bug, here I gift it to you.

Hint 1:
```
VGhlcmUgaXMgYSBVQUYgYnVnIG9uIHRoZSBkdXBsaWNhdGUgZnVuY3Rpb24K
```

Hint 2: How to bypass FG-KASLR ?
```
T3B0YWluIGEgcG9pbnRlciB0byBrZXJuZWwgLmRhdGEgc2VjdGlvbiBpcyBhbGwgeW91IG5lZWQu
Cg==
```

