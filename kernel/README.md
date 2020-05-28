kernel configuration based on [linux-zen](https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux-zen) without unnecessary modules.

currently targets [5.6.15-zen1](https://github.com/zen-kernel/zen-kernel/archive/v5.6.15-zen1.tar.gz)

## notes on building w/ llvm in a docker container.

compiler: [LLVM 10.0.1-rc1](https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1-rc1/clang+llvm-10.0.1-rc1-x86_64-pc-linux-gnu.tar.xz)

### preparation
assume kernel tarball and the compiler are located in `~/docker/kernel`
```bash
docker run -v ~/docker/kernel:/mnt -it --name cave-kernel ubuntu:devel /bin/bash
apt update; apt full-upgrade -y
apt install build-essential libelf-dev bc flex bison libxml++2.6-2v5 libssl-dev \
            aria2 vboot-kernel-utils
```

### build the kernel
```bash
mkdir out
cp ../config out/.config
export PATH=/mnt/clang+llvm-10.0.1-rc1-x86_64-pc-linux-gnu/bin:$PATH
export KBUILD_BUILD_HOST=localhost
export KBUILD_BUILD_USER=root
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"
make CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm STRIP=llvm-strip \
    OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump OBJSIZE=llvm-size \
    READELF=llvm-readelf HOSTCC=clang HOSTCXX=clang++ HOSTAR=llvm-ar \
    HOSTLD=ld.lld LLVM_IAS=1 O=out -j$(nproc)
```

### sign bzImage with devkeys
```
vbutil_kernel --pack ../linux-zen.img --keyblock /usr/share/vboot/devkeys/kernel.keyblock \
    --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk --bootloader ../boot \
    --config ../cmdline --arch x86 --vmlinuz out/arch/x86/boot/bzImage
```

### final step, done outside docker

`make modules_install` & write `linux-zen.img` to boot partition