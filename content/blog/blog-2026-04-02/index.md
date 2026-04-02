+++
title = "3.5\" disks for the BBC Master"
date = "2026-04-02"
+++

## Background

I sold my BBC Master at the last Bring and Buy at the Centre for Computing History in Cambridge. However I recently found two of the floppy disks I made for it, and I thought I'd write a few words about them because they are little bit unsual.

The [BBC Master](https://en.wikipedia.org/wiki/BBC_Master) was a development of the [BBC Micro](https://en.wikipedia.org/wiki/BBC_Micro) - both made by Acorn and both based around a 6502 processor. Both machines had an external Shugart style floppy disk interface, and my BBC Master had with it a [3.5" double-density floppy disk drive](@/blog/blog-2023-08-28/index.md). On an IBM PC running MS-DOS, disks in such a drive would be MFM formatted at 250 kbit/s with:

* 512 bytes per sector
* 9 sectors per track
* 80 tracks per side
* 2 sides

Taking *512 × 9 × 80 × 2* we get to 737,280 bytes or exactly 720 KiB. MS-DOS would then put the FAT12 filesystem on the disk, with the 8.3 filenames we're all familiar with.

My BBC Master natively used the [Advanced Disk Filing System (ADFS)](https://en.wikipedia.org/wiki/Advanced_Disc_Filing_System), however it also supported the original [Disk Filing System (DFS)](https://en.wikipedia.org/wiki/Disc_Filing_System) from the BBC Micro. DFS was designed to work with 5.25" floppy disks, [using FM formatting at 125 kbit/s](http://www.primrosebank.net/computers/bbc/floppy_drives.htm) with:

* 256 bytes per sector
* 10 sectors per track
* 40 or 80 tracks per side (depending on the drive)
* 1 side

That gave you 100 KiB or 200 KiB per side depending on the number of tracks your drive mechanism could handle. You could also flip the disk to access the other side. With DFS you got a maximum of 31 files per side, and only 7 ASCII characters per filename. Each file could be 'in' a directory, where the directory name was a single character, but you could not nest directories. The default directory name was `$`.

ADFS added the kind of hierarchical directory structure we are familiar with today, albeit with a maximum directory size of 47 entries, and a still fairly cramped filename length of 10 characters. It also supported a wider range of floppy disk sizes, and my 3.5" double-density floppy disks would usually be MFM formatted at 250 kbit/s with:

* 256 bytes per sector
* 16 sectors per track
* 80 tracks per side
* 2 sides

This is known as ADFS 'L' format, and gives a formatted capacity of *256 × 16 × 80 × 2 = 640 KiB*. This is well with the gross maximum for the medium of 1.0 MiB, from which we must subtract sector headers, checksums, padding, and so on. There were many other variations, that you can read about at [mdfs.net](https://mdfs.net/Docs/Comp/Disk/Format/ADFS).

ADFS retained the unusual property (at least unusual to PC folk) that the root directory was called `$` and the directory separator was the `.` character. That is, the file `DATA` in the `DOCS` directory had the full path `$.DOCS.DATA` (or `ADFS::0.$.DOCS.DATA` if you include the volume). This convention has been retained in RISC OS right up to the present day, whilst under MS-DOS (and even Windows 11 for 64-bit Arm) you'd call that file something like `A:\DOCS\DATA` instead.

You might be thinking "But what if a portable C program tries to open `DOCS.TXT`"? Well, on a Acorn machine that would get you a file called `TXT` in a directory called `DOCS`. Obviously this was a problem when it came to C header files like `stdint.h`, and so the C pre-processor was usually taught that any file called `foo.h` should have its name reversed, thus causing it to look for a file called `foo` in a directory called `h`. Provided you put all your C header files into a folder called `h`, it worked. But it was horrible.

But anyway, my BBC Master had a Pi Tube Direct inside it, which could emulate a [Second Processor](https://www.beebmaster.co.uk/SecondProcessors.html). In my case, I usually had it either emulating a Z80, for running Digital Research's CP/M, or an 80186 for running the mostly MS-DOS compatible DOS Plus from the same company.

## CP/M Disks on a BBC Master

A BBC Master, like a BBC Micro, boots into its copy of BBC BASIC for the 6502 by default. However, when a Z80 Second Processor is detected, the BBC becomes an I/O controller responding to requests over the Tube interface, and a ROM in the Second Processor unit boots the Z80 into Acorn MOS for Z80. From there, most users will boot off the Acorn CP/M floppy disk into CP/M 2.2.

CP/M was [very flexible when it came to disk formats](https://www.seasip.info/Cpm/formats.html) - they were defined by the machine-specific 'BIOS' portion of the operating system rather than the universal 'BDOS' half. This meant that a 5.25" disk formatted in an [Osborne 1](https://binarydinosaurs.co.uk/Museum/Osborne/occ1.php) wouldn't work in a [Epson QX10](https://binarydinosaurs.co.uk/Museum/Epson/qx10.php), even though they could both physically accept the same disk. As an aside, Commodore's solution to this when the Commodore 128 was running in CP/M Mode (with matching Commodore 1571 Disk Drive) was that the BDOS just handled a bunch of different formats and auto-detected which one to use when a disk was inserted.

Despite the flexibility, CP/M does not support either DFS or ADFS format, and much of the CP/M operating system is loaded from floppy disk. Further, Acorn MOS doesn't support the CP/M format. It would be a problem if a user inserted the Acorn CP/M disk whilst the machine was not running CP/M and was told that their disk was not formatted. So, how do you make a disk that is both a valid DFS disk and a valid Acorn CP/M disk containing the CP/M operating system and associated files?

Luckily DFS is a very simple filesystem. The full directory (of 31 entries) is stored in the first two sectors of the first track of the disk, and each file is contiguous so there is no Block Allocation Map or File Allocation Table. CP/M has the concept of a *system track*, which are tracks at the start of the disk reserved for booting the system. If we just tell CP/M that the first track is a *system track*, it will ignore it and the DFS filesystem contained within it.

I have long forgotten *how* exactly I made my 3.5" double-density Acorn CP/M boot floppy, but I've found it and imaged (see [`CPM.IMD`](./CPM.IMD)). It's in IMD format, but you can load it into the [HxC Floppy Emulator Software](https://hxc2001.com/download/floppy_drive_emulator/). In that tool, can see that we have a DFS style disk using FM formatting at 125 kbit/s with:

* 256 bytes per sector
* 10 sectors per track
* 80 tracks per side
* 1 side

{{ image(img="/blog/blog-2026-04-02/hxc.png") }}

A 3.5" disk with FM encoding is unusual, but it works fine.

Let's grab just one side of the disk - the IMD image has the two sides interleaved, but we can break them apart by exporting them from HxC as a raw disk image, and then using:

```bash
split -b 2560 CPM_IMD.img
mkdir side1
mkdir side2
mv *a *c *e *g *i *k *m *o *q *s *u *w *y side1
mv x* side2
cat side1/* > CPM_IMD_side1.img
cat side2/* > CPM_IMD_side2.img
rm -rf side1 side2
```

The DFS directory is stored in the first sector (Sector 0, Track 0, Side 0) and second sector (Sector 1, Track 0, Side 0). They look like:

```console
$ xxd -c 8 CPM_IMD.dmg | head -n 64
00000000: 4163 6f72 6e20 4350  Acorn CP
00000008: 4350 4d44 4953 43a4  CPMDISC.
00000010: c3f7 ecc3 d3ec c3a2  ........
00000018: eac3 aeea c3ba eac3  ........
00000020: c6ea c3de eac3 eaea  ........
00000028: c37e edc3 92ed c38a  .~......
00000030: edc3 a6ed c379 edc3  .....y..
00000038: abed c3c6 edc3 d2ea  ........
00000040: c38f edc9 4772 6565  ....Gree
00000048: 7469 6e67 7320 6672  tings fr
00000050: 6f6d 2043 6c65 616e  om Clean
00000058: 2045 6e64 202d 2049   End - I
00000060: 616e 204d 6172 6b20  an Mark
00000068: 4e65 696c 2053 696d  Neil Sim
00000070: 6f6e 2044 6972 7479  on Dirty
00000078: 2045 6e64 202d 2044   End - D
00000080: 6176 6520 4961 6e20  ave Ian
00000088: 4a6f 686e 2054 6f62  John Tob
00000090: 7942 6f73 7320 4d61  yBoss Ma
00000098: 6e20 2d20 486f 7761  n - Howa
000000a0: 7264 203e 8332 0300  rd >.2..
000000a8: 2e02 3e02 cdf4 ffc3  ..>.....
000000b0: bdeb cd02 eb81 8aeb  ........
000000b8: 50eb f6ea 24eb cd02  P...$...
000000c0: eb01 98eb 54eb eaea  ....T...
000000c8: e0ff cd02 eb01 9ceb  ........
000000d0: 6ceb c6ea 4ceb cd02  l...L...
000000d8: eb03 9ceb 6ceb a6eb  ....l...
000000e0: a9eb cd02 eb03 a1eb  ........
000000e8: 93eb c4eb c4eb cd02  ........
000000f0: eb05 9ceb 6ceb 23eb  ....l.#.
000000f8: 23eb cd02 eb07 98eb  #.......
00000100: 2f4d 2020 0008 0320  /M  ...
00000108: 00d4 0000 001e 3002  ......0.
00000110: 54eb 21eb 21eb cd02  T.!.!...
00000118: eb07 8aeb 50eb 95eb  ....P...
00000120: 95eb e17e 23cb 7f47  ...~#..G
00000128: cbb8 2004 af32 67f1  .. ..2g.
00000130: 3a03 0007 10fd e606  :.......
00000138: 1600 5f19 5e23 56eb  .._.^#V.
00000140: e93e 1ac9 2167 f1af  .>..!g..
00000148: b628 0335 afc9 2100  .(.5..!.
00000150: ff3e b1cd f4ff cd8c  .>......
00000158: ebc0 3ed8 2100 ffcd  ..>.!...
00000160: f4ff 7da7 204f 2167  ..}. O!g
00000168: f136 0cc9 79c3 9eff  .6..y...
00000170: 2e00 18e2 2e02 3e02  ......>.
00000178: cdf4 ffcd e0ff f57d  .......}
00000180: a720 022e 023e 02cd  . ...>..
00000188: f4ff f1c9 21f4 003e  ....!..>
00000190: 03cd f4ff e5af cdc8  ........
00000198: fff5 79cd eeff f1cd  ..y.....
000001a0: c8ff e126 003e 03c3  ...&.>..
000001a8: f4ff 2e01 3e98 cdf4  ....>...
000001b0: ff30 02af c9af 3dc9  .0....=.
000001b8: 2e01 18ba 21f7 0018  ....!...
000001c0: ce21 fdff 1821 cdd2  .!...!..
000001c8: eb79 a721 1a00 20bf  .y.!.. .
000001d0: 3e06 2eff cdf4 ff21  >......!
000001d8: 1a00 cd6f eb3e 062e  ...o.>..
000001e0: 00c3 f4ff 21fc ff3e  ....!..>
000001e8: 80cd f4ff 7da7 c8af  ....}...
000001f0: 3dc9 3a03 00e6 c3fe  =.:.....
000001f8: 82c8 cd80 ecc0 3e86  ......>.
```

I'm reading <http://www.cowsarenotpurple.co.uk/bbccomputer/native/adfs.html> to try and parse this information.

The volume properties are in the first 8 bytes of each sector.

```text
4163 6f72 6e20 4350 2f4d 2020 0008 0320  Acorn CP/M  ...
\---------Volume Name-------/ ^^^^ |^^^-- Num sectors on disk (800)
                              | |  +-- Boot Option (0)
                              | +-- Directory length in bytes (8 bytes = 1 file)
                              +-- Disk Cycle Number (0)
```

Looking at this, the DFS volume name is in the first 12 bytes (`Acorn CP/M  `). We also see we have 800 sectors, and exactly one file. Looking at the first sector we can see the file is called `CPMDISC`, and the authors of the disk have left us 'greetz' in the remaining unused entries.

> Greetings from Clean End - Ian Mark Neil Simon Dirty End - Dave Ian John Toby Boss Man - Howard

Hi! I have no idea who or what the Clean End and the Dirty End are. Answers to the usual address if you know.

Anyway, combining eight bytes from the first sector and eight bytes from the second, we see that single valid file.

```text
4350 4d44 4953 43a4 00d4 0000 001e 3002 CPMDISC.......0.
\----File Name--/^^ ^^^^ ^^^^ ^^^^ ^^^^
                 |  |    |    |    | +-- Start sector (0x002)
                 |  |    |    |    +-- Extra bits for Length/Execute/Load/Start
                 |  |    |    +-- File Length (0x031E00)
                 |  |    +-- Execute address (0x00000)
                 |  +-- Load address 0x00D400
                 +-- Directory `$` (0x24) plus 0x80 for Locked
```

Alright, that's a bit weird. What does the BBC Micro make of this?

{{ image(img="/blog/blog-2026-04-02/dfs_listing.png") }}

Cool. We got that right. The file size of 0x31E00 is 798 sectors, which covers the entirety of the remainder of the disk. This stops anyone saving files onto this 'DFS' disk and trashing the CP/M portion.

What's in this file? Well, I don't know enough about the Z80 Boot ROM to know where this file is loaded or what the entry point is. But does it look like Z80 machine code?

```console
$ dd if=CPM_IMD_side1.dmg bs=256 skip=2 count=8 of=CPMBOOT
$ z80dasm -g 0xD400 CPMBOOT | head -n 20
Warning: Code might not be 8080 compatible!
; z80dasm 1.2.0
; command line: z80dasm -g 0xD400 CPMBOOT

	org 0d400h

	call 0fff4h
	ld (0f168h),hl
	ld a,087h
	call 0fff4h
	ld a,h
	ld hl,01f36h
	and a
	jr z,$+13
	cp 003h
	jr z,$+7
	ld hl,00000h
	jr $+4
	ld h,018h
	push hl
	call 0ec6ch
$ strings CPMBOOT
Printer off line
SPACE starts Printer Sink
Not a CP/M system disc in A
Acorn CP/M 2.2 - Bios 1.20
o))))
(1=2
)))))))
>S(M:
P8
  O:
Bdos Err On
: R/O (Disc is Write Protected)
Running BOOT.COM
Submitting BOOT.SUB
BOOT.SUB present but no SUBMIT.COM
BOOT
SUBMIT BOOT
SUBMIT  COM
BOOT    SUB
BOOT    COM
                COPYRIGHT (C) 1979, DIGITAL RESEARCH
```

Well, that's plausible I guess. 0xFFF4 is at the top of Z80 address space, where the Z80 Boot ROM relocates itself on startup. According to the BBC BASIC for Z80 User Manual, [`&FFF4` is the syscall for `OSBYTE`](https://www.benryves.com/bin/bbcbasic/manual/OS_Call_OSBYTE.htm). I don't know if that's right, but it seems plausible. Shortly after we do a `OSBYTE &87`, which might be *Read character at text cursor position*. Maybe the entry point is somewhere in the middle of the file rather than the start of the file.

But anyway. We can see some Z80 code that lives in the `CPMBOOT` file and we assume the Z80 BIOS knows how to load this code. But if this disk contains one huge 196,638 byte file, where's the CP/M Filesystem? Well [the Z80 Second Processor Application Notes](http://www.primrosebank.net/computers/bbc/documents/AN007.pdf) tells us that:

> The CP/M directory starts at track 3 sector 0 and uses 4K bytes to allow up to 128 directory entries/disc. This leaves 388K bytes/disc available for user programs and data.

So far so straight-forward. But, unfortunately, it gets worse. CP/M has a native record size of 128 bytes, so each physical sector on the disk contains two CP/M records. But when it comes to reading the disk, they choose to read two sectors at a time.

> Acorn CP/M uses deblocking to allow the physical disc sector size to be larger than the logical CP/M record size of 128 bytes. Although a 256 byte sector size is used the effective sector size is 512 bytes as all disc operations read or write 2 sectors at a time using an appropriate sector skew.

| Logical CP/M record (128 bytes) | Logical disc sector (512 bytes)  | Physical disc sector (256 bytes) |
|---------------------------------|----------------------------------|----------------------------------|
| 0                               | 0                                | 0                                |
| 1                               | 0                                | 0                                |
| 2                               | 0                                | 1                                |
| 3                               | 0                                | 1                                |
| 4                               | 1                                | 4                                |
| 5                               | 1                                | 4                                |
| 6                               | 1                                | 5                                |
| 7                               | 1                                | 5                                |
| 8                               | 2                                | 2                                |

So if CP/M (running on the Z80) wants a 128-byte record it asks Acorn MOS (running on the 6502) to load a 512-byte logical disk sector, which MOS does by reading two 256-byte physical disk sectors from the floppy disk, and the 256-byte physical disk sectors that comprise 512-byte logical disk sector 1 are not in fact physical disk sectors 2 and 3 like you might expect, but in fact sectors 4 and 5. This presumably allows for the fact the disk continues rotating after the data has been loaded (at about 2 ms per sector), and in theory physical sector 4 is just about to go under the read head as CP/M asks for the next physical sector, having already passed over physical sectors 2 and 3 whilst the CPU was busy doing other things.

Whatever - I'm just glad I'm not trying to write an emulator.

Let's take a quick look at that CP/M directory and see if that is where we think it is:

```console
$ dd if=CPM_IMD_side1.ssd bs=256 skip=30 count=1 2>/dev/null | xxd -c 8
00000000: 0055 4e4c 4953 5420  .UNLIST
00000008: 2043 4f4d 0000 000a   COM....
00000010: 0200 0000 0000 0000  ........
00000018: 0000 0000 0000 0000  ........
00000020: 0043 4f4e 5645 5254  .CONVERT
00000028: 2043 4f4d 0000 0013   COM....
00000030: 0304 0000 0000 0000  ........
00000038: 0000 0000 0000 0000  ........
00000040: 0043 5243 2020 2020  .CRC
00000048: 2043 4f4d 0000 0016   COM....
00000050: 0506 0000 0000 0000  ........
00000058: 0000 0000 0000 0000  ........
00000060: 0043 5243 4b4c 4953  .CRCKLIS
00000068: 5443 5243 0000 0009  TCRC....
00000070: 0700 0000 0000 0000  ........
00000078: 0000 0000 0000 0000  ........
00000080: 0043 4f50 5920 2020  .COPY
00000088: 2043 4f4d 0000 000e   COM....
00000090: 0800 0000 0000 0000  ........
00000098: 0000 0000 0000 0000  ........
000000a0: 0046 4f52 4d41 5420  .FORMAT
000000a8: 2043 4f4d 0000 000c   COM....
000000b0: 0900 0000 0000 0000  ........
000000b8: 0000 0000 0000 0000  ........
000000c0: 0056 4552 4946 5920  .VERIFY
000000c8: 2043 4f4d 0000 0007   COM....
000000d0: 0a00 0000 0000 0000  ........
000000d8: 0000 0000 0000 0000  ........
000000e0: 0054 4552 4d20 2020  .TERM
000000e8: 2043 4f4d 0000 0002   COM....
000000f0: 0b00 0000 0000 0000  ........
000000f8: 0000 0000 0000 0000  ........
```

I mean, I don't know much about the CP/M directory format, but that looks like a directory listing with 32 bytes per entry. Which weirdly is also the size of an MS-DOS FAT directory entry (it's not weird, it's almost certainly deliberate, what with the first MS-DOS being a clone of CP/M but for the 8086).

Anyway, that's a CP/M Boot disk for the BBC Master that is also an Acorn DFS disk, so you don't accidentally break your CP/M disk when you are in BBC BASIC.

## DOS Plus Disks on a BBC Master

Enough with the Z80 and CP/M. The Pi Tube Direct can also pretend to be the 80186 Second Processor found in the BBS Master 512. This can boot into Digital Research's updated, somewhat MS-DOS compatible, version of CP/M - Digital Research DOS Plus.

What format is my [DOS Plus disk](./DOSPLUS.IMD) in?

* 256 bytes per sector
* 16 sectors per track
* 80 tracks per side
* 2 sides

Well that looks like ADFS L format.

{{ image(img="/blog/blog-2026-04-02/adfs_listing.png") }}

OK, similar idea. We have a file called `dosboot`, with load and execution addresses of 0x0400_0000, a length of 2303 bytes and a disc address of 7.

Does that look like an x86 program?

```console
$ dd if=DOSPLUS_IMD.dmg bs=256 count=9 skip=7 > DOSBOOT
9+0 records in
9+0 records out
2304 bytes transferred in 0.000184 secs (12521739 bytes/sec)
$ i686-elf-objdump -b binary -m i8086 -D DOSBOOT  | head -n 30

DOSBOOT:     file format binary

Disassembly of section .data:

00000000 <.data>:
   0:	8c c8                	mov    %cs,%ax
   2:	8e d8                	mov    %ax,%ds
   4:	8e d0                	mov    %ax,%ss
   6:	bc 5a 09             	mov    $0x95a,%sp
   9:	b8 00 78             	mov    $0x7800,%ax
   c:	8e c0                	mov    %ax,%es
   e:	be 00 00             	mov    $0x0,%si
  11:	bf 00 00             	mov    $0x0,%di
  14:	b9 00 40             	mov    $0x4000,%cx
  17:	f3 a5                	rep movsw %ds:(%si),%es:(%di)
  19:	2e ff 2e 1e 00       	ljmp   *%cs:0x1e
  1e:	22 00                	and    (%bx,%si),%al
  20:	00 78 8c             	add    %bh,-0x74(%bx,%si)
  23:	c8 8e d8 8e          	enter  $0xd88e,$0x8e
  27:	c0 8e d0 bc 5a       	rorb   $0x5a,-0x4330(%bp)
  2c:	09 e8                	or     %bp,%ax
  2e:	64 01 bb f9 04       	add    %di,%fs:0x4f9(%bp,%di)
  33:	e8 c4 01             	call   0x1fa
  36:	bb 08 05             	mov    $0x508,%bx
  39:	e8 be 01             	call   0x1fa
  3c:	bf 42 05             	mov    $0x542,%di
  3f:	e8 27 01             	call   0x169
  42:	85 c0                	test   %ax,%ax
```

I don't know much about 8086 assembly code, but that seems plausible. The [BBC Master 512 Technical Guide](https://acorn.huininga.nl/pub/docs/manuals/Acorn/80186%20Second%20Processor/Master%20512%20Technical%20Guide.pdf) says:

> As can be seen by a * INFO DOSBOOT in native mode, the file has a load address of &04000000. Since the load address of DOSBOOT clearly locates it in the co-processor, the file is read and sent across the Tube via the Tube host code located in pages four to six.

OK, cool. But where does ADFS keep its directory listing?

```console
$ hexdump -C DOSPLUS_IMD.dmg | grep -i DOSBOOT
00082ea0  20 3a 34 2e 44 4f 53 42  4f 4f 54 20 30 34 30 30  | :4.DOSBOOT 0400|
```

Well that isn't anywhere near the start of the disk. Let's read <http://www.cowsarenotpurple.co.uk/bbccomputer/native/adfs.html> again...

> The disk is divided into three areas. All are made of whole numbers of sectors, and they occur in the following order:
>  	
>
> 1. The Free Space Map – 2 sectors (Sectors 0 and 1)
> 2. Root Directory – 5 sectors (Sectors 2 to 6)
> 3. Data area: Files and sub-directories.

Right, so the directory should start in Sector 2.

```console
dd if=DOSPLUS_IMD.dmg bs=256 skip=2 count=5 | hexdump -C
5+0 records in
5+0 records out
1280 bytes transferred in 0.000020 secs (64000000 bytes/sec)
00000000  55 48 75 67 6f e4 ef 73  62 6f 6f 74 0d 00 00 00  |UHugo..sboot....|
00000010  00 00 04 00 00 00 04 ff  08 00 00 07 00 00 54 00  |..............T.|
00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000470  00 00 00 00 00 00 00 00  00 00 00 00 00 00 24 00  |..............$.|
00000480  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000490  00 00 00 00 00 00 00 00  24 00 00 00 00 00 00 00  |........$.......|
000004a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000004b0  00 00 24 00 00 00 00 00  00 00 00 00 00 00 00 00  |..$.............|
000004c0  00 00 00 00 00 00 00 00  00 00 00 00 24 00 00 00  |............$...|
000004d0  00 00 00 00 00 00 02 00  00 41 63 6f 72 6e 20 44  |.........Acorn D|
000004e0  4f 53 20 42 6f 6f 74 20  44 69 73 63 0d 00 00 00  |OS Boot Disc....|
000004f0  00 00 00 00 00 00 00 00  00 00 55 48 75 67 6f 00  |..........UHugo.|
00000500
```

Yeah, a block starting `Hugo` is an ADFS directory. Each directory entry is 26 bytes, starting at offset 5. ADFS stores filenames as 7-bit ASCII and hides the attribute information in the top bit of the first five bytes of the filename. Which is why it didn't turn up in a `grep` of the disk image :/

```text
                                 Load Addr    Exec Addr     Length       Start   Cy
                                |----------| |----------| |----------| |-------| ||
e4 ef 73 62  6f 6f 74 0d  00 00 00 00  00 04 00 00  00 04 ff 08  00 00 07 00  00 54
|-----------------------------|
64 6f 73 62  6f 6f 74 0d  00 00 = dosboot\r\0
80 80 00 00  00                 = Read, Write, ~Lock, ~Subdir, ~ExecuteOnly
```

The load and exec addresses of 0x04000000, and the file size of 0x08ff (2303 bytes) all match what we saw in `*CAT` earlier. Interestingly, it doesn't seem like there's a file protecting the FAT portion of the floppy disk - probably because ADFS uses a free space bitmap, and the bitmap shows that there isn't any free space.

But where is the FAT root directory, once booted into DOS Plus? On an MS-DOS formatted 720K floppy disk, I'd expect it in sector 19 - but we have an ADFS free space bitmap where the Boot Sector should be, so I suspect DOS Plus must have been hard coded to have some reserved sectors. Let's have a look for a file we know it has - thankfully we won't fall over the same "hiding data in the top bits" problem we had earlier...

```console
$ hexdump -C DOSPLUS_IMD.dmg | grep "COMMAND COM" -A3 -B3
00002250  00 00 00 00 00 00 a0 89  7b 0e 03 00 80 05 00 00  |........{.......|
00002260  44 4f 53 50 4c 55 53 20  53 59 53 25 00 00 00 00  |DOSPLUS SYS%....|
00002270  00 00 00 00 00 00 60 6f  ef 0e 04 00 80 47 01 00  |......`o.....G..|
00002280  43 4f 4d 4d 41 4e 44 20  43 4f 4d 25 00 00 00 00  |COMMAND COM%....|
00002290  00 00 00 00 00 00 80 73  26 0e 2d 00 08 69 00 00  |.......s&.-..i..|
000022a0  41 4c 41 52 4d 20 20 20  43 4d 44 20 00 00 00 00  |ALARM   CMD ....|
000022b0  00 00 00 00 00 00 80 64  1c 0d 3b 00 00 2c 00 00  |.......d..;..,..|
```

Yeah, that looks like a FAT formatted directory listing. Where does it start? It doesn't take too much searching to find it.

```console
$ dd if=DOSPLUS_IMD.dmg bs=256 skip=34 count=2 | hexdump -C
00000000  4d 35 31 32 20 44 69 73  6b 20 31 08 00 00 00 00  |M512 Disk 1.....|
00000010  00 00 00 00 00 00 60 75  61 66 00 00 00 00 00 00  |......`uaf......|
00000020  36 35 30 32 20 20 20 20  53 59 53 25 00 00 00 00  |6502    SYS%....|
00000030  00 00 00 00 00 00 a0 89  7b 0e 02 00 80 04 00 00  |........{.......|
00000040  4c 4f 47 4f 20 20 20 20  53 59 53 25 00 00 00 00  |LOGO    SYS%....|
00000050  00 00 00 00 00 00 a0 89  7b 0e 03 00 80 05 00 00  |........{.......|
00000060  44 4f 53 50 4c 55 53 20  53 59 53 25 00 00 00 00  |DOSPLUS SYS%....|
00000070  00 00 00 00 00 00 60 6f  ef 0e 04 00 80 47 01 00  |......`o.....G..|
00000080  43 4f 4d 4d 41 4e 44 20  43 4f 4d 25 00 00 00 00  |COMMAND COM%....|
00000090  00 00 00 00 00 00 80 73  26 0e 2d 00 08 69 00 00  |.......s&.-..i..|
000000a0  41 4c 41 52 4d 20 20 20  43 4d 44 20 00 00 00 00  |ALARM   CMD ....|
000000b0  00 00 00 00 00 00 80 64  1c 0d 3b 00 00 2c 00 00  |.......d..;..,..|
000000c0  41 4c 41 52 4d 20 20 20  44 41 54 20 00 00 00 00  |ALARM   DAT ....|
000000d0  00 00 00 00 00 00 c0 53  61 10 41 00 80 00 00 00  |.......Sa.A.....|
000000e0  42 41 43 4b 47 20 20 20  43 4d 44 20 00 00 00 00  |BACKG   CMD ....|
000000f0  00 00 00 00 00 00 80 73  26 0e 42 00 80 39 00 00  |.......s&.B..9..|
00000100  42 41 43 4b 55 50 20 20  43 4d 44 20 00 00 00 00  |BACKUP  CMD ....|
00000110  00 00 00 00 00 00 80 73  26 0e 4a 00 80 30 00 00  |.......s&.J..0..|
00000120  42 59 45 20 20 20 20 20  43 4d 44 20 00 00 00 00  |BYE     CMD ....|
00000130  00 00 00 00 00 00 40 63  1c 0d 51 00 00 0a 00 00  |......@c..Q.....|
00000140  43 48 4b 44 53 4b 20 20  43 4d 44 20 00 00 00 00  |CHKDSK  CMD ....|
00000150  00 00 00 00 00 00 80 73  26 0e 53 00 00 2e 00 00  |.......s&.S.....|
00000160  43 4f 4c 4f 55 52 20 20  45 58 45 20 00 00 00 00  |COLOUR  EXE ....|
00000170  00 00 00 00 00 00 80 64  1c 0d 59 00 00 0e 00 00  |.......d..Y.....|
00000180  44 45 56 49 43 45 20 20  43 4d 44 20 00 00 00 00  |DEVICE  CMD ....|
00000190  00 00 00 00 00 00 80 73  26 0e 5b 00 80 2c 00 00  |.......s&.[..,..|
000001a0  44 49 53 4b 20 20 20 20  43 4d 44 20 00 00 00 00  |DISK    CMD ....|
000001b0  00 00 00 00 00 00 a0 8a  fb 0e 61 00 80 41 00 00  |..........a..A..|
000001c0  45 44 20 20 20 20 20 20  43 4d 44 20 00 00 00 00  |ED      CMD ....|
000001d0  00 00 00 00 00 00 80 73  26 0e 6a 00 00 26 00 00  |.......s&.j..&..|
000001e0  45 44 42 49 4e 20 20 20  45 58 45 20 00 00 00 00  |EDBIN   EXE ....|
000001f0  00 00 00 00 00 00 00 81  30 0e 6f 00 00 1c 00 00  |........0.o.....|
```

The `M512 Disk 1` entry is almost certainly the *Volume Label* - it's just a directory entry with some special attributes. So if this is sector 

But if the root directory is there, where is the File Allocation Table? We need 12 bits (1.5 bytes) per cluster to record which parts of the disk are in use. I'll be honest, at this point I don't know. If you know, drop me an email.

## Outro

What have we learned today? Futzting around with `dd`, `hexdump` and `xxd` is fun? Old computers were weird and had floppy disks that contained two valid filesystms at the same time? I wonder if there are any modern computers that pull off the same kind of trick today.
