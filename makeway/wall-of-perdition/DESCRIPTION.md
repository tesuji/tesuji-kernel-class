<!--
TIP: use yy and :r !echo '<ctrl-r>0' | base64
-->
Elastic objects seem to have even more power in many more slabs!

Can you use RetSpill and bypass FGKASLR to solve this ?

## Notes

* You can use `/challenge/run.sh <exploit>` to run the challenge. However because
  the kernel is compiled without block device support, we will have to re-compress
  the initramfs every run. This may lead to unstable physical layout of the image.
* The original event does not provide `firewall.c` during the contest.
  But to focus on bug, here I gift it to you.

## Hints

Hint 1: The module is safe ?
<!--
There is a UAF bug on the duplicate function.
-->
```
VGhlcmUgaXMgYSBVQUYgYnVnIG9uIHRoZSBkdXBsaWNhdGUgZnVuY3Rpb24K
```

Hint 2: **How to bypass FGKASLR ?**

FGKASLR is short for Function Granular Kernel Address Space Layout Randomization.
<!--
Pointers to .`rodata` or `.data` section are not shuffled (as they are not functions).
So you could get kernel base from those pointers.

But how do you call an arbitrary function when its address was shuffled at boot ?

Here is where `struct kernel_symbol` defined:
<https://elixir.bootlin.com/linux/v5.14.16/source/include/linux/export.h#L60>.

How it is used:
<https://elixir.bootlin.com/linux/v5.14.16/source/kernel/module.c#L462>

Suppose you got the arbitrary read primitive (with no limitations), you could leak
any function by reading their `__ksymtab_*` symbols.

For example, to find `commit_creds` address:
```gdb
gef> x/3x __ksymtab_commit_creds
0xffffffffa954fc04 <__ksymtab_commit_creds>:    0xffb7dacc      0x00017546      0x00022165
gef> p __ksymtab_commit_creds+0xffb7dacc
$3 = 0xa90cd6d0
gef> p commit_creds
$4 = 0xffffffffa90cd6d0 <commit_creds>
```
-->
```
UG9pbnRlcnMgdG8gLmByb2RhdGFgIG9yIGAuZGF0YWAgc2VjdGlvbiBhcmUgbm90IHNodWZmbGVk
IChhcyB0aGV5IGFyZSBub3QgZnVuY3Rpb25zKS4NU28geW91IGNvdWxkIGdldCBrZXJuZWwgYmFz
ZSBmcm9tIHRob3NlIHBvaW50ZXJzLg0NQnV0IGhvdyBkbyB5b3UgY2FsbCBhbiBhcmJpdHJhcnkg
ZnVuY3Rpb24gd2hlbiBpdHMgYWRkcmVzcyB3YXMgc2h1ZmZsZWQgYXQgYm9vdCA/DQ1IZXJlIGlz
IHdoZXJlIGBzdHJ1Y3Qga2VybmVsX3N5bWJvbGAgZGVmaW5lZDoNPGh0dHBzOi8vZWxpeGlyLmJv
b3RsaW4uY29tL2xpbnV4L3Y1LjE0LjE2L3NvdXJjZS9pbmNsdWRlL2xpbnV4L2V4cG9ydC5obWFr
ZXdheS9ERVNDUklQVElPTi5tZEw2MD4uDQ1Ib3cgaXQgaXMgdXNlZDoNPGh0dHBzOi8vZWxpeGly
LmJvb3RsaW4uY29tL2xpbnV4L3Y1LjE0LjE2L3NvdXJjZS9rZXJuZWwvbW9kdWxlLmNtYWtld2F5
L0RFU0NSSVBUSU9OLm1kTDQ2Mj4NDVN1cHBvc2UgeW91IGdvdCB0aGUgYXJiaXRyYXJ5IHJlYWQg
cHJpbWl0aXZlICh3aXRoIG5vIGxpbWl0YXRpb25zKSwgeW91IGNvdWxkIGxlYWsNYW55IGZ1bmN0
aW9uIGJ5IHJlYWRpbmcgdGhlaXIgYF9fa3N5bXRhYl8qYCBzeW1ib2xzLg0NRm9yIGV4YW1wbGUs
IHRvIGZpbmQgYGNvbW1pdF9jcmVkc2AgYWRkcmVzczoNYGBgZ2RiDWdlZj4geC8zeCBfX2tzeW10
YWJfY29tbWl0X2NyZWRzDTB4ZmZmZmZmZmZhOTU0ZmMwNCA8X19rc3ltdGFiX2NvbW1pdF9jcmVk
cz46ICAgIDB4ZmZiN2RhY2MgICAgICAweDAwMDE3NTQ2ICAgICAgMHgwMDAyMjE2NQ1nZWY+IHAg
X19rc3ltdGFiX2NvbW1pdF9jcmVkcysweGZmYjdkYWNjDSQzID0gMHhhOTBjZDZkMA1nZWY+IHAg
Y29tbWl0X2NyZWRzDSQ0ID0gMHhmZmZmZmZmZmE5MGNkNmQwIDxjb21taXRfY3JlZHM+DWBgYAo=
```

Hint 3: RetSpill is impossible for this kernel ?
<!--
Stack shifting gadget (not pivoting) are `add rsp, 0x..` and .. ? But the latter gadget
kind is not as good as the former one. It does not skip the clean up part.
-->
```
U3RhY2sgc2hpZnRpbmcgZ2FkZ2V0IChub3QgcGl2b3RpbmcpIGFyZSBgYWRkIHJzcCwgMHguLmAg
YW5kIC4uID8gQnV0IHRoZQ1sYXR0ZXIgZ2FkZ2V0IGtpbmQgaXMgbm90IGFzIGdvb2QgYXMgdGhl
IGZvcm1lciBvbmUuIEl0IGRvZXMgbm90IHNraXAgdGhlIGNsZWFuIHVwIHBhcnQuCg==
```
