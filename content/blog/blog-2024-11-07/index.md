+++
title = "Backwards Compatible"
date = "2024-11-07"
+++

## Retro Computer Festival 2024

I am presenting again at the Retro Computer Festival 2024, at the [Centre for Computing History](https://www.computinghistory.org.uk/) in Cambridge, England. The event is being held on the 9 and 10 of November, 2024.

For my table at this event I have chosen the them "Backwards Compatible". My table offers a small exploration of what it means to be backwards compatible, what this has meant for computer systems in the past, and what this might mean for systems in the future.

I am presenting three main machines (assuming they still work on arrival at the museum).

## The BBC Master 128

The BBC Master 128 is a BBC branded microcomputer made by Acorn Computers. The technical specifications are:

* GTE 65CSC12 CPU (a licensed WDC 65C02 clone) at 2 MHz
* 128 KiB RAM
* 128 KiB ROM, with sockets for expansion
  * 16 KiB Acorn MOS 3
  * 16 KiB Terminal Emulator
  * 16 KiB Advanced Disc Filing System
  * 16 KiB Acornsoft View (Word Processor)
  * 16 KiB Acorn Screen Editor (Text Editor)
  * 16 KiB BBC BASIC
  * 16 KiB Acornsoft ViewSheet
  * 16 KiB Disc Filing System
* Motorola 6845 CRT Controller (for bitmap graphics output)
* Mullard SAA5050 Teletext chip (for pure text mode output)
* TI SN76489 4-channel mono DSG

These don't move very far on from the specifications of the earlier BBC Micros from December 1981:

* MOS 6502 at 2 MHz
* 16 KiB RAM (Model A) or 32 KiB (Model B)
* 32 KiB ROM, with sockets for expansion
  * 16 KiB Acorn MOS 1.2
  * 16 KiB BBC BASIC
* Motorola 6845 CRT Controller (for bitmap graphics output)
* Mullard SAA5050 Teletext chip (for pure text mode output)
* TI SN76489 4-channel mono DSG

On the one hand, carrying over the 8-bit 6502 based CPU and keeping the same basic architecture as the BBC Micro means that many BBC Micro applications will work just fine on the BBC Master. It can read/write the same disc formats (DFS), execute the same instructions, and has screen memory at the same address as the earlier system.

The tradeoff, however, is that the performance of the machine is somewhat limited. This is 2 MHz 6502 machine (albeit with a very trick implementation of BASIC), launched in 1986 at a price of £499 for the bare unit. The Atari 520ST of 1985 launched at £750 including a monitor, and that got you an 8 MHz 68000, 512 KiB of RAM and a built-in 3.5" floppy drive.

The paging of 16 KiB ROMs into the 64 KiB address space of the 6502 architecture doesn't help performance. Plus the fact the ROMs are different, along with some hardware changes, meant that quite a few games written for the BBC Microcomputer didn't work correctly on the BBC Master.

Ultimately Acorn took a clean break from the 8-bit world with their 32-bit Arm based Archimedes system that arrived a year later in 1987 (although the OS on that machine bears many hallmarks of the earlier Acorn MOS). Despite that, machines from the BBC Master Series managed to survive on sale until 1994.

## The Commodore 128D

Commodore entered the computer market with the Commodore PET in 1977. It used the MOS 6502 CPU and had a text-only video output and started with just 4 KiB of RAM. In 1981 they released a 6502 based machine called the VIC20. This featured a new integrated Video Interface Chip that could produce both text and graphics, but was limited by having just 5 KiB of RAM. Despite the limitations, the VIC20 sold 2.5 million units.

The VIC20 was followed by the very popular Commodore 64. This upgraded the RAM to 64 KiB, switched to the improved VIC-II video chip which offered sprite support, and added a remarkably capable synthesiser chip called the SID. This made the C64 a compelling gaming machine, and it was sold at a great price. Numbers vary, but it is believed that around 10 million units were sold (both the original C64 and the later cost-reduced C64C version) between 1982 and 1994.

In 1984, Commodore introduced a lower-cost machine aimed at taking on the Sinclar ZX Spectrum. It used the new, highly integrated, TED chip; this handled sound, text and graphics - but didn't include sprite support because it was aimed at replacing the VIC20. However, Commodore management misunderstood the product, and the marketplace, and what should have been a $49 machine went on sale as two machines - the $99 Commodore 16, and a $299 business machine with a mediocre built-in productivity applications called the Plus/4.

Many buyers bought these machines thinking they could run their existing Commodore 64 software on it (the C16 even shipped in basically a grey C64 case), but were sorely dissapointed.

Perhaps burned by this feedback, they set out to make their next machine 100% Commodore 64 compatible. This machine was launched as the Commodore 128 of 1985.

What we have on display is the desktop variant - the Commodore 128D. This uses the same PCB inside as the 'flat' Commodore 128, but includes an integrated PSU and Commodore 1571 disk drive, but has an external keyboard.

The system specs are ... quite something:

* MOS 8502 CPU at 1 MHz (in 40 column mode) or 2 MHz (in 80 column mode)
* Zilog Z80 CPU at 4 MHz
* 128 KiB RAM
* VIC-IIE 40-column video chip
  * fully VIC-II compatible, but limits 8502 clock speed to 1 MHz when running
  * Produces NTSC/PAL 240/288 line composite/luma-chroma output
* VDC 80-column video chip, with dedicated 16 KiB of VRAM
  * Produces CGA-style 200-line TTL output
* SID sound chip (same as the C64)
* A set of Commodore 64 ROMs, with BASIC 2.0
* A set of Commodore 128 ROMs, with:
  * BASIC 7.0
  * Sprite Editor
  * CP/M CBIOS

If you boot a C128 by holding down the Commodore key (or if you enter the BASIC command `GO 64`), you get a machine that is 99.9% C64 compatible.

As an example, the developers tried to use an updated font ROM in C64 mode, but it didn't work on all software. One particular application would take the glyphs from the font ROM and blow them up really large as part of the title screen. The application would then do a flood fill operation on each character, to change its colour. A neat trick, to reduce program size! But, when tested on an early C128 prototype, the flood-fill operation 'missed' the relocated dot above the letter `i`, causing the entire screen to be flood filled, which took a significant amount of time. Lessons were learned - and the C128 shipped with both its newly updated font ROM, and a pixel-perfect copy of the C64 font ROM.

The Commodore 64 was available with an add-on cartridge containing a Z80 CPU, which then offered CP/M compatibility. Because the C64 only had 40-column video, and almost all CP/M software expected 80-columns, this was not a popular product. However, the cartridge didn't work on the early C128 prototypes, and management insisted they had full C64 compatibility. The solution was to simply include the cartridge inside the C128 - it ships with both a 6502-compatible 8502 CPU, and a Zilog Z80. If you insert the special boot disk, it will boot up into CP/M 3.0.

The floppy drive also offered exceptional backwards compatibility. The original Commodore 1540 drive from the VIC20 was hamstrung by a bug in a shift register that meant they had to use software to push bits over the serial bus. This massively limited performance. The Commodore 1541 for the Commodore 64 was designed to be 1540 compatible, and so it used the same appalling slow interface. The Commodore 1571 for the Commodore 128, then needed to be fully Commodore 1541 compatible, so again, the performance is still awful. However, the 1571 does have a 'turbo' mode it can enter when it knows it is talking to a C128 with a working shift register. It was also double-sided, and could read both GCR encoded disks from earlier Commodore machines, and MFM encoded disks from an IBM PC. Programs like Big Blue Reader would let you copy files between differently encoded disks, making the C128 and 1571 (or just a C128D, which is the same thing in one box) a very useful retro machine to keep around.

Perhaps because of the excellent compatibility, this is hardly any C128 native software, and very few C128 native games. Games simply put "C64/C128 compatible" on the cover, and explained that the user must hold the Commodore key on start-up in order for the game to work.

The C128 sold 2.5 million units, but was outlived and outsold by its predecessor, the C64.

## The Lenovo ThinkCentre running MS-DOS 3.3

Our final study in backwards compatibility is a [Lenovo Thinkcentre PC from 2014](https://psref.lenovo.com/syspool/Sys/PDF/ThinkCentre/ThinkCentre_E73_Tower/ThinkCentre_E73_Tower_Spec.PDF). It has:

* [Intel Core i3-4130](https://ark.intel.com/content/www/us/en/ark/products/77480/intel-core-i3-4130-processor-3m-cache-3-40-ghz.html) "Haswell" x86-64 2-core, 4-thread CPU at 3.4 GHz
* 4 GB RAM
* Intel HD Graphics
* 500 GB SATA Hard Drive
* SATA DVD-RW optical drive
* No floppy drive

Thanks to the magic of backwards compatibility, this machine is presented natively booting MS-DOS 3.3 from 1987 - an operating system designed to run on an 8088 machine with 32 KiB of RAM.

MS-DOS 3.3 is limited to a maximum partition size of 32 MB, and 640 KiB of RAM, but thanks to the "BIOS Compatibility Support Module" included in the Lenovo's UEFI firmware, it boots and runs just fine.

* The UEFI firmware handles the USB Keyboard and presents it to MS-DOS as a standard i8042 keyboard controller
* The Intel H81 chipset provides all the standard IBM PC/AT hardware, like dual interrupt controllers, DMA controller and timers
* The Core i3-4130 CPU boots with only a single-core running, in 8088 compatible "real-mode"
  * The CPU has 3 MiB of on-board cache, which is three times as much as can be address in real-mode, with its 20 bit addressing
* The BIOS provides the standard disk I/O software interrupts, which present the SATA Hard Drive as a standard block device
* The chipset presents the SATA controller as a standard IDE controller, which works fine with a generic "IDE CD-ROM" driver for MS-DOS

I chose MS-DOS 3.3 because it was the first version of MS-DOS to support the high-density 1.4MB floppy drive. BIOSes of the late 1990s (and apparently the one in this Lenovo) can boot an "El-Torito" format CD-ROM by reading a floppy disk image contained on the CD-ROM and using that to emulate a floppy drive. Despite not having a floppy drive or floppy drive controller, that works fine on this machine. Incredibly, MSCDEX and standard IDE CD-ROM drivers work fine, so you even read the rest of the CD-ROM once you've booted from it. Once MS-DOS was running, the hard drive was partitioned (with a 32 MB partition) and MS-DOS is now also booting and running from the hard drive, leaving the other 476,805 MiB untouched.

This might be one of the first examples of booting MS-DOS 3.3 from a CD-ROM ... because why wouldn't you use MS-DOS 5, or MS-DOS 6.22? Because it's funnier this way, that's why.

Enjoy a selection of MS-DOS programs which have been installed, including Microsoft Windows (the first version), and a few versions of Microsoft Word for DOS.

