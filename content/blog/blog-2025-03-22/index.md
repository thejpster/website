+++
title = "Playing with HP PA-RISC"
date = "2025-03-22"
+++

## Backstory

Having enjoyed some time with my [Silicon Graphics POWER Indigo 2](@/blog/blog-2024-11-22/index.md), I started to wonder what the other 1990's UNIX RISC machines might be like in comparison. The ones I had in mind were:

* Silicon Graphics MIPS running IRIX - got that one
* Digital Alpha running Tru64 UNIX (or Windows NT...)
* Sun SPARC running Solaris
* HP PA-RISC running HP-UX
* IBM PowerPC running AIX

I guess you could add Acorn ARM running RISC iX or Linux to that list - there was a Linux port for the RiscPC. Maybe I'll try it someday.

Shortly after acquiring the Indigo 2, I managed to obtain a Sun Ultra 80, with three (yes, the fourth is broken) UltraSPARC-II CPUs running at 450 MHz. I've been having a good time installing Solaris 7 and trying out a few things. Maybe more on that another day.

Then, the other day, I was at the Raspberry Jam in Cambridge, and I somehow ended up coming home with a Digital AlphaStation 500. Unfortunately, it's very dead. Maybe more on that another day too - debugging the SROM and the initial boot-up process has been quite interesting.

I've wanted an IBM RS/6000 for ages, but they go for a lot of money on eBay. Well out of my price range.

And that leaves PA-RISC. An odd-ball that I knew nothing about. Well, I saw a machine and it was reasonably priced, and the vendor was lovely. In fact, I ended up with two machines being hand-delivered to my house by the vendor, and I didn't have to part with much money. Well, I suppose these things are relative, and given I don't actually have a use for two PA-RISC machines, perhaps positively outlandish. But here we are.

## The HP 9000 Series

First, some history about the HP 9000 series and the PA-RISC architecture.

I'll just summarise a few things here, to put the two machines in context and get some jargon defined. You can read lots more detail at the excellent <https://www.openpa.net/>.

