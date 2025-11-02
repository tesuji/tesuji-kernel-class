FROM ubuntu:24.04 AS base

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        kmod \
        linux-headers-6.8.0-83-generic \
        git \
        make \
        $NULL

WORKDIR /src
COPY . /src
RUN <<EOF
mkdir -p /challenge
make
cp /src/echo.ko /src/echo.c /challenge/
EOF

WORKDIR /tmp
RUN <<EOF
mkdir -p /challenge
DEBIAN_FRONTEND=noninteractive apt-get download linux-image-6.8.0-83-generic
dpkg -x linux-image-6.8.0-83-generic_6.8.0-83.83_amd64.deb .
cp boot/vmlinuz-* /challenge/bzImage
EOF

ADD --chown=0:0 --chmod=6755 \
    http://github.com/pwncollege/exec-suid/releases/latest/download/exec-suid \
    /usr/bin/exec-suid
RUN <<EOF
mkdir -p /opt/pwncollege/
ln -f /usr/bin/exec-suid /opt/pwncollege/bash
ln -f /usr/bin/exec-suid /opt/pwncollege/python
EOF

# Build miniam initramfs
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
#        busybox-static \
#        cpio \
#        gzip \
#        $NULL
#
#RUN <<EOF
#mkdir -p /build
#cp /challenge/echo.ko /build/modules/
#mkdir -p initramfs/{bin,sbin,etc,proc,sys,dev,modules} 
#cp /bin/busybox initramfs/bin/
#cd initramfs/bin 
#for app in sh mount mkdir mknod dmesg insmod; do ln -s busybox $app; done 
#cd /build
#
## Add init script
#printf '#!/bin/sh\n\
#mount -t proc none /proc\n\
#mount -t sysfs none /sys\n\
#mount -t devtmpfs none /dev\n\
#echo "Booted into minimal initramfs"\n\
#insmod /modules/echo_fmt_vuln.ko || echo "Module load failed"\n\
#exec sh\n' > initramfs/init && \
#    chmod +x initramfs/init
#
## Pack initramfs
#cd initramfs && \
#    find . -print0 | cpio --null -ov --format=newc | gzip -9 > /build/initramfs.cpio.gz
#
#EOF
#
