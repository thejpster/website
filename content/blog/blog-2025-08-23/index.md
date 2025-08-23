+++
title = "How many SPARCs is too many SPARCs? Part 2"
date = "2025-08-23"
+++

## Background

This is a follow up to [the previous blog post](@/blog/blog-2025-08-20/index.md). You should read that first.

OK, so last time out we looked at the Sun Fire V100, the Sun Netra T1, the SPARCstation 1, the two SPARCstation 2s. We still have:

* Three SPARCstation 20s (suisse314759, suisse130242 and tiny) - none of which have CPUs
* One SPARCstation 10
* Two SPARCstation 5s (suisse16511 and mo28282)

Where I have duplicates I have named the machines after one of the stickers stuck on the front.

## Hard Drives

Having removed all the hard drives from all the machines, I have the following.

| Make      | Model     | Capacity | RPM  | Interface | Height | Status  |
|-----------|-----------|----------|------|-----------|--------|---------|
| Seagate   | ST1480N   | 426 MB   | 4400 | 50-pin    | Half   | Dead    |
| Maxtor    | LXT-535   | 535 MB   | 3600 | 50-pin    | Half   | Working |
| Seagate   | ST11200N  | 1.05 GB  | 5400 | 50-pin    | Half   | Dead    |
| Seagate   | ST11200N  | 1.05 GB  | 5400 | 50-pin    | Half   | Dead    |
| Seagate   | ST11200N  | 1.05 GB  | 5400 | 50-pin    | Half   | Working |
| Seagate   | ST31200N  | 1.05 GB  | 5400 | 50-pin    | Slim   | Dead    |
| Seagate   | ST31200N  | 1.05 GB  | 5400 | 50-pin    | Slim   | Working |
| Seagate   | ST31200WC | 1.05 GB  | 5400 | 80-pin    | Slim   | Working |
| Seagate   | ST32155WC | 2.1 GB   | 5400 | 80-pin    | Slim   | Working |
| Seagate   | ST32155WC | 2.1 GB   | 5400 | 80-pin    | Slim   | Working |
| Seagate   | ST32155WC | 2.1 GB   | 5400 | 80-pin    | Slim   | Working |


