+++
title = "Arm Linux"
date = "2025-05-26"
+++

## Background

The ARM processor has just turned 40 years old. Originally designed at Acorn and then spun-out into its own company, it was used the Acorn Archimedes line (ARMv2) and RiscPC line (ARMv3 for the models with the ARM610 and ARM710 CPU, and ARMv4 for final models with the DEC StrongARM CPU).

Linux runs on Arm. You've run it on a Raspberry Pi. Most phones run Android on Arm, which uses a Linux kernel. Linux has been running on Arm for a long time. But did it ever run on an Acorn?

The answer is: it never ran on an Archimedes, but it did run on the RiscPC.

Can you still run Linux on the RiscPC? Well. I have a RiscPC 700. Let's run Linux on it!

## Modern Linux

Linux still [claims to support the RiscPC](https://github.com/torvalds/linux/tree/master/arch/arm/mach-rpc), however, support has apparently been broken for a while because no-one is really testing it. GCC stopped supporting ARMv3 [many years ago](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=1930b04cbc45ba2d3810c2cd29b1feabd46ad0c8).

You can try and compile Linux 6.14 for RiscPC, but you'll get a kernel that won't work. Plus it will be absolutely huge.

But maybe we can go and get an old Linux kernel?

## ARM Linux for Acorn

Russell's website <https://www.arm.linux.org.uk> is still up and [has a page on the RiscPC](https://www.arm.linux.org.uk/machines/riscpc/installing.php). However, the page dates from a time when files for download lived on an FTP server and not the webserver, and the FTP server has been re-organised so many of these ancient files are missing. I've tried various combinations of things I found, but I couldn't get anything to boot.

And how does it boot anyway?

## Booting Linux from RISC OS

Acorn's ARM machines boot into RISC OS - a graphical desktop environment. You can still get RISC OS 5 today and run it on a Raspberry Pi if you like - although it's resolutely 32-bit, has no memory protection and no Wi-Fi support. And it won't even run many classic Acorn applications because they assume the CPU is in 26-bit mode (where the Processor Status Register was hidden in the six unused bits in the Program Counter to give you one less register to push and pop on context switch - wild times).

But anyway, being a non-memory-protected OS has its advantages here. A fairly standard RISC OS application can load just the Linux kernel off the RISC OS (ADFS) formatted hard disk and into some spare RAM, and then jump to it (a bit like booting Linux from MS-DOS).

But to do that, I'd need a Loader. I tried some from today's [ftp.armlinux.org.uk](https://ftp.armlinux.org.uk/pub/linux/arm/Old/RISCOSKernel) but I had no luck. It would unpack the kernel and then crash trying to run it. I suspect the issue was that many 2000's Arm Linux things assumed you had upgraded to an ARMv4 DEC StrongARM CPU - because why wouldn't you? It ran at 200 MHz and absolutely flew compared to a 40 MHz ARM710. And if you were running Linux you probably weren't even that bothered about the backwards compatibility.

I tried looking at various old copies of RISC OS magazines - they often came with Linux on the cover CD. But I couldn't get any of those to work either.

I reached out to Russell King himself and, whilst he was gracious to reply to my absurd queries about 25 year old Linux on a 30 year old computer, he understandably couldn't provide any help.

## A Woody Potato

Searching for the "ARM Linux CD" mentioned on armlinux.org.uk drew a blank, but today I thought to try looking at very old copies of Debian. Debian 3.0 (Woody) is still available at <https://archive.debian.org/debian/dists/woody/>, and, somewhere [deep in the tree](https://archive.debian.org/debian/dists/woody/main/disks-arm/current/riscpc/dinstall.zip) is a zipped copy of a new loader I hadn't tried, `!dinstall`.

I copied it to my RiscPC, unzipped it and ... it booted the kernel! But, it then hung starting BusyBox (which symlinked as `/sbin/init`). So close, but so far.

Not quite ready to give up, I looked at Debian 2.2 (Potato). This unfortunately doesn't come with a loader (I guess it was new in 3.0), but they do have a [kernel](https://archive.debian.org/debian/dists/potato/main/disks-arm/current/riscpc/linux) and an [`initrd`](https://archive.debian.org/debian/dists/potato/main/disks-arm/current/riscpc/images-1.44/root.bin).

Surely it wouldn't be enough to just copy those over the top of the ones supplied in `!dinstall`?

([youtube.com](https://www.youtube.com/watch?v=71PGoDGjVr4))

Of course getting into the installer is only half the battle.

## Installing Debian on a RISC OS machine

The RISC OS operating system uses ADFS as its native filesystem (also known as `FileCore` for the RISC OS module that implements it). This filesystem does not support partitions. So, to make space for a Linux root filesystem and swap partition, we need to reformat our hard disk using [`!HForm`](http://www.riscos.com/ftp_space/generic/hform/index.htm) and lie about how many cylinders it has. Then, in the Debian installer it runs `cfdisk` and we lie about where the partition should start. Hopefully then Linux and RISC OS use different parts of the disk and play nicely with each other.

But this means formatting my hard disk, and I like all the stuff I have on my hard disk. So I had to get a *second* hard disk, fit it, format it, and back up everything.

And at the first attempt, formatting the partitions in Linux has trashed the ADFS part of my hard disk. I suspect this was because I used a much later RISC OS Open Ltd (ROOL) version of `!HForm` (2.78). I probably should have used the original version 2.48 from RISC OS 3.7.

Except.

RISC OS Zip files can only be unpacked in RISC OS, because ADFS has different file types and filename conventions compared to UNIX or MS-DOS (like `.` is the directory separator, so `/` is a valid filename character). So I need to use a RISC OS unzip tool to unpack the new copy of `!HForm`. But my hard drive is now blank because of the corruption caused by the Linux partitioning.

So, I dig out a special copy of a RISC OS unzip program which is written as a BASIC program. I then execute that from a floppy disk, which self-extracts onto that same floppy disk. I then unpack `!HForm` on the same disk and re-partition the hard drive again. Once I know Linux is working, I'll restore all my stuff from the backup hard disk, but I'm not swapping drives around unnecessarily - I know I'll need the CD-ROM shortly to install Debian, and I can only have two IDE drives in this machine.

But this doesn't work because I used an MS-DOS formatted floppy to transfer `HForm.zip` to the RiscPC - you can't write an ADFS disk from Linux, and my USB floppy drive only likes 1440K formatted disks anyway. Uh ... let's use a RAM Disc! That works in RISC OS 3.6 with no boot drive, right? Yes it does.

OK, self-extract `!SparkPlug` to the RAM drive, edit it to stop complaining about the lack of a `System` folder, then unpack the old version of `!HForm` using it. Now I can reformat the floppy disk as ADFS and backup the tools there for next time I have to do this. Or times. I suspect we'll be going around this loop a lot over the next few hours.

My joy is short-lived as I realised the Linux kernel and `!dinstall` program have also been wiped, so I need to plug in the back-up drive anyway. Let's do that.

Two hours pass.

I am unable to make partitions using `cfdisk` in Debian that both the Linux kernel are happy with and that don't trash my FileCore volume. The Arm Linux documentation talks about a tool called "PartMan". I find a modern version of PartMan from 2024, but I am unable to create the partition layout I want with it. I search for "partman.arc" and the two Arm Linux docs pages appear, but their links to the FTP server are long since dead. Only a third entry comes up in the search.

A mirror of a mirror of the original Arm Linux FTP server, at <https://www.mmnt.net/db/0/0/ftp5.gwdg.de/pub/linux/misc/linux.org.uk/linux/arm/arch/rpc/tools/src>.

Surely not?

>  Requested page not found.

Oh.

But I wonder if `ftp5.gwdg.de` is still an FTP server?

```console
$ ftp ftp5.gwdg.de
Trying 134.76.12.6:21 ...
Connected to ftp6.gwdg.de.
220-Welcome to ftp.gwdg.de
220-
220 
Name (ftp5.gwdg.de:jonathan): anonymous
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
229 Entering Extended Passive Mode (|||30314|)
150 Here comes the directory listing.
drwxr-xr-x   61 ftp      ftp          4096 May 26 03:31 pub
226 Directory send OK.
ftp> cd pub/l
languages		linux			locatedb.gz		loki.zip
latex			locatedb		locatedb.version
ftp> cd pub/linux/mi
mirrors	misc
ftp> cd pub/linux/misc/lin
linux.org.uk	linvdr
ftp> cd pub/linux/misc/linux.org.uk/linux/arm/arch
250-
250- This is the architecture specific area of the FTP site.  Please
250- choose one of the following architectures:
250-
250-   a5k          A5000 and similar machines
250-   ebsa110      EBSA110 evaluation board
250-   ebsa285      EBSA285 evaluation board
250-   rpc          RiscPC machines
250 Directory successfully changed.
```

Well! Let's grab `partman.arc` and see if we can get that to make the right disk layout.

Well, the Linux kernel likes it. But the Debian Potato installer does not.

OK, let's make an ISO with all the things I think I might need. And let's see if we can get enough stuff unpacked onto the hard disk despite the Potato installer not liking our partition set-up.
