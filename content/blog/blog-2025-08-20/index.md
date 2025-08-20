+++
title = "How many SPARCs is too many SPARCs?"
date = "2025-08-20"
+++

## Background

I was browsing [/r/vintagecomputing](https://reddit.com/r/vintagecomputing), as you do, and I came across [this post](https://www.reddit.com/r/vintagecomputing/comments/1mp7r9w/about_30_sun_sparc_workstations_need_a_new_home/):

>  Hi all. Back in the day I was a developer working exclusively on Solaris. About 25 years ago, for one reason and another I came into possession of about 30 assorted SPARC based workstations and a few other bits and bobs, network/SCSI cards, keyboards, mice, etc. I think there's also one UltraSPARC in there too. This stuff was well past its prime even then.
>
> I need to clear out the space they're stored in and it would be a shame for them to end up in landfill, so if anyone wants them they're free to a good home. They're currently located in West Berkshire, England.
>
> It should be noted that none of these machines have been powered up in well over a decade. I've no idea if any of them still work and with the exception of the one UltaSPARC I'm not sure what use they'd be to anyone. But the offer's there. 

Free SPARC machines? Not too far from me? Well it would be rude not to.

If you're new here, hi! I have been on a bit of a 90's RISC/UNIX bender recently - see [previous posts](@/blog/blog-2025-07-19/index.md).

Clearly I need some IBM RS/6000 in my life, but they are hard to find. And clearly I need some 32-bit SPARCV8, to go with the 64-bit SPARCV9 Ultra 80. Also I need more space. And money. Send help.

## The Collection

The machines were in Newbury and the owner needed to clear the whole lot, so wasn't particularly interested in people coming and collecting one at a time. So, I said I could come down right away (it's only a ~3 hour drive each way) and take as many as would fit into my car. The vendor was actually surprised at all the interest, and in the end we agreed I could take about half the pile, leaving half for the other people who were coming later.

Newbury is about 120 miles from me, so on Monday 18 August, I set off at 5pm for Operation SPARC RESCUE. The trip was uneventful and the vendor was very kind, and six hours later I'm back at home and realising I really don't have anywhere to put them.

{{ image(img="blog/blog-2025-08-20/boot.jpg") }}

So what do we have?

## The Machines

From newest to oldest we have:

