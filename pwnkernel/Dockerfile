FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

ARG KVER
ENV KVER=${KVER:-6.8.0-83-generic}

SHELL ["/bin/bash", "-c"]

WORKDIR /src
COPY . /src/
RUN <<EOF
apt-get update
apt-get install -y \
    build-essential \
    kmod \
    linux-headers-$KVER \
    linux-modules-$KVER \
    git \
    make \
    ssh \
    busybox-static \
    cpio \
    gzip \
    zstd \
    $NULL
apt-get clean
EOF

RUN <<EOF
set -e
echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
#passwd -d hacker
userdel -r ubuntu
EOF

RUN <<EOF
set -e
mkdir -p /challenge/bin/

cp vm /challenge/bin/
cp vm_init /challenge/

DEBIAN_FRONTEND=noninteractive apt-get download linux-image-$KVER
dpkg -x linux-image-$KVER_*.deb .
cp boot/vmlinuz-* /challenge/bzImage
EOF

# Create initramfs tree
RUN <<EOF
set -e
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
mkdir -p initramfs/lib/modules/$KVER/kernel/{net,fs}/
cp -a /lib/modules/$KVER/kernel/net/9p initramfs/lib/modules/$KVER/kernel/net/
cp -a /lib/modules/$KVER/kernel/fs/9p initramfs/lib/modules/$KVER/kernel/fs/
cp -a /lib/modules/$KVER/kernel/fs/netfs initramfs/lib/modules/$KVER/kernel/fs/

cp -a /lib/modules/$KVER/modules.* initramfs/lib/modules/$KVER/

cp /src/initramfs.sh initramfs/init
chmod +x initramfs/init

# Pack initramfs
cd initramfs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > /challenge/initramfs.cpio.gz
EOF

WORKDIR /
RUN rm -rf /src

