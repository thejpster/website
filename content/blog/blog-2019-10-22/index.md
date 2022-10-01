+++
title = "Making a computer"
date = 2019-10-22
+++

So, the idea with the Monotron was to ask a simple question - how much can we do with a small, cheap, random microcontroller and the Rust Programming Language. The answer, after some significant development effort, was quite a lot:

* 800x600 SVGA video signal, with 8 colours
* 48 x 36 text mode, rendered in real time, with multiple fonts (Code Page 850 and Teletext)
* FAT32 formatted SD Card support
* PS/2 keyboard over UART (because the synchronous PS/2 signals themselves were impossible to process whilst also doing the video)
* An application API, allowing applications to be loaded into the 24 KiB of spare RAM (out of the total of 32 KiB) which can then draw on the screen, read the keyboard, etc
* 3-channel tone generator, with Square Wave, Sawtooth, Sine Wave and White Noise
* Real Time Clock support

That's quite a lot for an £11 dev board, with an 80 MHz microcontroller and 32 KiB of RAM. But ultimately, whilst it's impressive, it's not actually any use as a computer...

So, OK, that was originally the point. It's awfulness was part of the joke - "Hey look what you can do, but totally shouldn't do, in Embedded Rust". But as time went on, I was thinking - maybe I could just ... make it better? Yes, there's value in setting an arbitrary goal and seeing what can be squeezed from it, but, if the goal was arbitrary, couldn't we just reset it a little bit? Take a step back and say, is it possible to build something impressive but also useful?

So this is where the Neotron came from. It's a Monotron 2.0 if you like. The basic components are this:

* A common hardware-abstraction layer that, because of obvious parallels with the original IBM PC design, I'm calling the BIOS.
* A portable operating system, which uses the BIOS to interact with the hardware.
* Loadable applications, which use the operating system APIs to do useful things.
* A standardised API for expansion cards.

This means I can concentrate on the things I enjoy (writing drivers, researching new hardware) whilst being able to share that work across multiple systems. It's a model that not only worked for IBM, but it's what CP/M does and what the Amiga does (albeit the Kickstart 'BIOS' is loaded from floppy disk into RAM by a small ROM image).

I can continue to, and indeed fully intend to, use the Tiva-C Launchpad as my 'base' system. It's a bit like the original IBM PC, with its 16 KiB of RAM and cassette recorder interface. But I also want to get the OS running on more powerful hardware - like the STM32H7. This is a Cortex-M7 clocked at 480 MHz with over 512 KiB of SRAM. With hardware video support (no more bit-banging pixels chewing 80% of my CPU time) this thing should really shift - like using an Amiga 500 instead of a Commodore PET.

I've also been spending a lot of time looking at old interfaces, like SCSI. Primarily this is because I picked up an old Apple Mac LC II, which has SCSI Host Adaptor built in, featuring an external DB25 SCSI-1 port and an internal 50-pin header connected to a noisy old Quantum ProDrive LPS 40 MB hard drive. As the hard drive has 'sticky bump stop syndrome' I've been looking at replacing it with a RaSCSI or an sd2scsi. I've also been trying to find a PC floppy controller I can interface with a microcontroller - most of them are either ISA (which is a lot of pins...) or LPC (fewer pins, but I have questions over the timing requirements on the 33 MHz PCI clock) - as well as PC Parallel Port and IDE (which is just an ISA bus with fewer address pins).

Rather than try and cram all of these interfaces on to one motherboard, which will then take me years to get working correctly and write drivers for, I'd like to take the IBM PC approach of adding a standardised expansion slot. Now, for the PC it was easy enough to take the Intel 8088's 8-bit memory bus and extend it out to a series of slots. When they moved on to the 16-bit 80286, they simply widened the data bus out to 16 bits to match. Now, that's a lot of pins to route on a motherboard, but it's also a lot more pins that your average microcontroller has. Instead, microcontrollers come with high-speed serial interfaces like SPI and I2C.

I2C would lend itself well to being an expansion bus, requiring only two pins for the data, plus an interrupt pin, power and ground. It is, however, relatively slow - most devices topping out at 400 kHz, or just under 50 KiB/sec. SPI operates at higher speeds - up to around 40 MHz or just under 5 MB/sec - but requires a dedicated 'chip select' line per slot. QuadSPI is probably the highest performance bus available on a basic microcontroller, giving just under 20 MiB/sec from a 40 MHz bus - more than enough compared to the roughly 2 MiB/sec you can expect from a 16-bit ISA bus.

So where next? Well, first of all I'm working on a [Neotron Book](https://github.com/neotron-compute/neotron-book). Then I'm going to look at splitting the Monotron code into a basic BIOS (for a new board based on the Monotron design I'm calling the Neotron-32) and a skeleton OS. I'm then going to implement the BIOS for a second board - probably an STM32F7 Discovery or an STM32H7 Discovery and verify that the OS is indeed portable. I'm also working with [@altsegcat](https://twitter.com/altsegcat) on a much more powerful system - the Neotron-1000 - which has an H7 and an FPGA based video sub-system.

If you've got comments, questions or pull-requests, you can find all my accounts at <keybase.io/thejpster>. Help is greatly appreciated! 

PS: Oh, I totally forgot. I made [Hackaday!](https://hackaday.com/2019/10/05/the-monotron-a-rusty-retrocomputer/) And the comments didn't explode either... 
