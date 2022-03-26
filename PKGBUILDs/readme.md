# linux-chromebook-cave

Vanilla Arch Linux kernel with a custom configuration that has the following built-in:

* chromebook-specific modules
* microcode update for m3-6Y30 (or other CPUs in the same family)
* f2fs support

This allows for booting without an `initramfs`.

Ideally we should also remove the majority of unused modules, but that is a wip.

# chromebook-update-kernel
Includes a script to update kernel partition.

Also includes a hook to invoke the script whenever `linux-chromebook-cave` gets upgraded.

# vboot-utils
A copy of https://aur.archlinux.org/packages/vboot-utils, needed to sign and package kernel image for Depthcharge

# trousers
A copy of https://aur.archlinux.org/packages/trousers, requried by `vboot-utils`
