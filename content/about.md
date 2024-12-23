+++
title = "About Me"
in_search_index = true
template = "static-page.html"
+++

# About Me

I am a husband and father of two, living in the town of St Ives, Cambridgeshire, England.

We have two cats and a dog. I have a a growing collection of old computers and memories of an old Jaguar.

I successfully stood for election to [St Ives Town Council](https://www.stivestowncouncil.gov.uk) as an Independent in 2016 and again in 2018. In 2019 my fellow Town Councillors elected me as Deputy Town Mayor, and in 2020 as Town Mayor.

For my day job, I have spent over 15 years as an Embedded Systems Consultant for several Cambridge based product design consultancies. I am currently working at [Ferrous Systems](https://ferrous-systems.com) remotely from my home town of St Ives, providing consulting and training in Rust.

From 2023-2024, I spent a year on the new Rust Leadership Council as the representative for the *Launching Pad* team.

## Technical Skills

I have delivered client projects on everything from the smallest Microchip PIC, to huge multi-core Arm Cortex-A based SoCs. I can program in Rust, C, C++, Python, JavaScript, BASIC, Perl, PHP and SQL.

## Computers

My collection currently includes:

* Commodore 128D
  * JiffyDOS (for C128, C64 and 1571)
  * External Pi1541
  * CGA to SCART adaptor
* Amstrad PCW9512
  * 3" CF2DD Drive A:
  * Gotek Drive B:
  * Daisywheel Printer
* Acorn RiscPC 700
  * 486 PC card
  * Twin-slice case
  * Maxtor 1GB IDE HDD
  * Acorn AKA31 SCSI Card
* BBC Master
  * 3.5" floppy drive
  * Pi-Tube Direct
* Commodore Amiga 500
  * 512KB RAM Expansion
  * Kickstart Multi-ROM
* Atari 1040STFM
* Atari 520ST 'Tower Power'
  * Housed in a tower case, with custom wiring harness
  * Three floppy drives (1x 5.25", 2x 3.5")
  * RAM upgrade to 4MB
  * ACSI to SCSI adapter
  * 500MB SCSI HDD
* Sun Ultra 80
  * Quad UltraSPARC-II (one CPU is faulty)
  * 3GB RAM
  * 18GB SCSI HDD
  * PGX32 Framebuffer
* [Silicon Graphics POWER Indigo 2](@/blog/blog-2024-11-22/index.md)
  * MIPS R8000
  * 64MB RAM
  * 4GB SCSI HDD
  * XZ Graphics
* Dell Precision T3400 Workstation
  * Core 2 Duo
  * 1GB RAM
  * Windows XP
  * nVidia Quadro 600
* [Pentium III @ 450 MHz](@/blog/blog-2024-06-29/index.md)
  * Windows 98 / MS-DOS 6.22 dual-boot
  * 128 MB RAM
  * Diamond Viper V770 Ultra
  * SoundBlaster AWE64
  * PicoGUS
  * Adaptec AHA-2940UW SCSI card
  * MT32-Pi
* Sega Master System II
* Sega MegaDrive
* Nintendo SuperNES
* Microsoft Xbox
* Nintendo Wii
  * With Gamecube memory module and controllers
* Sony Playstation
* Sony Playstation 2
* Sony Playstation 3
* Sony Playstation 4
* Various Raspberry Pis

My day-to-day machines are a Dell Inspiron 7400 laptop and an HP Z1 G5 desktop, both running Windows 11. I've used a variety of Linux distributions as my desktop OS pretty much exclusively since 2003, but these days I need to share the computers with my family.

## Cars

I used to own a 1995 Jaguar Sovereign 3.2 LWB (long wheel-base), between 2011 and 2021.

I owned an electric Nissan Leaf for three years, and then an MG 5. Currently I just have the use of my wife's electric Citroen e-C4.

## Model Railways

My N-Gauge model railway was dismantled in 2018 owing to a lack of space. I still have a collection of rolling stock and landscaping items in storage, and when time and funds allow, a new layout will be created. My preferred location and era for modelling is Warwickshire and the West Midlands circa 2000-2004 (which is where and when I was at University), so I have several Chiltern and Virgin Voyager DMUs. I am a member of the N Gauge Society.

## Personal Projects

### Rust

I have been a huge fan of the Rust programming language since the 1.0 days. As part of this, I produced some [workshop material](https://github.com/thejpster/pi-workshop-rs) for the Raspberry Pi Party 2017. I've also delivered several Embedded Rust training workshops, and it's been a key theme of my projects over the last seven years. In 2021 I was lucky enough to join Ferrous Systems, where I write and teach Rust full-time. In 2023/2024 I was also invited to join the Rust Leadership Council where I spent a year as the representative for the *Launching Pad* team.

### Monotron

I wanted to make a 1980s style home computer using an inexpensive Cortex-M4 devkit. Can you generate VGA from this board? In colour? How about handle a PS/2 keyboard? Load applications? Let the user write BASIC programs? Generate audio? More importantly, can you do all this in pure Embedded Rust, with no C or C++ in sight? The result was The Monotron, a small single-board computer inspired by early CP/M and MS-DOS machines. This was presented at several tech conferences, including [Rust Fest Paris (2018)](https://www.youtube.com/watch?v=pTEYqpcQ6lg&t=2s), [Rust Belt Rust (2018)](https://www.youtube.com/watch?v=xBRFtlT5Pfs&t=33s), [ACCU 2019](https://www.youtube.com/watch?v=BmjqAhRtvHI) and [RustConf (2019)](https://www.youtube.com/watch?v=PXaSUiGgyEw).

You can see more on my [Github](https://github.com/thejpster/monotron).

### Neotron

Monotron has been followed by [Neotron](https://github.com/neotron-compute) - a family of Arm Cortex-M powered systems which share an OS, through the use of a custom BIOS acting as a hardware abstraction layer. The lead system - the Neotron Pico - is powered by a Raspberry Pi Pico microcontroller board and has VGA output, SD Card slot, PS/2 keyboard and 16-bit stereo audio. Side-quests include microcontroller-friendly ('`no_std`') crates for [decoding IBM PS/2 keyboard data](https://crates.io/crates/pc-keyboard), [reading FAT16 and FAT16 volumes from an SD Card over SPI](https://crates.io/crates/embedded-sdmmc), [parsing ELF files](https://crates.io/crates/neotron-loader) and [playing Amiga ProTracker files](https://github.com/thejpster/neotracker).

You can see more at <https://github.com/neotron-compute>.

### Grease

With a background in Telecoms firmware which use a strict layered message-passing approach to stack implementation, I wrote a proof-of-concept message-passing framework in Rust, called Grease (because it makes rusty threads work more easily).

The source code is [on Github](https://github.com/thejpster/grease).

### Beagleboard X15

I wrote a pure-Rust firmware for the Cortex-M4 sub-system in the Texas Instruments AM5874 SoC found on the Beagleboard X15. This implemented VirtIO vrings and could exchange messages with a C or Rust user-space application on the Linux/Cortex-A side via a socket.

The source code is [on Github](https://github.com/thejpster/rust-beagleboardx15-demo).

## Contact

You can contact me via:

* Github - [@thejpster](https://github.com/thejpster), or [@jonathanpallant](https://github.com/jonathanpallant) if I'm at work
* E-mail - website [&#65;T] thejpster.org.uk
* Mastodon - [@thejpster@hachyderm.io](https://hachyderm.io/@thejpster)
* BlueSky - [@thejpster.org.uk](https://bsky.app/profile/thejpster.org.uk)
* Twitter - [@therealjpster](https://twitter.com/therealjpster) (Defunct)
* Facebook - [@jonathan.pallant](https://facebook.com/jonathan.pallant) (Defunct)
* Keybase - [@thejpster](https://keybase.io/thejpster) (Defunct)