* 1x [Sun Fire V100](https://dogemicrosystems.ca/wiki/Sun_Fire_V100) rack-mount server
* 1x [Sun Netra T1](https://dogemicrosystems.ca/wiki/Sun_Netra_T1_105) rack-mount server
* 3x [Sun SPARCstation 20](https://en.wikipedia.org/wiki/SPARCstation_20) pizza-boxes
* 1x [Sun SPARCstation 5](https://en.wikipedia.org/wiki/SPARCstation_5) pizza-box wearing a SPARCstation 20 lid - this was quite the surprise
* 1x [Sun SPARCstation 5](https://en.wikipedia.org/wiki/SPARCstation_5) pizza-box
* 1x [Sun SPARCstation 10](https://en.wikipedia.org/wiki/SPARCstation_10) pizza-box
* 2x [Sun SPARCstation 2](https://en.wikipedia.org/wiki/SPARCstation_2) pizza-boxes
* 1x [Sun SPARCstation 1](https://en.wikipedia.org/wiki/SPARCstation_1) pizza-box

The machines have various labels indicating many of them came from the investment bank [Credit Suisse](https://en.wikipedia.org/wiki/Credit_Suisse). It was also interesting to see how the cases got more plastic (and I presume cheaper) as time went on. The early stuff is very heavy and has a lot of metal - the later stuff, not so much.

## Sun Fire V100 - circa 2002

A rack-mount server with a 500MHz 64-bit UltraSPARC-IIe, and 1024 MiB of RAM. No hard disks. There's a smart-card installed in a slot at the rear of the machine, which I believe holds system configuration information (pretty clever idea really - it would make it easy to bring up a replacement machine with the same MAC address as a failed one).

The Lights-Out Management (LOM) works over Serial (9600/8N1) with a DE9 to RJ45 adapter cable. The LOM starts up OK, and the machine gets to the OpenFirmware 4.0 prompt. It uses EIDE internally, and has no hard disks but does have a slim-line CD-ROM. I threw in a spare 9GB Quantum EIDE drive and it seemed to detect it. It came with a Debian Etch CD-R in the tray, but I crashed on boot with *Illegal Instruction*:

```text
Resetting ... 
LOM event: +0h14m11s host reset

Sun Fire V100 (UltraSPARC-IIe 500MHz), No Keyboard
OpenBoot 4.0, 1024 MB memory installed, Serial #52400205.
Ethernet address 0:3:ba:1f:90:4d, Host ID: 831f904d.


Executing last command: boot cdrom                                    
Boot device: /pci@1f,0/ide@d/cdrom@3,0:f  File and args: 
SILO Version 1.4.13

                  Welcome to Debian GNU/Linux etch!

This is a Debian installation CDROM, built on 20080218-14:23.
Keep it once you have installed your system, as you can boot from it
to repair the system on your hard disk if that ever becomes necessary.

WARNING: You should completely back up all of your hard disks before
  proceeding. The installation procedure can completely and irreversibly
  erase them! If you haven't made backups yet, remove the rescue CD from
  the drive and press L1-A to get back to the OpenBoot prompt.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent permitted
by applicable law.

[ ENTER - Boot install ]   [ Type "expert" - Boot into expert mode ]
                           [ Type "rescue" - Boot into rescue mode ]
boot: 
Allocated 8 Megs of memory at 0x40000000 for kernel
Loaded kernel version 2.6.18
Loading initial ramdisk (3882238 bytes at 0x6F802000 phys, 0x40C00000 virt)...
Illegal Instruction
ok 
```

I have no idea if I should be able to boot this random CD or not. I also tried a random Solaris 7 CD I had, but again, I don't know if that's actually supposed to work in this machine. It seems clean and tidy inside and passes POST, so it's probably fine. Quite loud though - perhaps better suited to someone with a [clabretro](https://clabretro.com/) style homelab.

## Sun Netra T1 - circa 1999

The Netra T1 is another rack-mount system. This one doesn't have rails, or a front panel, and the lid is a bit bent. Inside we've got two 3.5" SCSI drives in hot-swap bays. Using the same RJ25 serial LOM connector as the V100, we see:

```text
lom> poweron
lom>
LOM event: power on

Checking Sun KB Done
%o0 = 0000.0000.0044.4001

Executing Power On SelfTest


SPARCengine(tm)Ultra CP 1500 POST 1.17 ME created 03/06/00
Time Stamp [hour:min:sec] 3f:7f:02

Init POST BSS
	Init System BSS

Probing system keyboard␁ : Done
DMMU TLB Tags
	DMMU TLB Tag Access Test
DMMU TLB RAM
	DMMU TLB RAM Access Test
Ecache Tests
	Probe Ecache
	ecache_size = 0x00200000
	Ecache RAM Addr Test
	Ecache Tag Addr Test
	Ecache RAM Test
	Ecache Tag Test
	Invalidate Ecache Tags
All CPU Basic Tests
	V9 Instruction Test
	CPU Tick and Tick Compare Reg Test
	CPU Soft Trap Test
	CPU Softint Reg and Int Test
All Basic MMU Tests
	DMMU Primary Context Reg Test
	DMMU Secondary Context Reg Test
	DMMU TSB Reg Test
	DMMU Tag Access Reg Test
	DMMU VA Watchpoint Reg Test
	DMMU PA Watchpoint Reg Test
	IMMU TSB Reg Test
	IMMU Tag Access Reg Test
	IMMU TLB RAM Access Test
	IMMU TLB Tag Access Test
All Basic Cache Tests
	Dcache RAM Test
	Dcache Tag Test
	Icache RAM Test
	Icache Tag Test
	Icache Next Test
	Icache Predecode Test
UltraSPARC IIi MCU Control & Status Regs Init and Tests
	Init UltraSPARC IIi MCU Control & Status Regs
	CPU speed : 440 Mhz, mc1 set : 0x544cb9dd
Memory Probe and Init
	Probe Memory
		INFO: All the memory Group in 10 bit column mode
		Group 0: 256MB
		Group 1: 256MB
		Group 2: 256MB
		Group 3: 256MB
	Malloc Post Memory
	Init Post Memory
..........
	Memory Addr w/ Ecache
	Map PROM/STACK/NVRAM in DMMU
	Load Post In Memory
	Run POST from MEM
	..........
	loaded POST in memory 
	Update Master Stack/Frame Pointers
All FPU Basic Tests
	FPU Regs Test
	FPU State Reg Test
	FPU Functional Test
	FPU Trap Test
Memory Tests
	Init Memory
...............
................
................
................
................
................
................
................
	Memory Addr w/ Ecache Test
	ECC Memory Addr Test
	Block Memory Addr Test
	Block Memory Test
...............	
...............	
	
................	
................	
	
................	
................	
	
................	
................	
	
................	
................	
	
................	
................	
	
................	
................	
	
................	
................	
	
	ECC Blk Memory Test
...............	
...............	
	
................	
................	
	
................	
................	
	
................	
................	
	
................	
................	
	
................	
................	
	
................	
................	
	
................	
................	
	
All Basic UltraSPARC IIi PBM Tests
	Init UltraSPARC IIi PBM
	PIO Decoder and BCT Test
	PCI Byte Enable Test
	UltraSPARC IIi IOMMU Regs Test
	UltraSPARC IIi IOMMU RAM NTA Test
	UltraSPARC IIi IOMMU CAM NTA Test
	UltraSPARC IIi IOMMU RAM Address Test
	UltraSPARC IIi IOMMU CAM Address Test
	IOMMU TLB Compare Test
	IOMMU TLB Flush Test
	PBM Control/Status Reg Test
	PBM Diag Reg Test
	UltraSPARC IIi PBM Regs Test
All Advanced CPU Tests
	DMMU Hit/Miss Test
	DMMU Little Endian Test
	IU ASI Access Test
	FPU ASI Access Test
	Ecache Thrash Test
All CPU Error Reporting Tests
	CPU Addr Align Trap Test
	DMMU Access Priv Page Test
	DMMU Write Protected Page Test
All Advanced UltraSPARC IIi PBM Tests
	Init UltraSPARC IIi PBM
	Consist DMA Wr, IOMMU hit Ebus Test
All Basic Cheerio Tests
	Cheerio Ebus PCI Config Space Test
	Cheerio Ethernet PCI Config Space Test
	Cheerio Ebus Engine Reg Test
	Cheerio Init
All Basic I2c Tests
	Init i2c bus
	Thermister Reading Test
        Thermister Position       Readings (in Hex)
        CPU                       0x6a
All Basic PCI-PCI Bridge Tests
	PCI-PCI Bridge Config Space Test
All Basic Symbios 875 SCSI controller Tests
	Symbios 875 SCSI controller PCI Config Space Test

Extended POST: 
Start Extended POST : No EXT POST is found


Power On Selftest Completed
    Status  = 0000.0000.0000.0000 ffff.ffff.f100.1db0 019f.3333.3a50.0011

Software Power ON

@(#) SPARCengine(tm)Ultra CP 1500  3.10.27 ME created 2000/06/22 16:45
Enter Checking KB 
ps/2 kbd check: 0000.0000.0000.00fe␁
Checking Sun KB 
Clearing E$ Tags  Done
Clearing I/D TLBs Done
Probing Memory 
Group Info[0000.0000.0000.0003] : 0000.0000.0000.0110
Group Info[0000.0000.0000.0002] : 0000.0000.0000.0110
Group Info[0000.0000.0000.0001] : 0000.0000.0000.0110
Group Info[0000.0000.0000.0000] : 0000.0000.0000.0110
Done
Clearing Memory...Done
MEM BASE = 0000.0000.3800.0000
MEM SIZE = 0000.0000.0800.0000
MMUs ON
Copy Done
PC = 0000.01ff.f000.30dc
PC = 0000.0000.0000.3120
Decompressing into Memory Done
Size = 0000.0000.0008.7710
ttya initialized
flashprom flashprom Incorrect configuration checksum; 
Setting NVRAM parameters to default values.
Setting diag-switch? NVRAM parameter to true
Reset Control: BXIR:0 BPOR:0 SXIR:0 SPOR:1 POR:0 
UltraSPARC-IIi Version 9.1 (E$=2 MB) 2-2 module
Advanced PCI Bridge Version 1.3
Probing Memory Group #0 128 + 128 : 256 Megabytes
Probing Memory Group #1 128 + 128 : 256 Megabytes
Probing Memory Group #2 128 + 128 : 256 Megabytes
Probing Memory Group #3 128 + 128 : 256 Megabytes
Initialise 2nd I2c controller
Environmental monitoring:  Enabled
i2c adc gpio gpio 
i2c Probing Floppy: No drives detected
Probing /pci@1f,0/pci@1,1 at Device 1  network 
Probing /pci@1f,0/pci@1,1 at Device 2  scsi disk tape 
Probing /pci@1f,0/pci@1,1 at Device 3  network 
Probing /pci@1f,0/pci@1 at Device 1  pci 
Probing /pci@1f,0/pci@1/pci@1 at Device 0  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 1  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 2  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 3  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 4  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 5  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 6  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 7  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 8  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device 9  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device a  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device b  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device c  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device d  Nothing there
Probing /pci@1f,0/pci@1/pci@1 at Device e  ide disk cdrom 
Probing /pci@1f,0/pci@1/pci@1 at Device f  Nothing there

Netra t1 (UltraSPARC-IIi 440MHz), No Keyboard
OpenBoot 3.10.27 ME, 1024 MB memory installed, Serial #14254892.
Ethernet address 8:0:20:d9:83:2c, Host ID: 80d9832c.



Boot device: net  File and args:                                      0
Using External Transceiver - Timeout waiting for AutoNegotiation Status to be updated. 
Timeout reading Link status. Check cable and try again. 
Timeout waiting for AutoNegotiation Status to be updated. 
Timeout reading Link status. Check cable and try again. 
Timeout waiting for AutoNegotiation Status to be updated. 
Timeout reading Link status. Check cable and try again. 
AutoNegotiation Timeout. 
Check Cable or Contact your System Administrator. 
Link Down.
Evaluating: boot

Can't open boot device

ok 

```

Wow, the POST has a lot to say for itself - so much more than the later V100. It appears we have a 440 MHz UltraSPARC-IIi with 1024 MiB of RAM. Let's look at those two SCSI hard disk drives:

```text
ok probe-scsi 
Primary UltraSCSI bus:
Target 1 
  Unit 0   Disk     FUJITSU MAN3184M SUN18G 1804
```

OK, well it sees one of them. Unlike the V100 this one has a high-density 68-pin SCSI connector on the back instead of a CD-ROM drive, so I could probably boot it from a BlueSCSI. We also have a Seagate drive fitted, but it doesn't appear to be detected. Given my experience with Seagate SCSI drives, this does not surprise me. We cannot boot the Fujitsu drive - I suspect it has been wiped:

```text
ok boot disk
Boot device: /pci@1f,0/pci@1,1/scsi@2/disk@0,0  File and args: 
Unrecognized magic number in media label
Can't open disk label package

Can't open boot device
```

## SPARCstation 1

We have a single SPARCstation 1. It looks OK inside, with on Maxtor hard disk. Applying mains power gives no results though - and checking the rails, there's only 1.5V on the +12V rail. That means no fans and no RS-232 drivers.

{{ image(img="blog/blog-2025-08-20/ss1.jpg") }}

I opened the PSU and it didn't look too bad inside - no obvious bulging or leaking. Note to the unwary - DO NOT REMOVE THE SCREWS ON THE SIDE. They hold on the transistor heatinks and are a right faff to refit. Simply ask your qualified electrical engineer to remove the small black machine screw at the end, and slide off the bottom cover towards the screw. The fan can remain in place.

## CSFB SPARCstation2

This is one of two SPARCstation 2 units - the one stickered as belonging to Credit Suisse. Applying power and we have success - it does a POST over Serial Port A. The hard drives spin up but the bearings sound horrific. I highly doubt they are usable. It also takes *forever* to check the RAM. Also I think the disk is blank. But, it's got power!

{{ image(img="blog/blog-2025-08-20/csfb-ss2.jpg") }}

Annoying these early machines have DB25F ports and I only have a DB25F cable. So ...

{{ image(img="blog/blog-2025-08-20/serial.jpg") }}

This works, don't judge me. Here's the console output on boot:

```text
WARNING: Unable to determine keyboard type
    WARNING: TOD Oscillator NOT Running, Kickstart in Progress ... Incorrect configuration checksum; 
Setting NVRAM parameters to default values.
Setting diag-switch? NVRAM parameter to true
Probing /sbus@1,f8000000 at 0,0  dma esp sd st le 
Probing /sbus@1,f8000000 at 1,0  Nothing there
Probing /sbus@1,f8000000 at 2,0  Nothing there
Probing /sbus@1,f8000000 at 3,0  Nothing there
screen not found.
Can't open input device.
SPARCstation 2, No Keyboard
ROM Rev. 2.4.1, 64 MB memory installed, Serial #16777215.
Ethernet address ff:ff:ff:ff:ff:ff, Host ID: ffffffff.


The IDPROM contents are invalid

Testing  64 megs of memory. Still to go    0

SBus slot 0 le esp dma 
SBus slot 1 
SBus slot 2 
SBus slot 3 

Boot device: /sbus/le@0,c00000   File and args:                  
Internal loopback test -- 
Did not receive expected loopback packet.
Can't open boot device

Type b (boot), c (continue), or n (new command mode)
>n
Type  help  for more information
ok
```

Can we see our two disks?

```text
ok boot disk
Boot device: /sbus/esp@0,800000/sd@3,0   File and args: 
bootblk: can't find the boot program
Program terminated

ok probe-scsi
Target 3 
  Unit 0   Disk        SEAGATE ST31200N SUN1.05872200534577 Copyright (c) 1994 Seagate All rights reserved 0000
Target 4 
  Unit 0   Disk        SEAGATE ST11200N        930000053770 Copyright (c) 1993 Seagate All rights reserved 0000
ok
```

We can. Let's [set up the NVRAM](http://www.obsolyte.com/sunFAQ/faq_nvram.html) and try and boot it. Type 0x55 is correct for a SPARCstation 2.

```text
ok 01 00 mkp
ok 55 1 mkp
ok 08 02 mkp
ok 00 03 mkp
ok 20 04 mkp
ok c0 05 mkp
ok ff 06 mkp
ok ee 07 mkp
ok 00 08 mkp
ok 00 09 mkp
ok 00 0a mkp
ok 00 0b mkp
ok c0 0c mkp
ok ff 0d mkp
ok ee 0e mkp
ok 0 f 0 do i idprom@ xor loop f mkp
ok boot disk
Boot device: /sbus/esp@0,800000/sd@3,0   File and args: 
bootblk: can't find the boot program
Program terminated
```

Let's try the other disk.

```text
ok boot /sbus/esp@0,800000/sd@4,0
Setting Segment Map
Setting RAM Parity Mode
 Mode set to 36-bit
Sizing Memory
Mapping ROM
Mapping RAM
Probing /sbus@1,f8000000 at 0,0  dma␀ esp␀ sd␀ st␀ le␀ 
Probing /sbus@1,f8000000 at 1,0  Nothing there
Probing /sbus@1,f8000000 at 2,0  Nothing there
Probing /sbus@1,f8000000 at 3,0  Nothing there
screen not found.
Can't open input device.
SPARCstation 2, No Keyboard
ROM Rev. 2.4.1, 64 MB memory installed, Serial #12648430.
Ethernet address 8:0:20:c0:ff:ee, Host ID: 55c0ffee.


Rebooting with command: /sbus/esp@0,800000/sd@4,0                
Boot device: /sbus/esp@0,800000/sd@4,0   File and args: 
root on /sbus/esp@0,800000/sd@4,0 fstype 4.2
Boot: vmunix
Size: 1359872+427120+140304 bytes
Instruction Access Exception
Type  help  for more information
ok 
```

So close! Let's try Solaris 7 from an external BlueSCSI. At this point I typed `reset` and then had to wait another 15 minutes for the memory test to complete.

```text
ok boot cdrom
Boot device: /sbus/esp@0,800000/sd@6,0:c   File and args: 
SunOS Release 5.7 Version Generic_106541-08 [UNIX(R) System V Release 4.0]
Copyright (c) 1983-1999, Sun Microsystems, Inc.
WARNING: Time-of-day chip had incorrect date; check and reset.
Configuring /dev and /devices
le0: No carrier - transceiver cable problem?
le0: No carrier - transceiver cable problem?
le0: No carrier - transceiver cable problem?
le0: No carrier - transceiver cable problem?
le0: No carrier - transceiver cable problem?
The system is coming up.  Please wait.

Select a Language

 0) English                                                                  
 1) German                                                                   
 2) Spanish                                                                  
 3) French                                                                   
 4) Italian                                                                  
 5) Swedish                                                                  

?
```

Yeah!

## MORSE SPARCstation 2

The second SPARCstation 2 has a MORSE sticker on it. I have no idea what that is. It also has a wonky foot that seems to have come off and been stuck back on at 45 degrees.

{{ image(img="blog/blog-2025-08-20/morse-ss2.jpg") }}

This one also starts up. It has 32 MiB of RAM so POST merely takes an *age* as opposed to *eons*.

```text
WARNING: Unable to determine keyboard type
    WARNING: TOD Oscillator NOT Running, Kickstart in Progress ... Incorrect c
onfiguration checksum;
Setting NVRAM parameters to default values.
Setting diag-switch? NVRAM parameter to true
Probing /sbus@1,f8000000 at 0,0  dma esp sd st le
Probing /sbus@1,f8000000 at 1,0  Nothing there
Probing /sbus@1,f8000000 at 2,0  le
Probing /sbus@1,f8000000 at 3,0  Nothing there
screen not found.
Can't open input device.
SPARCstation 2, No Keyboard
ROM Rev. 2.4.1, 32 MB memory installed, Serial #16777215.
Ethernet address ff:ff:ff:ff:ff:ff, Host ID: ffffffff.


The IDPROM contents are invalid

Testing  32 megs of memory. Still to go    0
Type b (boot), c (continue), or n (new command mode)
>n
Type  help  for more information
```

The NVRAM set-up is as before. Do the disks appear? They are very quiet.

```
ok probe-scsi
Target 1 
  Unit 0   Disk     SEAGATE ST11200N SUN1.05950000000000Copyright (c) 1993 Seagate All rights reserved 0000
Target 3 
  Unit 0   Disk     MAXTOR  LXT-535S        8.74
ok boot disk
Boot device: /sbus/esp@0,800000/sd@3,0   File and args: 
```

That just hangs - I guess the disks are no good. But it boots from BlueSCSI:

```text
ok boot cdrom
Boot device: /sbus/esp@0,800000/sd@6,0:c   File and args: 
SunOS Release 5.7 Version Generic_106541-08 [UNIX(R) System V Release 4.0]
Copyright (c) 1983-1999, Sun Microsystems, Inc.
```

Excellent. That's enough for now.

## Wrapping up

OK, I've got an SS10, two SS5s and three SS20s left to try - and the SS20s are missing CPU cards and RAM. Lets look at those next time.

