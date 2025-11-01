Elastic objects seem to have even more power in many more slabs!

Could you use UAF-Free-Leak, Retspill, and FG-KASLR bypassing to solve this ?

## Notes

* The kernel is compiled without block device support. You will have to
  send the exploit binary manually via console stdin.
* The original event does not provide `firewall.c` during the contest.
  But to focus on bug, here I gift it to you.

Hint:
```
aGludDogRGl2ZSBpbnRvIHRoZSBzb3VyY2UgY29kZSBmb3IgdGhhdCBvYmplY3QncyBrZXJuZWwg
ZnVuY3Rpb25zIGFuZCB5b3UnbGwgc2VlIG1hbnkgdGhpbmdzISBZb3UgY2FuIHN0aWxsIGFjaGll
dmUgdGhlIHNhbWUgcG93ZXJmdWwgcHJpbWl0aXZlcywgYnV0IGJvdGggcHJpbWl0aXZlcyBub3cg
aGFzIG5vdCBiZWVuIGRvY3VtZW50ZWQgb3Igd3JpdHRlbiBleHRlbnNpdmVseSBhYm91dCB0byB0
aGUgZXh0ZW50IG9mIG91ciBrbm93bGVkZ2UuCg==
```

