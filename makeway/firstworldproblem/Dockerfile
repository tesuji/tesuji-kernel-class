FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

ARG KVER
ENV KVER=${KVER:-6.8.0-83-generic}

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        kmod \
        linux-headers-$KVER \
        linux-modules-$KVER \
        git \
        make \
        ssh \
        $NULL

WORKDIR /src
COPY . /src
RUN <<EOF
mkdir -p /challenge
make
cp /src/echo.ko /src/echo.c /challenge/

DEBIAN_FRONTEND=noninteractive apt-get download linux-image-$KVER
dpkg -x linux-image-$KVER_*.deb .
cp boot/vmlinuz-* /challenge/bzImage
EOF

#ADD --chown=0:0 --chmod=6755 \
#    http://github.com/pwncollege/exec-suid/releases/latest/download/exec-suid \
#    /usr/bin/exec-suid
#RUN <<EOF
#mkdir -p /opt/pwncollege/
#ln -f /usr/bin/exec-suid /opt/pwncollege/bash
#ln -f /usr/bin/exec-suid /opt/pwncollege/python
#EOF

# Create initramfs tree
#WORKDIR /src/fs
RUN <<EOF
apt-get install -y \
    busybox-static \
    cpio \
    gzip \
    zstd \
    $NULL
EOF

RUN <<EOF
mkdir -p initramfs/{bin,sbin,etc,proc,sys,dev,newroot,lib/modules/${KVER}}
cp /bin/busybox initramfs/bin/

pushd initramfs/bin
for app in sh mount mkdir mknod switch_root;
    do ln -s busybox $app;
done

cp /sbin/modprobe .
# dep of modprobe
mkdir -p ../lib/x86_64-linux-gnu/ && cd $_
cp /lib/x86_64-linux-gnu/libzstd.so.1 .
cp /lib/x86_64-linux-gnu/liblzma.so.5 .
cp /lib/x86_64-linux-gnu/libcrypto.so.3 .
cp /lib/x86_64-linux-gnu/libc.so.6 .
popd
mkdir -p initramfs/lib64/
cp /lib64/ld-linux-x86-64.so.2 initramfs/lib64/

# Copy 9p modules + deps from host into initramfs
mkdir -p initramfs/lib/modules/$KVER/kernel/{net,fs/netfs}/
cp -a /lib/modules/$KVER/kernel/net/9p initramfs/lib/modules/$KVER/kernel/net/
cp -a /lib/modules/$KVER/kernel/fs/9p initramfs/lib/modules/$KVER/kernel/fs/
cp -a /lib/modules/6.8.0-83-generic/kernel/fs/netfs/netfs.ko.zst \
    initramfs/lib/modules/$KVER/kernel/fs/netfs/

cp -a /lib/modules/$KVER/modules.* initramfs/lib/modules/$KVER/

#find initramfs/lib/modules -name "*.zst" -exec zstd -d {} +

cp /src/initramfs.sh initramfs/init
chmod +x initramfs/init

# Pack initramfs
cd initramfs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > /challenge/initramfs.cpio.gz
EOF