HP introduced the [HP 9000 brand in 1984](https://en.wikipedia.org/wiki/HP_9000) to cover a range of existing computer products. The early HP 9000 machines used either Motorola 68000 CPUs or HP's FOCUS architecture. All ran HP's version of UNIX (known as HP-UX) and some of the early machines were large enough to be considered 'minicomputers' rather than 'personal computers' or 'workstations'.

In the mid 1980's, and continuing on through to the early 2010's, HP used processors based around their own [Hewlett Packard Precision Architecture](https://en.wikipedia.org/wiki/PA-RISC) - also know as HPPA, or PA-RISC.

The first versions of the PA-RISC architecture (PA-RISC 1.x) were 32-bit, with processors implementating this architecture ranging from TS-1 of 1986 and finishing with the PA-7300LC of 1996. The [TS-1 processor](https://www.openpa.net/pa-risc_processor_pa-early.html) came on [six 8.4" x 11.3" boards](https://computermuseum.informatik.uni-stuttgart.de/dev_en/hp9000_840/hp9000_840.html) covered in TTL logic chips. The [PA-7300LC](https://en.wikipedia.org/wiki/PA-7100LC) was a silicon die with 9.2 million transistors in a 464-pin ceramic PGA package.

PA-RISC 2.0 came out in 1996, expanding the architecture to have 64-bit addressing and 64-bit registers. Processors implementing this architecture include the PA-8000 and PA-8500. PA-RISC 2.0 processors seem to run 32-bit PA-RISC 1.x code just fine, as you'd hope (yes, I'm slagging off Itanium here).

Not all PA-RISC machines came from HP. There was a industry group to promote PA-RISC which included HP alongside companies like Mitsubish and NEC. There were [some PA-RISC laptops](https://www.openpa.net/systems/rdi_precisionbook.html). Had Commodore not gone bankrupt, we might even have had [a PA-RISC based Amiga](https://en.wikipedia.org/wiki/Amiga_Hombre_chipset).

The naming of the HP 9000 series machines is, as you might expect for product-line spanning 30 years, somewhat all over the place. But looking at just the PA-RISC machines, you can boil it down to:

* Early stuff - including the HP 9000 800-series minicomputers
* HP 9000 700-series workstations
* HP 9000 Visualize workstations (B-Class, C-Class and J-Class)
* HP 9000 Servers (A-class, D-class, K-class, L-class, N-class and R-class)

I have two HP 9000 Visualize workstations - a B-Class and a C-class.

## My HP Visualize B132L+ Workstation

This is my [HP 9000 Visualize B-Class workstation](https://www.openpa.net/systems/hp-visualize_b132l_b160l_b180l.html) from around 1996. It's a mid-range desktop workstation with 2D graphics.

{{ image(img="blog/blog-2025-03-22/b132l+ outside.jpg") }}

I've edited out the stickers in the picture, and I'm in two minds as to whether to keep the on the machine to reflect its history, or if I should remove them and clean the machine up to its 'factory' appearance.

The tech specs are:

* 32-bit PA-RISC PA-7300LC processor @ 132 MHz
* 128 KiB L1 Cache
* 1 MiB L2 Cache
* 128 MiB in 72-pin ECC SIMMs 
* Ultra-Wide SCSI bus (external 68-pin connector terminator required)
* SCSI-2 bus (external 50-pin connector terminator required)
* 10base-T Ethernet
* 16-bit audio
* GSC and PCI expansion
  * Apparently they also have an EISA slot, but mine is missing
* Visualize-EG graphics integrated into the mainboard
  * Runs at 1280x1024 at 75 Hz
  * Uses a very un-common [VESA EVC video connector](https://en.wikipedia.org/wiki/VESA_Enhanced_Video_Connector)
* PS/2 ports for keyboard and mouse

The L+ in the model name is important as it indicates that it has low-voltage differential (LVD) SCSI, whilst the B132L has high-voltage differential SCSI. You almost certainly don't want the latter - it will damage the much more common single-ended and LVD SCSI drives you find on eBay if you connect them up.

My particular machine dates from about 1997 and is from Vodafone where it had been a DNS and licence server in production for around 25 years - it was retired only recently. It came with a SCSI DDS2 tape drive, but no hard disk. I have tested the machine with a disk from another machine, but I'm currently looking for a 64-pin Ultra-Wide SCSI to permanently fit to it.

To open the machine, place it on its front, remove four thumb-screws, and lift by the handle.

{{ image(img="blog/blog-2025-03-22/b132l+ lift.jpg") }}

Here's the inside, having removed the drive-bay cover (by pressing two latches and lifting it away). We can see the hard drive bay (I was given the drive sled, it's not pictured) and the CD-ROM bay (I was also given the drive rails, not pictured). In the middle, the six 72-pin SIMM slots are under the SCSI cable and the black plastic clip that ensures the SIMMs don't fall out. I believe the two memory sticks near the CPU heatsink are the L2 cache.

{{ image(img="blog/blog-2025-03-22/b132l+ inside.jpg") }}

Here are the two expansion slots which, like the Silicon Graphics Indigo 2, have two kinds of connectors for each card. You can see the pads for an EISA connector for the second slot, but it's not fitted on this example.

{{ image(img="blog/blog-2025-03-22/b132l+ slots.jpg") }}

## My HP Visualize C3000 Workstation

This is my [HP 9000 Visualize C-Class workstation](https://www.openpa.net/systems/hp-visualize_b1000_c3000_c3600.html) from around 1999. It is now one of my all-time favourite case designs - with the logo, and the splash of colour, and the 2-line LCD that tells you how it's getting on booting up. Fabulous.

{{ image(img="blog/blog-2025-03-22/c3000 front.jpg") }}

It's a high-end desktop workstation with 3D graphics. If you read [osnews.com](https://www.osnews.com), it's pretty much the model before the end-of-the-line Visualize C8000 [Thom intends to try and actually use for a week](https://www.osnews.com/story/141394/t2-linux-takes-weird-architectures-seriously-including-my-beloved-pa-risc/).

I wasn't meaning to buy two PA-RISC machines, but the vendor made me an offer I couldn't refuse - and I mean, just look at it. It nails the turn-of-the-millenium 'high end workstation' vibe. This machine was apparently running as a server for Virgin Media up until very recently. I hear that Transport for London also has a lot of PA-RISC gear.

The tech specs are:

* 64-bit PA-RISC PA-8500 processor @ 400 MHz
* 1 MiB L1 Cache
* 2.5 GiB ECC SDRAM 
* Ultra2-Wide LVD SCSI bus
  * Two easy-access 80-pin SCA drive bays
  * Note that single-ended (non-LVD) drives won't work here!
* Ultra-SCSI Single-Ended bus with external 50-pin connector
* IDE CD-ROM
* 100base-TX Ethernet
* 16-bit audio
* 64-bit/66 MHz PCI expansion
* Visualize FXPro5 3D graphics card
  * Runs at 1280x1024 at 75 Hz
  * Thanksfully has regular DVI and VGA outputs
  * The machine didn't have graphics during its production life - the vendor added it for me
* USB ports for keyboard and mouse

If you pop the cover off, you can see the drive sleds for two 80-pin SCA hard drives.

{{ image(img="blog/blog-2025-03-22/c3000 bays.jpg") }}

Popping off the cover is easy - remove two thumb screws and it slides off. This is so much nicer than my generic beige Pentium 3, which rips my knuckles to shreds everytime I go inside it. We can see the card slots at the top, with CD-ROM and Floppy bays below, and a big-ass power supply covering most of the rest of the system.

{{ image(img="blog/blog-2025-03-22/c3000 wide.jpg") }}

Here are the expansion cards. Just the one fitted - a Visualize FX5Pro 3D graphics card.

{{ image(img="blog/blog-2025-03-22/c3000 cards inside.jpg") }}

Here's that Visualize FX5Pro graphics card. Looks much meatier than a PC card of the same vintage, like me Diamond V770 Ultra.

{{ image(img="blog/blog-2025-03-22/fx5pro front.jpg") }}

{{ image(img="blog/blog-2025-03-22/fx5pro back.jpg") }}

Here's what the PSU says. That seems easy enough.

{{ image(img="blog/blog-2025-03-22/c3000 psu.jpg") }}

Here it is with the PSU in place.

{{ image(img="blog/blog-2025-03-22/c3000 psu down.jpg") }}

Here it is with the PSU lifed up. This is genius.

{{ image(img="blog/blog-2025-03-22/c3000 psu up.jpg") }}

I'll leave you with a shot of the RAM. It appears there are five sticks - I have no idea why, or if it prefers pairs of DIMMs. The CPU cooler gives me [Golden Orb](https://www.anandtech.com/show/583/7) vibes, which being of a certain age I appreciate greatly.

{{ image(img="blog/blog-2025-03-22/c3000 ram.jpg") }}

## Installing HP-UX
 
Of course, an HP workstation is of no use without an OS and whilst you could install Linux, or OpenBSD, or NetBSD, you should of course install HP-UX.

HP-UX is HP's proprietary UNIX. There have been many versions over the years, but I chose the 32-bit HP-UX 10.20 for the B132L+, and the 64-bit HP-UX 11.00 for the C3000.

Note that if you find *HP-UX 11i* or *HP-UX 11i v1* that's HP's renaming of HP-UX 11.11. *HP-UX 11i v2* is HP-UX 11.23 and *HP-UX 11i v3* is HP-UX 11.31. There's [a list on Wikipedia](https://en.wikipedia.org/wiki/HP-UX#Versions) for reference.

The versions of HP-UX I am interested in came on multiple CD-ROMs, and HP appeared to produce a new set of CD-ROMs every three months. The discs were:

* The Core OS - you can boot from this, and install the basic OS with CDE desktop
* Additional Core Enhancements (or ACE) - this is a revised Core OS install disk with extra patches included
* Applications (usually four or five CDs) - extra things you can install, like Java, or the HP ANSI C compiler. Annoyingly many of the applications cost extra and so are shipped encrypted.
* Support Plus - a series of patches to update the Applications and the Core OS
* LaserROM - HP-UX documentation on CD

Sometimes the new set would just have the same Core OS disk as the previous set, and just a new version of Support Plus. HP [still have a page on-line](https://www.hpe.com/global/softwarereleases/releases-media2/HPEredesign/pages/library.html?category=Media%20content) which lists the contents of each media set. For example, see the PDF for the [March 2001 media set](https://www.hpe.com/global/softwarereleases/releases-media2/HPEredesign/latest/aps/app0301/media.pdf).

There are guides to installing HP-UX available as PDF from HP that you can easily find online, but here are some important notes.

### Installing

* You can boot from the Core OS disk, or the Core OS with Additional Enhancements disk (also known as the Additional Core Enhancements disk, or ACE)
* Interrupt the boot process, run `SEA` to search for devices, and then something like `boot scsi.1.0.0` (or whatever appears in your search results).
* Archive.org have some lovely colour scans of original HP-UX CD-ROMs, if you want to see what a real disk looked like.
* HP-UX 11.00 sets up Logical Volume Manager, but the volumes are quite small, so you'll want to make `/var` and `/opt` and `/home` bigger by doing an 'Advanced' installation.
* If you use a later *Additional Core Enhancements* (ACE) HP-UX 11.00 install disk, when it asks you what kind of install you want you can select "Technical Computing Operating Environment" and it will (apparently) install the *Graphics and Technical Computing Software* bundle automatically and give you OpenGL support out of the box.
* If you have a Visualize FX5Pro, like me, you'll need to install a Hardware Enablement (HWE) update otherwise the X11 desktop gets big borders warning you you're on a fallback video driver with bad performance. Maybe there's an ACE version that has that already on it.

### Straight After Installation

* X11 won't start if you don't have a mouse plugged in.
* There is no nsswitch.conf file by default - without it, it falls back to some defaults.
* The defaults cause it to check hostnames against DNS first and if it fails to resolve, if gives up without looking at /etc/hosts.
* If your hostname doesn't resolve, you can't get into the CDE desktop.
* You can either `cp /etc/nsswitch.hp_defaults /etc/nsswitch.conf` and edit it to put `files` before `dns`, or fix your DNS so it knows your machine's hostname.
* You'll have to use `vi` to edit the file. Sorry.
* There is only a `root` user. Make yourself a regular user by running the System Admin tool (`sam`).
* The `root` user home directory is `/`, which I don't like. I guess you could try and switch that to `/root` by modifying the account in `sam`.

### Using HP-UX

* You'll need to mount the CD-ROM manually, with something like `mount /dev/dsk/c2t0d0 /cdrom`.
* You'll need to `mkdir /cdrom` first, of course.
* HP-UX only includes `sh`, so there's no up-arrow to re-visit previous commands, and no tab-completion. You'll just have to type your shell commands accurately.
* The HP-UX desktop (CDE) seems to come with basically no applications - just a file browser, a text editor, a terminal and a calculator. Silicon Graphics' Magic Desktop it ain't.

### Patches and Updates and Applications

* You can install software from the HP-UX CD-ROMs by running `swinstall` as root and selecting the path of the mounted CD-ROM (e.g. `/cdrom`).
* You'll want to log in to the desktop as root so you can use the GUI version of `swinstall`. Running it from a terminal where you used `su` will only give you the text-mode version.
* Unless it's the Support Plus disk, in which case you need to point it to one of the patch folders, like `/cdrom/QPK1100`.
* If you have a Software Depo file (`.sd` or `.depot`), you can run `swinstall` as root, and point it at the file (`/tmp/my_package.sd`) instead of the CD-ROM mount and it will install from it.
* The Support disk has three kinds of patches on it:
  * Quality Pack (`QPK1100`)
  * Hardware Enablement and Critical Bundle (`XSWHWCR1100`)
  * General Release (`XWSGR1100`)
* Patches all have names like `PHSS_17535`
* When a patch is installed the files it replaces are kept in `/var/adm/sw/save`. This folder can become very large. I guess the idea is you can try a patch and if it causes you issues you can drop it again, but if you commit to a patch, the save data is removed and you can no longer roll it back.
* You can run `cleanup -c 1` as root, which means "commit patches which have been superceded". 
* There's a C compiler (`cc`) installed by default, but it only supports K&R C and not ANSI C, so it's mostly useless for anything except kernel rebuilds (which some of the patches trigger automatically).
* The HP ANSI C compiler is a paid-add on, shipped as an encrypted application.
* If you want to install the encrypted applications, you'll need the codeword, and good luck finding one. The codeword is based on your Customer ID, and the specific ID of the CD you are installing from. So if you have a codeword for *HP-UX 11.00 2000-03 Applications 1 B3782-10464* but have the media for *HP-UX 11.00 2000-09 Applications 1 5011-7864*, you're out of luck. Back in the day you could call HP and they'll give you a new codeword. Assuming you have your original invoice.
* <https://mirrors.develooper.com/hpux/downloads.html> has GCC for HP-UX and other useful packages you can download.
* You can find applications like Netscape Communicator for HP-UX at <https://fsck.technology/software/HP/HP-UX%20Appplications/>.
* If you can only find MDF/MDS files online, these are raw CD-ROM images created with the program Alcohol120%. You can use that program to burn the images back to a CD-R, or you can use [Crystal AnyToISO](https://crystalidea.com/anytoiso) to convert them to ISO images that you can host on a BlueSCSI.
* If you want OpenGL support, and you didn't pick the right kind of install, you need a file called `B6268AA_B.11.11.20.12_HP-UX_B.11.11_32_64.depot`, which contains the *Graphics and Technical Computing Software* bundle.

If you have any ideas for interesting things I can do with a 1999 UNIX workstation, let me know! So far I've tried [my mandelbrot benchmark](https://github.com/thejpster/mandelbrot) and it did surprisingly well.

## FAQ

**Q.** Should I buy an HP 9000 series workstation

**A.** Yes, they're great, and *much* cheaper than Silicon Graphics workstations.

**Q.** Which one should I buy?

**A.** If you have the space, you should get a Visualize C3000-series because they're 64-bit and the case is snazzy. If you have more space, you could also get a J-series, which have two CPUs and are twice as wide.

**Q.** Where can I get an EVC to VGA adapter?

**A.** I don't know - I looked online but there aren't many. I suggest you make sure that if you do get an EVC connector on your machine, you ask the vendor to include an EVC to VGA dongle.

**Q.** Are you OK?

**A.** Well I'm broke. But I do own two working PA-RISC workstations though.
