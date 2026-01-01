+++
title = "Running Linux on a RiscPC - why is it so hard?"
date = "2025-12-02"
+++

I want to run Debian on my RiscPC, for reasons I'll get into.

However, it was unexpectedly difficult to get working, and I want to record the process I went through. Or, at least the outcome of the process - there's been so much rebooting and trying things and rebooting and trying different things and rebooting and trying the first things again because maybe it's different now? And then more rebooting and more trying the same things because I forgot I'd tried them twice already. So, these are the edited highlights.

## Why the RiscPC?

Because it's an ARM desktop, like a modern Mac. But from 1994. We had them at school and I have fond memories of them.

Inside, there's an ARM710 processor (implementing the ARMv3 architecture), 41 MiB of RAM (the 1 MiB of video RAM is included in the memory count for ... reasons), and a 1 GB EIDE hard drive. It natively boots into RISC OS 3.6. Which is fine! I like RISC OS, especially version 3.6. But I also like UNIX machines and RISC OS isn't even remotely like UNIX. So maybe I can dual boot and get myself something like a Raspberry Pi Zero, but with one sixth of the RAM, and one twentieth the clock speed.

## Why Debian?

Because I like Debian, and I'm used to using Debian. And I thought it would be interesting to try an older version and see what is the same, and what has changed.

## Are there other Linux distros for RiscPC?

There is *ARMLinux* which appears to be a rebuild of [Red Hat Linux] for ARMv2, with a custom bootloader for the Acorn Archimedes (the machine that came before the RiscPC). I cannot find a copy online, but apparently CJE Micros [stock the commercial variant that was produced by Aleph One].

