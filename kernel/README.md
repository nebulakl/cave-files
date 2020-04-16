kernel configuration based on [linux-zen](https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux-zen) without unnecessary modules.

currently targets 5.6.4-zen1

incomplete notes on building w/ llvm

```bash
mkdir out
export LLVM_PATH=/mnt/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04/bin

make CC=$LLVM_PATH/clang LD=$LLVM_PATH/ld.lld AR=$LLVM_PATH/llvm-ar NM=$LLVM_PATH/llvm-nm STRIP=$LLVM_PATH/llvm-strip \
OBJCOPY=$LLVM_PATH/llvm-objcopy OBJDUMP=$LLVM_PATH/llvm-objdump OBJSIZE=$LLVM_PATH/llvm-size \
READELF=$LLVM_PATH/llvm-readelf HOSTCC=$LLVM_PATH/clang HOSTCXX=$LLVM_PATH/clang++ HOSTAR=$LLVM_PATH/llvm-ar \
HOSTLD=$LLVM_PATH/ld.lld O=out

```