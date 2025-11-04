# Ref: <https://github.com/pwncollege/challenge-images/blob/main/vm-linux-6.10/Dockerfile>
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
# XXX: Could replace ssh with dropbear: <https://wiki.gentoo.org/wiki/Dropbear>.

#passwd -d hacker
RUN userdel -r ubuntu
COPY <<'EOF' /etc/ssh/sshd_config.d/vm.conf
PasswordAuthentication yes
PermitEmptyPasswords yes
EOF

COPY <<'EOF' /etc/ssh/ssh_config.d/vm.conf
Host vm
    HostName localhost
    Port 22
    User hacker
    ControlMaster auto
    ControlPath /tmp/ssh_mux_%h_%p_%r
    ControlPersist 10m
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
EOF

# Use COPY after agt-get to allow caching apt
COPY vm /challenge/bin/
COPY vm_init /challenge/
COPY initramfs.sh /src/fs/init
COPY kropr /usr/local/bin/
RUN mkdir -p /run/sshd/

WORKDIR /src
RUN <<EOF
set -e

apt-get download linux-image-$KVER
dpkg -x linux-image-$KVER_*.deb .
cp boot/vmlinuz-* /challenge/bzImage
ln -f /boot/config-$KVER /challenge/kconfig
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
popd

# This supports zstd-compressed modules.
cp /sbin/modprobe fs/bin/
# dep of modprobe
mkdir -p fs/lib64/
cp /lib64/ld-linux-x86-64.so.2 fs/lib64/
mkdir -p fs/lib/x86_64-linux-gnu/ && pushd $_
cp /lib/x86_64-linux-gnu/libzstd.so.1 .
cp /lib/x86_64-linux-gnu/liblzma.so.5 .
cp /lib/x86_64-linux-gnu/libcrypto.so.3 .
cp /lib/x86_64-linux-gnu/libc.so.6 .
popd

# Copy 9p modules + deps from host into initramfs
mkdir -p fs/lib/modules/$KVER/kernel/{net,fs}/
cp -a /lib/modules/$KVER/kernel/net/9p      fs/lib/modules/$KVER/kernel/net/
cp -a /lib/modules/$KVER/kernel/fs/9p       fs/lib/modules/$KVER/kernel/fs/
cp -a /lib/modules/$KVER/kernel/fs/netfs    fs/lib/modules/$KVER/kernel/fs/

cp -a /lib/modules/$KVER/modules.* fs/lib/modules/$KVER/

# Pack initramfs
pushd fs/
find . -print0 | cpio --null -o --format=newc | gzip -9 > /challenge/initramfs.cpio.gz
popd

# Clean alls
rm -rf /src
EOF