There's also Slackware (or ArmedSlack as the early versions for Arm were called), but it only supports Arm Architecture version 4 (ARMv4). My RiscPC has an ARM710 processor that only implements ARMv3 - you need a StrongARM to get ARMv4 support. I don't want a StrongARM CPU (even though it's much much faster than my ARM710) because it requires RISC OS 3.7, and I don't want RISC OS 3.7 because they changed the boot logo away from the old Acorn one that I grew up with. I'm sticking with RISC OS 3.6 and the ARM710.

[Red Hat Linux]: https://en.wikipedia.org/wiki/Red_Hat_Linux
[stock the commercial variant that was produced by Aleph One]: https://www.cjemicros.co.uk/micros/individual/newprodpages/prodinfo.php?prodcode=ALE-ARMLINSH

## Debian 2.2 (Potato)

Debian 2.2 (Potato) is available from [the Debian Archive] in [`/debian/dists/potato`]. In [`/debian/dists/potato/main/disks-arm/current/`] you will find a Linux kernel for RiscPC, and some disk images. However you will not find a bootloader to jump you into Linux from RISC OS. I think I read on some old mailing lists there were issues with the license the ARMLinux bootloader was under, so they couldn't ship it with Debian.

[the Debian Archive]: https://archive.debian.org
[`/debian/dists/potato`]: https://archive.debian.org/debian/dists/potato/
[`/debian/dists/potato/main/disks-arm/current/`]: https://archive.debian.org/debian/dists/potato/main/disks-arm/current/

## Debian 3.0 (Woody)

Debian 3.0 (Woody) is available from [the Debian Archive] in [`/debian/dists/woody`]. In [`/debian/dists/woody/main/disks-arm/current/`] you will find a copy of `!dInstall`, as `dinstall.zip`. This zip file contains both `linloader`, a RISC OS to Linux bootloader, and an application which uses `linloader` to boot a packaged kernel and initrd. The *Obey file* for the `!dInstall` program looks like:

```text
| start the Debian installer
Set dInstall$Dir <Obey$Dir>

linloader <dInstall$Dir>.linux initrd=<dInstall$Dir>.root root=/dev/ram
```

So it appears `linloader` takes a kernel name, an optional `initrd=` argument to load an initial RAM disk, and then a bunch of arguments which it passes to the kernel in the normal fashion.

This copy of `!dInstall` includes Linux 2.2.19 for RiscPC, and an ext2 formatted initrd. And it doesn't boot.

I don't know what's wrong, but it appears the the initrd uses busybox, and busybox crashes - hard. If you do the default boot, it crashes after printing a line about `Starting INIT` (which is busybox wearing its `init` hat). If you try and boot to a single user shell with `init=/bin/sh`, busybox crashes whilst wearing its `sh` hat. I don't know what is going wrong here, and I don't have a good way to find out. I did try to boot the initrd inside `qemu-system-arm` using a Linux kernel I'd compiled myself, and it worked fine. My best guess is that the binary accidentally includes either ARMv4 instructions, or some kind of misaligned load that works on a StrongARM (because I assume someone tested this image, and if they did they almost certainly used a 200 MHz StrongARM and not a 40 MHz ARM710), but that does not work on my ARM710. There's also the possibility that my RiscPC is broken, but everything else seems to work OK. It could be a bad bit in my DRAM that the POST fails to detect, but I added another 8 MiB stick to my existing 32 MiB stick, and even tried just two 8 MiB sticks, and none of that changed anything.

[`/debian/dists/woody`]: https://archive.debian.org/debian/dists/woody/
[`/debian/dists/woody/main/disks-arm/current/`]: https://archive.debian.org/debian/dists/woody/main/disks-arm/current/

## A Woody Potato

What about if we use `linloader` from Woody to boot the Potato kernel and ramdisk?

I copy the files to RISC OS using an FTP client, and from the F12 prompt I run:

```console
* linloader kd22 initrd=rd22 root=/dev/ram
```

*Side note*: The file `kd22` is what I called the kernel from [`/debian/dists/potato/main/disks-arm/current/`], because its the *kernel* from *Debian 2.2*, and `rd22` is the matching `root.bin` file from the same place. I had a lot of kernels kicking around and it was getting tricky to keep things in order, so this is what I came up with.

The boot process looks like this:

{{ youtube(id="71PGoDGjVr4") }}

Now we are booted into kernel 2.2.19, dated `Sun Apr 15 17:34:01 BST 2001`, and looking at the old Debian 2.2 Installer. However, this installer does not know about how we partition things on Acorn machines so we cannot use it to install onto the one hard disk we have.

## Partitioning

The [Arm Linux] site still [has a page on `!PartMan`]. What we need to do is:

* Turn off the machine
* Unplug the CD-ROM and add a second hard disk drive
* Boot back into RISC OS
* Use `!HForm` to format the second drive, but limit the number of cylinders you use for the ADFS/FileCore filesystem.
* Use `!PartMan` to add Linux partitions *after* the ADFS portion. You'll need one for swap and one for root.
* Copy all your RISC OS stuff over to the `ADFS::5` volume
* Turn off the machine
* Remove your old hard disk and make your new hard disk your principal IDE device, with the IDE CD-ROM as the second device

Yes ... it's a lot. You're spoiled by all this modern partition resizing as part of the install!

Sadly, whilst the instructions are up, the Arm Linux site doesn't have a copy of `!PartMan` - the download page points to an FTP site that has since been re-organised and the files we need are missing. But, if you search online for `partman.arc`, you find the folder <https://ftp.gwdg.de/pub/linux/misc//linux.org.uk/linux/arm/arch/rpc/tools/>, which does still have a copy. Thank you *Gesellschaft für wissenschaftliche Datenverarbeitung mbH Göttingen* (the Society for Data Processing Ltd, Göttingen) for keeping around this ancient backup of the old Arm Linux pages.

[Arm Linux]: https://www.arm.linux.org.uk/
[has a page on `!PartMan`]: https://www.arm.linux.org.uk/machines/riscpc/partman/

## Installing a Potato

I got back into the Potato installer, dropped to a shell and manually formatted and mounted my new root filesystem (`mkfs.ext2 /dev/hda4` and `mount /dev/hda4 /target`) and ... I still couldn't get it to install right.

There is a file called [`base2_2.tgz`] online, which seems to contain a basic Potato install that we could unpack to `/target`. However, the Potato kernel is 2.2.19 but the modules in the Potato initrd are for 2.2.17 and cannot be loaded.  As the ADFS support is in a module, this means we cannot read our ADFS volume from Linux. I don't have working networking, and the floppy drive doesn't seem to work under Linux either.

[`base2_2.tgz`: https://archive.debian.org/debian/dists/potato/main/disks-arm/current/base2_2.tgz

What I did (I think) was boot with the Woody kernel (also 2.2.19, but built slightly later and I assume with a different config) and the Potato initrd, and then get the `drivers.tgz` file from the Woody CD-ROM (which I burned to one of my last remaining blank CD-Rs), which contains the correct kernel modules, from which I could unpack and load the `adfs.o` module, and from there I could access files from my RISC OS filesystem.

And because initrds are ephemeral, I have to do this every time I boot into the installer. I have booted into the installer *a lot* whilst trying to work all this out.

Anyway, I unpacked the tarball onto my mounted `/dev/hda4`, went back to RISC OS, and then used `linloader` to boot into it, with `linloader kd30 root=/dev/hda4`.

Having done all that I ended up with ... a broken mess. It sort of booted to a login but, for reasons I could not work out, `grep` would segfault. And it turns out the standard Debian `init` system calls `grep` a lot and so I got an awful lot of errors on startup. I futzed around with this for ages, trying to substitute `busybox` for grep, and got something that sort of booted, but `init` used arguments to `grep` that `grep -> busybox` didn't like.

It might be that Potato `grep` and Woody `busybox` have the same problem? No idea.

## New Plan

Debian Arm Linux supports a few different machines - the Risc PC, the Netwinder, and the [LART]. It seems the LART folder has a root filesystem - I wonder what happens if we unpack that to our hard drive and then boot it?

[LART]: https://chronicles.debian.org/www/News/2000/20001123.en.html

```console=
# mkdir /debian-arm-root
# mount /dev/hda4 /debian-arm-root
# mkdir /mnt/cdrom
# mount /dev/hdb /mnt/cdrom
# zcat /mnt/cdrom/dists/woody/main/disks-arm/current/lart/root.tar.gz | tar xvf -
# sync
# reboot
```

Note that the `busybox` shell I'm in from the potato initrd doesn't have tab completion. Nor can you press *Up* to get the previous command back if you mistype it. We're playing in Hard Mode here folks.

Does it boot?

```console=
* dir Linux
* linloader kd30 root=/dev/hda4 rw
Uncompressing Linux..........................
<kernel noises>
init started: BusyBox v0.60.3-pre (2002.01.22-07:09+0000) multi-call binary
```

No. It hangs, just like the riscpc initrd does. Busybox really doesn't like my computer.

## debootstrap

There's a tool for making Debian installs in a folder on your Linux machine - `debootstrap`. So can we make a Woody Arm folder on my desktop PC, tar it up and copy it over?

Yes we can.

```bash
mkdir woody_chroot
cd woody_chroot
sudo debootstrap --foreign --arch arm woody . http://archive.debian.org/debian
sudo tar cvzf ../woody_chroot.tar.gz .
```

But back in `initrd` land on the RiscPC, our `tar` is just Busybox, and it doesn't like the `tar` file I created on my desktop - it keeps telling me it's skipping things due to bad headers. Ok, well, can I do the dance to get ADFS up and running, loopback mount the Woody initrd from inside the Potato initrd, chroot into the Woody initrd, and use *that* copy of `tar` to unpack the tarball? Yes, I can!

Does it boot?

No, it does not!

It seems `debootstrap` leaves you with a very minimal `/dev/` and the system boots to *Cannot find initial console* or something. I think this means `/dev/console` is missing?

## What about Debian 3.1 (Sarge)?

I tried sarge, but the kernel faults on start-up. I assume it's been compiled for StrongARM (armv4). I tried the Woody kernel with the Sarge initrd but the kernel was missing some syscalls and it didn't boot.

## custom initd

How about I try and make a custom initd with all the right kernel modules available? Well I tried modifying the Potato initrd, and I recall I ran out of inodes quite quickly. I tried making an initrd from a new ext2 disk image, and Kernel 2.2 wouldn't mount it because it didn't like the 'magic number'. I tried putting the modules on a floppy disk, but the kernel apparently doesn't have working floppy drive support.

But in the end, I was able to get a modified Woody initrd to work. So, here's how to modify the Woody `initrd` with a copy of `bash` from the debootstrap chroot, along with the kernel modules we need. 

```bash
# let's make a custom ramdisk from the woody initrd
cp rd30 custom.img
mkdir ./mnt
sudo mount -o loop ./custom.img ./mnt
# clean out stuff we don't need (we're tight on space, and hardlinks mean we can end up with wget replacing busybox :/)
sudo rm ./mnt/bin/sh
sudo rm ./mnt/lib/libc.so.6 ./mnt/lib/libc-2.2.5.so
sudo rm ./mnt/lib/ld-linux.so.2 ./mnt/lib/ld-2.2.5.so
# busybox wget segfaults - get the real thing
wget https://archive.debian.org/debian/pool/main/w/wget/wget_1.8.1-6.1_arm.deb
mkdir wget
dpkg -x ~/Downloads/wget_1.8.1-6.1_arm.deb wget
sudo cp ./wget/usr/bin/wget ./mnt/usr/bin/wget
# Copy in the modules we need
sudo cp ./chroot/lib/modules/2.2.19/cdrom/cdrom.o ./chroot/lib/modules/2.2.19/block/ide-cd.o ./chroot/lib/modules/2.2.19/fs/adfs.o ./chroot/lib/modules/2.2.19/net/8390.o ./chroot/lib/modules/2.2.19/net/etherh.o ./mnt/lib/modules
# Let's get bash, and the libraries it needs
sudo cp ./chroot/bin/bash ./mnt/bin
sudo cp ./chroot/lib/libncurses.so.5 ./chroot/lib/libdl.so.2 ./mnt/lib
sudo umount ./mnt
```

This is a sanitised history cut and paste from by actual bash history, so sorry if it has any errors in it. Hopefully it gives you the idea of what we're trying to do here. Let's get `custom.img` over on to the Risc PC and boot it:

```console
* linloader kd30 initrd=custom/img root=/dev/ram init=/bin/bash rw
```

Oh, RISC OS using `/` as a replacement for `.` because `.` is the directory path separator will never stop being weird.

```console=
init-2.05a# mount -t proc /proc /proc
init-2.05a# cd /lib/modules
init-2.05a# insmod 8390.o
init-2.05a# insmod etherh.o
init-2.05a# insmod adfs.o
init-2.05a# insmod cdrom.o
init-2.05a# insmod ide-cd.o
hdb: ATAPI 4x CD-ROM drive. 256kB Cache
init-2.05a# mkfs.ext2 /dev/hda4
init-2.05a# swapon /dev/hda3
init-2.05a# mount /dev/hda4 /target
init-2.05a# ifconfig eth0 up
init-2.05a# ifconfig eth0 192.168.50.12
init-2.05a# route add default gw 192.168.50.1
init-2.05a# echo "nameserver 192.168.50.3" > /etc/resolv.conf
```

Now, whatever you do, DO NOT PING SOMETHING HERE. Ctrl+C handling doesn't work, so if you start a `ping` and forget to set the maximum number of pings it will do, it will ping forever and you'll have to reboot. And you're rebooting without unmounting an ext2 filesystem, which is really risky. I've done this at least four times now and fsck has fixed several things that I hope weren't important.

OK, let's try `/sbin/dbootstrap` and see if we can get something installed.

No, it segmentation faults.

I'm reading the dboostrap source code (it's in <https://archive.debian.org/debian/pool/main/b/boot-floppies/boot-floppies_3.0.22.tar.gz> ... for reasons) and ... oh, I think it's failing to loopback mount stuff. Did I add the `loop.o` module? I did not. Also, I forgot `isofs.o`.

Let's use wget to get those!

```console=
init-2.05a# cd /lib/modules
init-2.05a# wget http://my-desktop:8000/isofs.o
init-2.05a# insmod ./isofs.o
init-2.05a# wget http://my-desktop:8000/loop.o
init-2.05a# insmod ./loop.o
init-2.05a# cd /
init-2.05a# ./sbin/dbootstrap
```

OK, off we go again! Skip the swapfile setup (swap is enabled, it just cannot see it). Now it finds the CD-ROM and it looks like it's installing things. Excellent. An alarming pause whilst it installs "Device drivers" ... but it comes back. Some network questions. Now "Installing base system". Is this going to work?

No.

```text=
Failure trying to run: chroot /target dpkg --install --force-depends --install /var/cache/apt/archives/base-files_3.0.2_arm.deb /var/cache/apt/archives/base-passwd_3.4.1_arm.deb
```

## Manually installing things

I dropped to a shell and ran the same command and it failed because the environment variable `PATH` was not set. Except it was set because I could `echo $PATH`. This is probably a `bash` / `ash` issue.

OK, fine. Apparently I have a folder on my root partition with all the `.deb` files I need, I can chroot into that partition. So can I just `dpkg --install *.deb`?

Mmmm. Dependencies are a thing and many packages are grumpy because other packages are missing. The installer probably installs and configures these packages in the right order, but it's late and I'm tired so I'm just going to brute force it with:

```console=
init-2.05a# chroot /target
sh-2.05# cd /var/cache/apt/archives
sh-2.05# dpkg --install -R .
```

I get an issue with `exim` because `hostname --fqdn` doesn't work. I should probably set the hostname and try again. `dpkg` helpfully gives me a list of the packages that didn't install right, and I try them all again repeatedly until they're all happy.

But does it boot?

```console
* linloader kd30 root=/dev/hda4 rw
... kernel noises...


riscpc login:
```

Alright, Woody on a RiscPC! And no `grep` failures or anything weird like that. I can log in as `root`, no password. But, I have no `/etc/fstab`. I guess there was some post-install step that `dbootstrap` never got to do. That's OK, I can do that. I should set up some modules to load too.

```console=
riscpc:~# nano /etc/fstab
riscpc:~# cat /etc/fstab
/dev/hda4 / ext2 defaults 0 0
/dev/hda3 none swap defaults 0 0
/proc /proc proc defaults 0 0
riscpc:~# depmod -a
riscpc:~# nano /etc/modules
riscpc:~# cat /etc/modules
etherh
ide-cd
riscpc:~# passwd
Enter new UNIX password:
Retype new UNIX password:
riscpc:~#
```

After a reboot, we're all good. Even networking works!

## Conclusions

Well, this was a mess. I don't know why Potato is so crashy when I install it. I don't know why the busybox binary in the Woody initrd is so broken. But I've got it installed, and now I can do circa-2004 UNIX things with a machine from 1994.

Two things remain on the TODO list:

1. Get `linloader` to ask if I want to boot Linux *before* it boots the whole RISC OS desktop
2. Let's try and get XFree86 working...
