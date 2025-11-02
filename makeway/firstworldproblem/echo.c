// SPDX-License-Identifier: GPL-2.0
// See also:
// <https://github.com/pwncollege/pwnkernel/blob/main/src/hello_ioctl.c>.

#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

#define DEV_NAME "echo"
#define CLS_NAME "ctf"
#define BUF_SZ 511

static int gchrdev;
static struct class *gclass;
static struct device *gdev;
static char gfmt[BUF_SZ + 1];

static ssize_t echo_write(struct file *file, const char __user *ubuf,
                          size_t usz, loff_t *ppos) {
  size_t sz = (usz < BUF_SZ) ? usz : BUF_SZ;
  memset(gfmt, 0, sizeof(gfmt));

  if (sz && copy_from_user(gfmt, ubuf, sz)) return -EFAULT;

  return (ssize_t)sz;
}

static ssize_t echo_read(struct file *file, char __user *ubuf, size_t usz,
                         loff_t *ppos) {
  char buf[BUF_SZ + 1];
  size_t len, out;

  snprintf(buf, sizeof(buf), gfmt);

  len = strnlen(buf, sizeof(buf));
  if (len > sizeof(buf)) return -EINVAL;

  out = (len <= usz) ? len : usz;

  if (out && copy_to_user(ubuf, buf, out)) return -EFAULT;

  return (ssize_t)out;
}

static const struct file_operations echo_fops = {
    .owner = THIS_MODULE,
    .read = echo_read,
    .write = echo_write,
    .llseek = no_llseek,
};

static int __init echo_init(void) {
  int ret;

  /* register major via the old API to mirror __register_chrdev path */
  gchrdev = register_chrdev(0, DEV_NAME, &echo_fops);
  if (gchrdev < 0) {
    pr_err("Registering char device failed with %d\n", gchrdev);
    return gchrdev;
  }

  gclass = class_create(CLS_NAME);
  if (IS_ERR(gclass)) {
    pr_err("Failed to register device class\n");
    ret = PTR_ERR(gclass);
    goto class_fail;
  }

  gdev = device_create(gclass, NULL, MKDEV(gchrdev, 0), NULL, DEV_NAME);
  if (IS_ERR(gdev)) {
    pr_err("Failed to create the device\n");
    ret = PTR_ERR(gdev);
    goto dev_fail;
  }

  pr_info("Created /dev/%s\n", DEV_NAME);
  return 0;

dev_fail:
  class_destroy(gclass);
class_fail:
  unregister_chrdev(gchrdev, DEV_NAME);
  return ret;
}

static void __exit echo_exit(void) {
  device_destroy(gclass, MKDEV(gchrdev, 0));
  class_unregister(gclass);
  class_destroy(gclass);
  unregister_chrdev(gchrdev, DEV_NAME);
  pr_info("Removed /dev/%s\n", DEV_NAME);
}

module_init(echo_init);
module_exit(echo_exit);

MODULE_AUTHOR("Daan Keuper");
MODULE_DESCRIPTION(
    "Format-string echo device (intentionally vulnerable) for CTF-style use");
MODULE_LICENSE("GPL");
