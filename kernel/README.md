kernel configuration based on [linux-zen](https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux-zen) without unnecessary modules.

currently targets 5.6.10-zen1

incomplete notes on building w/ llvm

```bash
mkdir out
export PATH=/mnt/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04/bin:$PATH
export KBUILD_BUILD_HOST=localhost
export KBUILD_BUILD_USER=root
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"
make CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm STRIP=llvm-strip \
    OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump OBJSIZE=llvm-size \
    READELF=llvm-readelf HOSTCC=clang HOSTCXX=clang++ HOSTAR=llvm-ar \
    HOSTLD=ld.lld LLVM_IAS=1 O=out defconfig

```