+++
title = "Sun made ATX UltraSPARC boards for OEMs..."
date = "2026-01-06"
+++

## An offer you can't refuse

Another one of those things happened just before Christmas. Someone sent me a message saying "hey, check this out!", with a link to a message on the [debian-sparc mailing list](https://lists.debian.org/debian-sparc/2025/11/msg00047.html):

> While having a clear out I have come across some old SPARK hardware
> and accessories.  Is anyone interested in any of the following or knows
> communities / people who might be?

Oh my. Well, how could you say no?

## The pickup

I arranged a pickup and drove the 90 minutes or so down to London in early November. We'd discussed my recent obsessions with "SCSI" and "90's RISC UNIX" and gosh, were there some delights waiting for me.

I have:

* Two SPARCengine Ultra AXi boards, in 4U 19" rack-mount cases
* A Silicon Graphics O2 which was "not working"
* A spare Silicon Graphics O2 chassis and PSU
* A Silicon Graphics "IndyCam"
* A Sun Ultra 5
* A *lot* of SCSI cables and terminators
* A PCI SCSI card with the spicy High Voltage Differential signalling that destroys regular SCSI devices
* Some more S-Bus cards
* Half a dozen MAUs (the thing that turns an AUI port into a 10base2 or 10baseT physical interface)
* A brand-new (still in the plastic wrapper) Sun Type 6 keyboard and mouse
* Two Pioneer six-disc SCSI changers
* Three external SCSI enclosures
    * One 68-pin for four internal 3.5" hard drives
    * One 50-pin for four external 5.25" drives
    * One 68-pin that was styled to match a SPARCstation 5
* An IBM NetStation 1000 (a PowerPC based network client)

Well.

{{ image(img="/blog/blog-2026-01-06/IMG_1717.jpeg") }}

Safety first.

{{ image(img="/blog/blog-2026-01-06/IMG_1718.jpeg") }}

Just your usual weekly shop.

## I seriously cannot keep all these things

Luckily there was a Bring and Buy at the Centre for Computing History a few days later (it was not luck - my timing was deliberate), so I could move on some of these items at very low prices (after all, it only cost me five hours of time and a full charge of the battery in the car). I was able to move on one of the rack-mount cases, one of the SPARCengine boards, my BBC Master 128, a SPARCstation 20 and a Sun keyboard and mouse (I kept the brand-new ones). Oh, and the empty O2 chassis.

I nearly sold the Pioneer six-disc changers (as a pair), but I couldn't find a suitable SCSI card for them in my pile of SCSI cards, so the deal fell through. Never mind - they look 90's AF.

{{ image(img="/blog/blog-2026-01-06/IMG_1740.jpeg") }}

I also didn't sell any of these CD-ROM drives, so they might go back into the enclosure. That Yamaha 4x2x6x drive brings back memories as we sold quite a few at the computer shop back in the day. They were especially popular with gentlemen in the *ahem* Video CD distribution business, as I recall.

{{ image(img="/blog/blog-2026-01-06/IMG_1724.jpeg") }}

Unfortunately I did also buy an HP 9133 HP-IB Floppy Drive and MFM Hard Drive combo unit for my HP 9000 Model 340. I also picked up a Pentium 4 motherboard and a handful of PCI cards for £10 - for reasons which seemed plausible at the time but which now escape me. And I picked up a couple of EIDE hard drives of 20 to 40 GB capacity. A pretty good day out, and well worth checking out when the next one is, because there's good stuff to be had.

## The IBM NetStation

This machine deserves a post on its own. It's a PowerPC applicance with 64 MiB of RAM. It has a ROM which is enough to control a few settings, and to load an OS over the network using DHCP and TFTP. It it supposed to boot into a Network Terminal environment from IBM, which lets you remotely log into X servers, or AS/400 machines, or various other things. But also it has NetBSD support, and there are some Linux kernel patches floating around. I've had it booting into all three, but unfortunately it's a bit crashy. Also the CPU heatsink fell off because it was only glued on. As I said, maybe I'll do another post about it if I can get it working reliably. For now, the RAM is in my RiscPC.

{{ image(img="/blog/blog-2026-01-06/IMG_1728.jpeg") }}

{{ image(img="/blog/blog-2026-01-06/IMG_1730.jpeg") }}

## The Sun Ultra 5

The [Sun Ultra 5](https://en.wikipedia.org/wiki/Ultra_5/10) was a pizza-box desktop computer that followed on from the Sun Ultra 1, which in turn replaced the 32-bit SPARCstations that we've seen on this blog before. It has a 333 MHz UltraSPARC IIi processor module, and 64 MiB of buffered ECC EDO RAM. It also has a lot of standard PC components (in the name of cost-cutting), like a standard ATX power supply, an EIDE hard drive and [an LPX-style main board with PCI riser card](@/blog/blog-2025-07-19/index.md). Well this one didn't have a hard drive - they had all been removed by the vendor - but that's fine, I have spares. The NVRAM is obviously dead, but otherwise it seems to work fine.

Here it is on my new shelf with its new friends.

{{ image(img="/blog/blog-2026-01-06/IMG_1846.jpeg") }}

## The Silicon Graphics O2

The [Silicon Graphics O2](https://en.wikipedia.org/wiki/SGI_O2) was given to me as "dead". And sure enough, it did not power on when the power button was pressed. However there is a jumper inside which forces the unit to auto-start as soon as power is applied, and when I fitted that, it started working just fine. The hard drives inside it were non-functioning, so I fitted an 18 GB 10krpm Ultra160 SCSI drive (fancy), and I picked up an extra 128 MiB of its weird and special RAM off eBay to take it up to 192 MiB.

The specs are:

* MIPS R5000 @ 200 MHz
* 192 MiB RAM
* 18 GB SCSI HDD
* Unknown SCSI CD-ROM
* Integrated graphics with VGA output (but sync-on-green)
* Integrated 10baseT network
* PS/2 Keyboard and Mouse ports
* A/V module with Composite Video in and out

The O2 is the value version of the SGI Octane - as the Indy was the value version of an Indigo 2. The R5000 is a 64-bit processor but SGI only ever shipped a 32-bit version of IRIX for it. It's not quite as fast clock-for-clock as the R8000 in my [old Power Indigo 2](@/blog/blog-2024-11-22/index.md), but more than makes up for it by being clocked 166% faster. The graphcs card is integrated into the mainboard, sharing RAM with the CPU and actually using the CPU for much of the geometry calculation and other grunt work. The tradeoff is that with shared RAM (like an Apple Silicon system), you have an awful lot of memory to play with for textures and so on.

{{ image(img="/blog/blog-2026-01-06/IMG_1720.jpeg") }}

{{ image(img="/blog/blog-2026-01-06/IMG_1721.jpeg") }}

If you haven't seen an O2 before, they come apart really quite nicely. No screws, just rotating plastic cams which eject trays containing all the parts you need access to. And if you need to get the CD-ROM drive out, the shell comes off with just three big bolts at the top.

I installed [IRIX 6.5.22](https://archive.org/details/silicon-graphics-sgi-irix-6.5.22-and-6.5.30-full-cd-set-collection), which involved feeding about seventeen disk images in via my BlueSCSI, most of which had to be inserted twice (or three times). And thanks to the BlueSCSI not having an eject button, changing disks during the first install involves removing the SD card, putting into my Mac, renaming some files, taking it out, and putting it back in the BlueSCSI. This got boring quickly, so I now have a 32 GB XFS formatted image on the BlueSCSI which contains a copy of every single one of those install discs, and now I just have to type paths into the installer instead of virtually swapping disks. It's not great, but it's better.

Oh, and the power button mysteriously fixed itself. I think the start-up circuit just gets itself jammed up, and booting it up using the auto-boot jumper unclogs it. Let's hope it stays working - I cannot afford any replacement parts for it.

{{ image(img="/blog/blog-2026-01-06/IMG_1734.jpeg") }}

If you want more O2, Action Retro did a good video recently.

{{ youtube(id="1kBKg4Qncrg") }}

## The SPARCengine Ultra AXi.

Well now we get to the point of this article, the SPARCengine Ultra AXi.

We all know Sun sold workstations, like the Ultra 5, and servers, like [the SunFire V120](@/blog/blog-2025-08-20/index.md#sun-fire-v100-circa-2002), or the [Sun Enterprise](https://en.wikipedia.org/wiki/Sun_Enterprise) line.

But people making things like MRI scanners, or telecom systems, or fancy industrial equipment, well they need computers too. And they could buy a standard ATX form-factor PC mainboard, but what if the engineers in the office already have Sun machines? You wouldn't want to use a Sun machine to write PC firmware. No, what you need is a Sun workstation, but in the shape of a bare ATX board that you could fit into your industrial contraption. It would have a SPARC CPU and boot Solaris and just generally be a Sun workstation - but in the shape of a normal PC mainboard.

What you need, is a [Sun SPARCengine](https://www.ebay.co.uk/itm/256687708016).

{{ image(img="/blog/blog-2026-01-06/IMG_1751.jpeg") }}

The SPARCengine Ultra came in various kinds, as illustrated in [this catalog I found online](https://portwell.com/pdf/catalog/01s.pdf), or [this one](https://vtda.org/pubs/SunExpert/ServerWorkstationExpert-v11n04-2000-04.pdf). I see options for:

* SPARCengine Ultra AX
* SPARCengine Ultra AXe (I guess UltraSPARC IIe?)
* SPARCengine Ultra AXi (what I have, with UltraSPARC IIi)
* SPARCengine Ultra AXdp (I think that has two CPUs?)
* SPARCengine Ultra AXmp (I think that [has four CPUs](https://www.hpcwire.com/1999/02/05/sun-ships-400mhz-sparcengine-ultra-axmp-board/)?)

I think there were earlier non-Ultra SPARCengine boards too. The [Solaris 9 Hardware Platform Guide](https://docs.oracle.com/cd/E19683-01/816-7582-10/816-7582-10.pdf) lists all these and more besides. I don't really know the specs of each of them as there isn't much documentation online beyond short mentions in various OS release notes.

Luckily the one I have is the exception, because it has an entry on [theretroweb.com](https://theretroweb.com/motherboards/s/sun-sparcengine-ultra-axi) along with a photo and a copy of the user manual. And what a user manual! It's designed for system integrators not hobbyists, so it goes into all sorts of wonderful detail about precisely which DIMMs will work (we need 10-bit column address DIMMs in order to use all eight slots, apparently...). And the good news is that whilst it takes the same RAM and CPU modules as the Ultra 5, the SPARCengine Ultra AXi has on-board SCSI instead of IDE, so we can hook it up to a *real* hard disk and CD-ROM drive, instead of that low-grade commodity PC rubbish I had to put up with as a teenager.

## It's broken ... and then it's fixed

Initially, the machine would not boot at all. Hooking up a serial connection showed it crashing mid-way through the CPU tests as it brought up the memory controller (it got to `Init Sabre MCU Control and Status regs` and then no further).

This was bad news. I had a chat with John Paul Adrian Glaubitz (one of the people bravely trying to keep Debian going on SPARC, amongst other things) and he noted that the NVRAM chip might be holding some DIMM configuration, and bad NVRAM contents might cause the memory controller bring-up to fail. Looking through user manual, I saw this line:

> **Stop-N** - Reset NVRAM contents to default values

Would that help? Yes it does. I don't know the serial port equivalent so I hooked my my Type 6 keyboard and held down that sequence as I powered the board on, and it worked! The failing test passed without issue and we get to a boot prompt!

```text
SPARCengine(tm)Ultra(tm) AXi (UltraSPARC-IIi 333MHz), No Keyboard
OpenBoot 3.10.8 SME, 64 MB memory installed, Serial #16777215.
Ethernet address ff:ff:ff:ff:ff:ff, Host ID: ffffffff.


The IDPROM contents are invalid

Boot device: net  File and args:                                      
Internal loopback test -- Did not receive expected loopback packet.
Evaluating: boot

Can't open boot device

ok
```

I've since replaced the NVRAM chip with a new-old-stock one off Amazon, but if it dies again, I know the trick and now you know the trick too. I fixed the HostID and MAC Address too - the same way you do [on a SPARCstation](http://www.obsolyte.com/sunFAQ/faq_nvram.html).

## Graphics

The board came to me fitted with an ATI Rage II PCI graphics card. As the Ultra 5 shipped with integrated graphics using the same chip, this seems to make sense. But I tested the graphics card on my Windows XP PC and it worked fine. This means it has a standard PC BIOS ROM on it, rather than an OpenFirmware ROM. So why does it work? Graphics cards need a lot of fiddly register initialisation at start-up, and it's this ROM that does it (whether written in FORTH or in x86 machine code). Sun doesn't ship an x86 emulator in ROM (unlike the DEC Alpha), so who is initialising this card?

It turns out the SPARCengine firmware in ROM on the mainboard includes code to bring-up ATI Mach64 based  graphics cards. So it's like it has integrated graphics, but the graphics chip is on a PCI card. 

{{ image(img="/blog/blog-2026-01-06/IMG_1752.jpeg") }}

The board also has a UPA slot, and it works with my Creator 3D card too (which is what is fitted in the picture above that one).

## But what to do with it?

This board is basically an Ultra 5, but without a case. I don't have an MRI scanner or any other industrial equipment to drive with it and even if I did, I don't have the software for such exotic peripherals. So it's not *useful* per-se, except as a thing to look and and marvel at its unlikeliness of being. You could put it in a period correct beige PC case, but then it looks like every other beige PC (and I have one of those anyway). So, what it needs is a 2000's gamer case with a window and LED lights. Let's imagine we got this board in some office clearance in the mid-2000s and we want to impress all our friends at the local LAN party.

And, well, as it happens, the other day I was given a Gigabyte 3D Aurora. Actually, it's the Packard Bell branded version, but it's definitely that case. Slightly newer than I was going for, but [I could get into it](https://www.youtube.com/watch?v=6l92DCikvpI).

{{ image(img="/blog/blog-2026-01-06/IMG_1885.jpeg") }}

The image doesn't really convey the scale of this thing - it has *five* 5.25" bays, two 3.5" external bays, and room for five 3.5" hard disks. That window? It's quite a bit bigger than A4 size. This case is *big*.

It was also filthy, so I stripped it down into its many compment parts and vacuumed and brushed it out as best I could. It came with a Socket AM3 board and Phenom II X2 CPU, which I'm unsure what to do with. Maybe that can go into the second 19" rack-mount case that I didn't sell.

Fitting the SPARCengine I realised that the Creator 3D was too long, thanks to the hard drive cage. Which is weird given the size of the case, but, whilst there's loads of room above the CPU, we don't have any room at the back of the expansion card slots. It's doubly annoying because there are no parts down that end of the video card - it's only that long so it reaches the card slots in the Ultra 80. I did considering sawing the end off, but thought better of it.

{{ image(img="/blog/blog-2026-01-06/IMG_1895.jpeg") }}

Unfortunately this leaves me with no graphics card. I no longer have the Rage 3D card it came with, because it sold that with the Sun Ultra 80 in a trade for a Power Macintosh G3 that will run Rhapsody. Yeah, a story for another time. Nor do I have the PGX32 which originally came in the Ultra 80, because I swapped it for the Creator 3D. Anyway, I've had to buy a PCI ATI Rage XL off eBay, so let's see if the Mach64 BIOS I have on board can handle it. Probably? For now, we can use the serial console and bathe in the blueness of the case LEDs, and the quality of my cable management. No really, by 90's standards this is pretty good.

{{ image(img="/blog/blog-2026-01-06/IMG_1896.jpeg") }}

Expect to see this absolute monster at [Retro Fest in Swindon](https://www.retrofest.uk/) - 30 and 31 May, 2026. I don't know what it'll be running - so far it's had the current OpenBSD and Debian 3.0 Woody. Maybe Solaris 8? NetBSD? Not sure. Suggestions to the usual address.