Several of them were still formatted and contained information relating to Credit Suisse. I have wiped those drives. On this small sample the slim drives (the ones the size of a 'modern' 3.5" hard drive) seem more reliable than the 'half-height' drive (which are about twice as tall as the 'slim' drives).

## RAM and Expansion Cards

I have three processor cards:

* SM30 - SuperSPARC at 36 MHz - untested
* SM41 - SuperSPARC with Cache at 40 MHz - tested OK
* SM61 - SuperSPARC with Cache at 60 MHz - untested

I also have a handful of [SBus SCSI/Ethernet cards](https://shrubbery.net/~heas/sun-feh-2_1/Devices/SCSI/SCSI_SBE_S.html), a couple of graphics cards, and a SPARCprinter card.

## SPARCstation 5 (in the SPARCstation 20 case)

It comes with an on-board microSPARC-II at 110 MHz, one 32 MB memory module and a Sun TurboGX graphics card. The NVRAM is dead so needs resetting on boot. I've installed Solaris 2.6 onto a ST32155WC using the BlueSCSI and it all works.

Actually, funny story. For ages I was convinced the external SCSI port on this machine was broken. But it was also broken on a bunch of other machines I tried. Nothing I could do could get the machine to detect the external 25-pin BlueSCSI. So, I went to find my 25-pin to 68-pin cable so I could plug the BlueSCSI into my big Dell tower, to test it, but that cable had gone missing. Whilst searching for the cable, I lifted up the PS/2 keyboard that I leave around for use with the Dell. Under the keyboard was the 25-pin end of the 25-pin to 50-pin cable that was plugged into the SPARCstation, and the 68-pin end of the 25-pin to 68-pin cable I had plugged into the BlueSCSI. But with the keyboard on top, it looked to all the world like the BlueSCSI was plugged into the SPARCstation - beige cable went in and beige cable went out. I said a few rude words at this point, but was happy to discover that the external SCSI port was in fact fine.

A reset looks like this:

```text
Resetting ... 
initializing TLB
initializing cache

Allocating SRMMU Context Table 
Setting SRMMU Context Register
Setting SRMMU Context Table Pointer Register
Allocating SRMMU Level 1 Table
Mapping RAM
Mapping ROM

ttya initialized
Probing Memory Bank #0 32 Megabytes
Probing Memory Bank #1 Nothing there
Probing Memory Bank #2 Nothing there
Probing Memory Bank #3 Nothing there
Probing Memory Bank #4 Nothing there
Probing Memory Bank #5 Nothing there
Probing Memory Bank #6 Nothing there
Probing Memory Bank #7 Nothing there
Probing CPU FMI,MB86904 
Probing /iommu@0,10000000/sbus@0,10001000 at 5,0  espdma esp sd st SUNW,bpp ledma le 
Probing /iommu@0,10000000/sbus@0,10001000 at 4,0  SUNW,CS4231 power-management 
Probing /iommu@0,10000000/sbus@0,10001000 at 1,0  Nothing there
Probing /iommu@0,10000000/sbus@0,10001000 at 2,0  Nothing there
Probing /iommu@0,10000000/sbus@0,10001000 at 3,0  cgsix       
Probing /iommu@0,10000000/sbus@0,10001000 at 0,0  Nothing there
Probing Memory Bank #0 32 Megabytes                           
Probing Memory Bank #1 Nothing there                          
Probing Memory Bank #2 Nothing there
Probing Memory Bank #3 Nothing there
Probing Memory Bank #4 Nothing there
Probing Memory Bank #5 Nothing there
Probing Memory Bank #6 Nothing there
Probing Memory Bank #7 Nothing there
Probing CPU FMI,MB86904 
Probing /iommu@0,10000000/sbus@0,10001000 at 5,0  espdma esp sd st SUNW,bpp ledma le 
Probing /iommu@0,10000000/sbus@0,10001000 at 4,0  SUNW,CS4231 power-management 
Probing /iommu@0,10000000/sbus@0,10001000 at 1,0  Nothing there
Probing /iommu@0,10000000/sbus@0,10001000 at 2,0  Nothing there
Probing /iommu@0,10000000/sbus@0,10001000 at 3,0  cgsix 
Probing /iommu@0,10000000/sbus@0,10001000 at 0,0  Nothing there

SPARCstation 5, No Keyboard
ROM Rev. 2.24, 32 MB memory installed, Serial #12648430.
Ethernet address 8:0:20:c0:ff:ee, Host ID: 80c0ffee.
```

Once we're in Solaris, we can get more information about the hardware:

```text
# prtconf
System Configuration:  Sun Microsystems  sun4m
Memory size: 32 Megabytes
System Peripherals (Software Nodes):

SUNW,SPARCstation-5
    packages (driver not attached)
        disk-label (driver not attached)
        deblocker (driver not attached)
        obp-tftp (driver not attached)
    options, instance #0
    aliases (driver not attached)
    openprom (driver not attached)
    iommu, instance #0
        sbus, instance #0
            espdma, instance #0
                esp, instance #0
                    sd (driver not attached)
                    st (driver not attached)
                    sd, instance #0 (driver not attached)
                    sd, instance #1 (driver not attached)
                    sd, instance #2 (driver not attached)
                    sd, instance #3
                    sd, instance #4 (driver not attached)
                    sd, instance #5 (driver not attached)
                    sd, instance #6
            SUNW,bpp, instance #0 (driver not attached)
            ledma, instance #0
                le, instance #0
            SUNW,CS4231, instance #0 (driver not attached)
            power-management (driver not attached)
            cgsix, instance #0 (driver not attached)
    obio, instance #0
        zs, instance #0
        zs, instance #1
        eeprom (driver not attached)
        slavioconfig (driver not attached)
        auxio (driver not attached)
        counter (driver not attached)
        interrupt (driver not attached)
        power (driver not attached)
        SUNW,fdtwo, instance #0 (driver not attached)
    memory (driver not attached)
    virtual-memory (driver not attached)
    FMI,MB86904 (driver not attached)
    pseudo, instance #0
```

## SPARCstation 20 - suisse314759

No CPU, no RAM and no NVRAM. With the SM41 and some RAM fitted, it doesn't even POST.

## SPARCstation 20 - suisse130242

No CPU and two 32MB sticks of RAM. With the SM41 fitted, it POSTS, but cannot see any SCSI devices - internal or external. This might be an issue with the unterminated cable that wasn't plugged into the BlueSCSI (see earlier) and I need to come back to it.

Whilst playing around with the NVRAM chip it ended up fitted backwards and got very hot - I suspect the NVRAM is very dead.

## SPARCstation 20 - tiny

Had no CPU, no RAM but a TurboGX graphics card.

Now has a SCSI/Ethernet card, 160 MB of RAM fitted (I was testing all the RAM I had) and the SM41 processor.

Incredibly the NVRAM still holds a charge, and I had to [hot-swap it](https://jmtd.net/hardware/sparcstation/) to remove the PROM password. I also had to set the on-board jumpers to enable RS-232 mode before I could see serial output - and one of the jumpers was actually missing.

POSTs OK but I wasn't able to install Solaris because my BlueSCSI wasn't plugged in (see earlier), but I suspect it would work fine. The internal hard drive was detected (I gave it a ST32155WC). The case is falling to pieces though, so I probably need to move this mainboard into another case.

## SPARCstation 5

This one is still untested.

## SPARCstation 10

I haven't dared power this one up because it is so dirty.
