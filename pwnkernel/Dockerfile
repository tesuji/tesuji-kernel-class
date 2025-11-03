FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

ARG KVER
ENV KVER=${KVER:-6.8.0-83-generic}

SHELL ["/bin/bash", "-c"]

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

# Use COPY after agt-get to allow caching apt
WORKDIR /src
COPY initramfs.sh vm vm_init /src/
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
cp /boot/config-$KVER /challenge/kconfig
EOF

# Create initramfs tree
RUN <<EOF
set -e
mkdir -p fs/{bin,sbin,etc,proc,sys,dev,newroot,lib/modules/${KVER}}
cp /bin/busybox fs/bin/

pushd fs/bin
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
mkdir -p fs/lib64/
cp /lib64/ld-linux-x86-64.so.2 fs/lib64/

# Copy 9p modules + deps from host into initramfs
mkdir -p fs/lib/modules/$KVER/kernel/{net,fs}/
cp -a /lib/modules/$KVER/kernel/net/9p      fs/lib/modules/$KVER/kernel/net/
cp -a /lib/modules/$KVER/kernel/fs/9p       fs/lib/modules/$KVER/kernel/fs/
cp -a /lib/modules/$KVER/kernel/fs/netfs    fs/lib/modules/$KVER/kernel/fs/

cp -a /lib/modules/$KVER/modules.* fs/lib/modules/$KVER/

cp /src/initramfs.sh fs/init
chmod +x fs/init

# Pack initramfs
pushd fs/
find . -print0 | cpio --null -o --format=newc | gzip -9 > /challenge/initramfs.cpio.gz
popd

# Clean alls
rm -rf /src
EOF

