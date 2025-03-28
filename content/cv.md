+++
title = "Curriculum Vitae"
in_search_index = true
template = "static-page-cv.html"
+++

# Curriculum Vitae

I am an Embedded Systems engineer specialising in safe, secure, reliable embedded systems design and development. I have a background in Local Government, having been elected to St Ives Town Council twice, and having served as Deputy Town Mayor and Town Mayor. I am also an experienced public speaker. In 2023 I joined the new Rust Leadership Council as the representative for the *Launching Pad* team.

## **Technical Experience**

In the course of my career I have worked with a huge variety of embedded systems, including the following:

* **Processor Families**
  * Arm Cortex-M
    * Raspberry Pi RP2040, RP2350
    * Nordic Semiconductor nRF52, nRF91
    * ST Micro STM32
    * Texas Instruments Tiva-C, CC1310
    * Silicon Labs EFM32
  * Arm Cortex-A/ARM11
    * Texas Instruments Sitara AM335x
    * Texas Instruments Sitara AM57x
    * Texas Instruments DaVinci DM81x
    * Broadcom BCM283x
  * SPARC
    * Gaisler LEON3 (SPARC V8)
  * Cambridge Consultants XAP2
    * CSR BlueCore 5
  * RISC-V
    * Raspberry Pi RP2350
    * Espressif ESP32-C3
    * StarFive JH7100
  * DSP
    * Texas Instruments C66x
  * Other Microcontrollers
    * Atmel ATmega, ATxmega
    * Microchip PIC18, PIC24
    * ST Micro STM8
* **Programming Languages**
  * Rust
  * C
  * C++
  * Python (inc Django)
  * PHP
  * Perl
  * Java
  * JavaScript
  * Bash
  * SQL
  * Delphi / Pascal
* **System Software**
  * Linux (Build-root/Debian/Ubuntu/CentOS/Arch)
  * U-Boot
  * Mentor Graphics Nucleus
  * Eclipse ThreadX
  * Amazon FreeRTOS
  * Zephyr
  * mynewt
  * Bluestack
  * TI SYS/BIOS
* **Communications Technologies**
  * L-Band Satellite
  * Proprietary Sub-1GHz (ISM band)
  * Wi-Fi
  * NB-IoT and LTE Cat-M
  * Bluetooth (Classic and LE)
  * 802.15.4
  * Ultra-wideband

## **Work Experience**

### Ferrous Systems

#### Senior Embedded Engineer - *Dec 2021 to Present*

Ferrous Systems (<https://www.ferrous-systems.com>) is a Rust programming language consultancy and training provider.

My role includes:

* Providing Rust training to clients.
* Providing Rust consultancy and development services to clients.
* Contributing to Ferrocene, the safety-qualified Rust compiler, and Knurling, the open-source Rust Embedded toolset.
* Improving the training material.
* Working on open-source projects.
* Lectures and articles.

### 42 Technology

#### Senior Consultant, Electronics and Software Group - *Jan 2019 - Nov 2021*

42 Technology (<http://www.42technology.com>) is a product design and
development consultancy.

My role included:

* Embedded firmware development in Rust, C, C++ and Assembly Language
* Systems Engineering and Requirements Analysis
* Staff training
* Sales and proposals
* Improving Software Development processes
* Interviewing candidates
* Lectures and articles

### Cambridge Consultants

#### Senior Consultant, Wireless and Digital Services - *Jan 2018 - Jan 2019*

#### Principal Engineer, Wireless and Digital Services - *Jan 2015 - Jan 2017*

#### Senior Engineer, Wireless Software - *Apr 2009 - Jan 2014*

Cambridge Consultants (<http://www.cambridgeconsultants.com>) is one of the
original Cambridge-based product design and development consultancies, founded
in 1960. Spin-out companies include Xaar, Domino, Cambridge Silicon Radio,
AlphaMosaic, Aveillant and Evonetix.

My role included:

* Embedded firmware development in C
* Automated Test System development in Python
* Systems Engineering and requirements analysis
* System Test
* Demonstrations for client/VIP tours
* Staff training
* Sales and proposals
* Improving Software Development processes
* Product delivery and integration at client facilities
* Designing and developing an in-house CI system based on Python/Django and VMware ESXi
* Interviewing candidates
* Lectures and articles

### HM GCC

#### Engineer: 2006 - 2009

#### Graduate Engineer: 2004 - 2006

HM GCC provides electronics and software to support the communication needs of the British Government.

My role included:

* Embedded firmware development in C, C++ and Assembly Language
* Desktop application development in C++, Delphi and C#
* Designing and developing a stock management system
* Systems Engineering and requirements analysis
* System Test

### University of Warwick, Department of Computer Science

#### Software Developer - *Summer 2003*

I worked on the BOSS On-line Submission System, an open-source coursework submission server and client UI written in Java and using PostgreSQL.

### HouseWeb.co.uk

#### Web Developer - *Summer 2001 and Summer 2002*

Developer for an early on-line property sales portal. Web development in Perl, PHP, HTML and JavaScript.

## Open Source Development

Outside of work (and occasionally in work), I have developed the following open-source projects:

* [Neotron Pico] - a microATX single-board computer powered by a Raspberry Pi Pico microcontroller
* [Neotron OS] - a portable MS-DOS alike single-tasking OS, written in Rust
* [Neotron Pico BIOS] - the BIOS for the Neotron Pico, with SD Card, Audio and software-generated bitmap and text mode video
* [The Monotron] - a single-board computer based around the Texas Instruments Tiva-C Launchpad, written in Rust
* [tlv320aic23] - a driver for the Texas Instruments TLV320AIC23B audio CODEC
* [nau88c22] - a driver for the Nuvoton NAU88C22 audio CODEC
* [embedded-sdmmc] - a SD/MMC block device driver and FAT16/FAT32 implementation written in Rust
* [cmsim] - a simple Arm processor simulator, written in Rust, supporting Armv6-M. Able to boot Neotron OS.
* [neotron-loader] - a `no_std` ELF parser that doesn't require the ELF data to already be in RAM
* [neotracker] - a 4-channel ProTracker parser written in `no_std` Rust, with example player
* [monotron-synth] - a three-channel basic `no_std` wave-table synthesiser, used on The Monotron
* [vga-framebuffer] - a `no_std` VGA-over-SPI rendering engine, used on The Monotron
* [rust-beagleboard-x15] - a demo for the Beagleboard X15 which exchanges messages between Linux on the Cortex-A core, and a bare-metal Embedded Rust application on the embedded Cortex-M4 IPU
* [tm4c-hal] - a HAL and set of Board Support Packages for the Texas Instruments Tiva-C Launchpad and other TM4C123/TM4C129 based boards
* [grease] - a message-passing application framework for building layered protocol stacks in Rust
* [multi-map] - a two-key hashmap, written in Rust
* [pc-keyboard] - a Scan-code decoder for PC XT, AT and PS/2 keyboards, written in Rust
* [zube] - an Open Source ASIC design for interfacing with Z80 CPU, developed as part of zero2asic and built on Google's MPW3 shuttle
* [illyria] - a stop-and-wait ARQ using postcard + COBS as a serialisation mechanism, in Rust
* [pyvmlib] - a Python library for interacting with VMware ESXi servers
* [tockloader-proto-rs] - an implementation of the `tockloader` protocol, in Rust
* [rushttp] - an HTTP server written in Rust

[Neotron Pico]: https://github.com/neotron-compute/neotron-pico
[Neotron OS]: https://github.com/neotron-compute/neotron-os
[Neotron Pico BIOS]: https://github.com/neotron-compute/neotron-pico-bios
[embedded-sdmmc]: https://github.com/rust-embedded-community/embedded-sdmmc-rs
[The Monotron]: https://github.com/thejpster/monotron
[tlv320aic23]: https://github.com/neotron-compute/tlv320aic23
[nau88c22]: https://github.com/thejpster/nau88c22
[cmsim]: https://github.com/thejpster/cmsim
[neotron-loader]: https://github.com/neotron-compute/neotron-loader
[neotracker]: https://github.com/thejpster/neotracker
[monotron-synth]: https://github.com/thejpster/monotron-synth
[vga-framebuffer]: https://github.com/thejpster/vga-framebuffer-rs
[tm4c-hal]: https://github.com/rust-embedded-community/tm4c-hal
[grease]: https://github.com/thejpster/grease
[multi-map]: https://github.com/rust-embedded-community/multi-map
[pc-keyboard]: https://github.com/rust-embedded-community/pc-keyboard
[zube]: https://github.com/thejpster/zube
[illyria]: https://github.com/thejpster/illyria
[pyvmlib]: https://github.com/cambridgeconsultants/pyvmlib
[rust-beagleboard-x15]: https://github.com/thejpster/rust-beagleboard-x15
[tockloader-proto-rs]: https://github.com/thejpster/tockloader-proto-rs
[rushttp]: https://github.com/thejpster/rushttp

These works and more can be found at my [personal Github account](https://github.com/thejpster), or my [corporate Github account](https://github.com/jonathanpallant).

## **Local Government and Community Groups**

### The Rust Project

#### Member of the Rust Leadership Council: 2023 - 2024

Council representative for the Launching Pad Team.

#### Embedded Devices Working Group: 2018 - 2024

I helped found Rust's Embedded Devices Working Group, after meeting like-minded developers through my work getting Rust code running on the Texas Instruments Stellaris Launchpad. I regularly attended the weekly meetings, as well as reviewed and submitted PRs on their [Github page](https://github.com/rust-embedded).

#### Foundation Grant Recipient: 2022

I received $3000 of Grant Funding for The Neotron Project, which paid for the production of 25 Neotron Pico PCBs, which I gave away free-of-charge to developers interested in Embedded Rust.

### St Ives Town Council

#### Town Mayor of St Ives: 2020 - 2021

#### Deputy Town Mayor of St Ives: 2019 - 2020

#### Chair of the Property Committee: 2017 - 2022

#### Vice-Chair of the Norris Museum and Library Trust Committee: 2019 - 2022

#### Vice-Chair of the Personnel Committee: 2021 - 2022

#### Vice-Chair of the Property Committee: 2016 - 2017

#### Member of the Property Committee: 2016 - 2022

#### Member of the Personnel Committee: 2016 - 2019; 2021 - 2022

#### Member of the Amenities Committee: 2019 - 2020

#### Member of the Planning Committee: 2019 - 2020

#### Member of the Promotion and Publicity Committee: 2016 - 2019

#### Town Councillor (Independent)

I was elected to St Ives Town Council twice, in May 2016 (for a two year term) and in 2018 (for a four year term).

St Ives is a historic Market Town in Huntingdonshire, and the Town Council has been in existence since 1974 (although it was preceded by St Ives Borough Council, which was founded in 1874). The Town Council has around 11 staff and provides services to the 17,000 residents of St Ives. These services include maintaining the following buildings and facilities:

* The Town Hall, Market Hill
* The Corn Exchange, The Pavement
* The Norris Museum and Library (the Museum of Huntingdonshire), The Broadway
* The Burleigh Hill Centre, Constable Road
* Hill Rise Cemetery, Hill Rise
* Hill Rise Allotments, Hill Rise
* Warner's Park and Warner's Park Pavilion, Park Lane
* Slepe Hall Field, Ramsey Road
* Eight children's play areas

As Chair of various committees, and as Town Mayor (i.e. Chair of the Town Council), I have extensive experience in conducting formal meetings, decision making and public events. I am independent, open-minded, and always try to ensure that discussions lead to a productive outcome.

### Cambridge and District Classic Car Club

#### Chair: 2013 - 2016

#### Vice-Chair: 2013

#### Membership Secretary: 2010 - 2013

#### IT Officer: 2009 - 2016

The Cambridge and District Classic Car Club was founded in 1995 and is a multi-marque club offering regular club-nights and organised attendance at local car shows.

### Warwick Student Cinema

#### IT Officer: 2002/2003

## **Education**

### University of Warwick

#### MEng in Computer Systems Engineering (first-class): 2000/01 - 2003/04

### Hills Road Sixth Form College, Cambridge

#### Computing (A), Maths (A), Further Maths (A), Physics (A) - *1998/99 - 1999/00*

## Articles and Appearances

Listed in alphabetical order.

### ACCU

* Bristol, 2022, *Neotron – writing a single-tasking ‘DOS’ for Arm microcontrollers, in Rust* ([accu.org](https://accu.org/conf-main/main/)) ([youtube.com](https://www.youtube.com/watch?v=hD7ZMOYy0zI))
* Bristol, 2019, *Monotron - a 1980s style home computer written in Rust* ([accu.org](https://accu.org/conf-previous/2019/sessions/)) ([youtube.com](https://www.youtube.com/watch?v=BmjqAhRtvHI))
* Bristol, 2018, *Grease: A Message-Passing Approach to Protocol Stacks in Rust* ([accu.org](https://accu.org/conf-previous/2018/sessions/))

### Arm

* On-line, 2024, *Building Safe and Secure Software with Rust on Arm*, ([community.arm.com](https://community.arm.com/arm-community-blogs/b/tools-software-ides-blog/posts/rust-on-arm-building-safe-secure-software))

### BBC News

* On-line, 2013, *Raspberry Pi aids cyber 'safety net' for African rhino* ([bbc.co.uk](https://www.bbc.co.uk/news/technology-24014926))

### Centre for Computing History

* Cambridge, 2024, *Retro Computer Festival - Backwards Compatibility*
* Cambridge, 2024, *Synthesised - The History of PC Sound*
* Cambridge, 2023, *Retro Computer Festival - The History of Arm*
* Cambridge, 2023, *Synthesised - The History of PC Sound*
* Cambridge, 2022, *Retro Computer Festival - Computers Doing the Wrong Thing*
* Cambridge, 2022, *Neotron – writing a single-tasking ‘DOS’ for Arm microcontrollers, in Rust* ([computinghistory.co.uk](http://www.computinghistory.org.uk/det/67361/TechTalk-Jonathan-Pallant-Neotron-writing-a-single-tasking-DOS-for-Arm-microcontrollers-in-Rust-Thursday-12th-May-2022/))
* Cambridge, 2019, *Rust Tutorial with Jonathan Pallant* ([computinghistory.org.uk](https://www.computinghistory.org.uk/det/51020/Rust-Tutorial-with-Jonathan-Pallant/))
* Cambridge, 2017, *Coding as an Art Form* ([youtube.com](https://youtu.be/oL60-8GPgpg))

### The Coriolis Effect Show, with Bil Herd and Ben Jordan

* On-line, November 2023 (link temporarily unavailable)
* On-line, June 2022 (link temporarily unavailable)
* On-line, December 2022 (link temporarily unavailable)

### Electronics Weekly

* Print and on-line, January 2020, *Making embedded devices a little Rusty* ([electronicsweekly.com](https://www.electronicsweekly.com/news/iot-software-making-embedded-devices-little-rusty-2020-01/))
* Print and on-line, August 2019, *42 Technology advocates Rust for secure IoT* ([electronicsweekly.com](https://www.electronicsweekly.com/news/design/communications/42-technology-advocates-rust-secure-iot-2019-08/))

### Engineering Design Show

* Coventry, 2016, *Using off-the-shelf boards in commercial products*

### EuroRust

* Vienna, 2024, *Writing an SD Card Driver in Rust* ([youtube.com](https://www.youtube.com/watch?v=-ewuFNKIAVI))
* Brussels, 2023, *Panel: Inside Rust* ([youtube.com](https://www.youtube.com/watch?v=pM_c4HNiEB0))
* Brussels, 2023, *The Neotron Saga* ([youtube.com](https://www.youtube.com/watch?v=14El4Qy1BnM))

### High Integrity Software

* Bristol, 2017, *Delivering quality, time after time* ([his-conference.co.uk](https://www.his-conference.co.uk/session/delivering-quality-time-after-time))

### The MagPi

* Print and on-line, Issue 73, *Introduction to Rust on the Raspberry Pi* ([magpi.raspberrypi.org](https://magpi.raspberrypi.org/issues/73))

### Meeting Embedded

* Berlin, 2019, *IoT with Rust and the nRF9160 - more secure and lower power!* ([meetingembedded.com](https://meetingembedded.com/2019/Schedule.html))
* Berlin, 2018, *Remoteprocs in Rust* ([meetingembedded.com](https://meetingembedded.com/2018/Schedule.html))

### NDC TechTown

* Kongsberg, 2022, *Neotron – why write a brand new 'DOS' for Arm in Rust* ([ndctechtown.com](https://ndctechtown.com/agenda/neotron-why-write-a-brand-new-dos-for-arm-in-rust-0cpw/0487cdpyzdg))

### New Electronics

* Print and on-line, March 2021, *Cooking up a connected product* ([newelectronics.co.uk](https://www.newelectronics.co.uk/electronics-technology/cooking-up-a-connected-product/235439/))
* Online, October 2021, *42 Technology helps develop smarter monitoring for remote farms* ([newelectronics.co.uk](https://www.newelectronics.co.uk/electronics-news/42-technology-helps-develop-smarter-monitoring-for-remote-farms/241609/))

### Oxidize

* Berlin, 2024, *Workshop: Introduction to Rust for Safety Critical Systems* ([oxidizeconf.com](https://oxidizeconf.com/sessions/intro-safety-critical/))
* On-line, 2020, *How We Got QUIC Running on the nRF9160 Before Everyone Else* ([youtube.com](https://www.youtube.com/watch?v=zPuELAzJyno))
* Berlin, 2019, Event Host

### PiWars

* Cambridge, 2017, Intermediate Category - First Place, ([piwars.org](https://piwars.org/2017-competition/aftermath/))
* Cambridge, 2016, Runner Up

### Raspberry Pi / Cambridge Raspberry Jam

* On-line, 2024, *Rust on RP2350*, ([raspberrypi.com](https://www.raspberrypi.com/news/rust-on-rp2350/))
* Cambridge, 2024, *Is a Pi Pico a computer?* ([youtube.com](https://www.youtube.com/watch?v=7Fa-69AhxPg))
* Cambridge, 2017, *Rust as an alternative to Python* ([raspberrypi.org](https://www.raspberrypi.org/app/uploads/2017/02/Birthday-Schedule-Saturday-_-Sunday.pdf))
* Cambridge, 2017, *Workshop: Introduction to Rust on the Raspberry Pi*
* Cambridge, 2017, *Computing with Physical Quantities* ([youtube.com](https://www.youtube.com/watch?v=JN40Sz8vtLA))
* Cambridge, 2016, *Driving Neopixels from Python*
* Cambridge, 2016, *Programming in Rust on the Pi* ([youtube.com](https://www.youtube.com/watch?v=6O4OCU45Djo))
* Cambridge, 2015, *Pi, Penguins, Rhinos and Space* ([raspberrypi.org](https://www.raspberrypi.org/blog/birthday-weekend-happenings/))

### Rust Belt Rust

* Ann Arbor, 2018, *Monotron - a 1980s style home computer written in Rust* ([conf2018.rust-belt-rust.com](http://conf2018.rust-belt-rust.com/)) ([youtube.com](https://www.youtube.com/watch?v=xBRFtlT5Pfs))

### RustConf

* Montreal, 2024, *Six Pixels Per Second* ([youtube.com](https://www.youtube.com/watch?v=W45_KnLZ804))
* Portland, 2019, *Monotron - Building a retro computer in Embedded Rust* ([2019.rustconf.com](https://2019.rustconf.com/schedule)) ([youtube.com](https://www.youtube.com/watch?v=PXaSUiGgyEw))

### RustFest

* Paris, 2018, *Monotron: Making a 80s style computer with a $20 dev kit* ([paris.rustfest.eu](https://paris.rustfest.eu/talks/)) ([youtube.com](https://www.youtube.com/watch?v=pTEYqpcQ6lg))

### Safety Critical Systems Club

* London, 2022, *Rust for Safety Critical Systems* (last-minute stand-in)

### UK Embedded

* Coventry, 2022, *The Rust Programming Language and its applicability today on the development on secure, high-performance embedded systems* ([ukembedded.co.uk](https://www.ukembedded.co.uk/agenda))

### University of Cambridge

* Department of Computer Science, 2019, *Rust and The Monotron*
* Jesus College MCR, 2015, *Pi, Penguins, Rhinos and Space*
* Department of Engineering, 2015, *My life as an Engineer*

### University of Warwick

* Department of Engineering, 2018, *My life since Warwick*
* Third-year Project, 2003, *Fast image processing using a Gate Array*
