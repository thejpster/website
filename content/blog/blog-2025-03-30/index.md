+++
title = "An AlphaStation's SROM"
date = "2025-03-30"
+++

## Background

I have a thing for [weird](@/blog/blog-2024-11-22/index.md) [90's](@/blog/blog-2025-03-22/index.md) RISC workstations running UNIX. So when Rob said "Hey, I have an AlphaStation in the boot of my car ..." obviously it came home with me.

Unfortunately the AlphaStation is dead. The PSU runs (and stays running, unless the case are disconnected in which case it immediately stops running). The voltages look fine. But the two PCI cards in the machine (a 32-bit Matrox Millenium G200 graphics card and a 64-bit LSI Logic SCSI card) are both dead - neither is detected when inserted into my Pentium 3 PC. And half of the RAM in the first DIMM slot gets very hot. So, I suspect something catastrophic has happened somewhere in its lifetime. But, at least I got a 18GB 1.6" SCSI Hard Drive out of it, and a working (ish) 12x SCSI CD-ROM.

{{ youtube(id="162T5lqYqu4") }}

## The AlphaStation 500

This isn't a post about the AlphaStation 500. I'll save that for when (if) I get it working. This is a post about how an AlphaStation 500 boots. But here it is.

{{ image(img="blog/blog-2025-03-30/IMG_0471.JPEG") }}

The AlphaStation 500 is a workstation from Digital, circa 1996. Mine is a 500 MHz model and has an Alpha 21164A processor (aka EV56). And the way it boots is *weird*.

On your common-or-garden PC, there has always been some kind of ROM chip. It holds a piece of firmware known as the BIOS. This ROM chip is available at a well-known location in the processor's address space (remembering that any PC processor boots up in 16-bit, 8088 compatible mode, with a 1 MiB address space, just like an IBM PC 5150) and the processor just starts executing code in it after reset.

The Alpha (or at least this AlphaStation 500 - although I think they mostly worked like this) is different.

## SROM

There is a serial ROM (SROM) on the main board, and after reset, some logic internal to the CPU kicks in to generate a clock pulse. This drives an (external) counter, which provides consecutive addresses into the ROM. The 1-bit output of the ROM is sent into the processor, in sync with the clock pulse. The Alpha processor stores this data in its internal Instruction Cache. Once the code load is complete, the processor then executes the code, from its cache. The code is just enough to get the processor to configure its external memory bus, and find a memory-mapped parallel ROM, which it will then hand-over execution to.

But wait, how do you find a 1-bit wide ROM chip? Aren't most ROM chips at least 8 bits wide? Yes, they are.

## SROM Image selection

The AlphaStation 500 mainboard has a series of eight jumper positions, and you are supposed to fit a jumper to exactly one of them. In fact, if you tried to fit more than one, the machine wouldn't boot.

The SROM chip actually contains eight images multiplexed together - each byte you load from the ROM contains one bit from each of eight images. The jumpers control which of the eight data bits on the ROM is actually connected to the serial input on the processor.

The SROM images on my machine are:

| Jumper | Description          |
| ------ | -------------------- |
| J11    | Power up             |
| J12    | Mini console         |
| J13    | Floppy loader        |
| J14    | Mem test             |
| J15    | N/A                  |
| J16    | N/A                  |
| J17    | MCHK Mini Console    |
| J19    | No init mini console |

So, given I apparently have RAM problems, I should *in theory* be able to move the jumper from J11 to J12, and see some kind of ['Mini console'](https://manx-docs.org/collections/mds-199909/cd1/alpha/amsmduga.pdf) driven entirely by the processor running from internal I-Cache and its 32 internal registers, even with no RAM fitted.

But, I don't. Or at least, if there's a console, I can't find it. I read that it should be on the same pins that are used for loading the SROM into the chip, but I don't see any UART traffic there.

There is *some* SROM source code on The Internet, in a [pack designed for manufacturers making Alpha-based computers](https://github.com/jramstedt/ebsdk) using the OEM AlphaPC mainboards that Digital used to sell. But I don't know if it is anything like what's on my AlphaStation.

Maybe there's a way to look at the SROM code and work out what it should be doing?

## Splitting the SROM

What is in my SROM chip? Well it's an Am27C010 in a PLCC socket, so I pulled it out, popped it into a TL866-II flash programmer and dumped it.

Download it [here](./am27c010_image_alphastation500.bin).

Remember, this is eight streams multiplexed together, so we need to break them apart. This is non-trivial because, if each byte has one bit from the chosen image in it, is the first bit the most-significant bit in a byte, or the least significant bit in a byte?

Because I wasn't sure exactly how this worked, I hacked around in Python and I think I have it right.

```python
f = open("am27c010_image_alphastation500.bin", "rb")
contents = f.read()
for image in range(0, 8):
    count = 0
    acc = 0
    data = []
    for b in contents:
        bit = (b >> image) & 1
        # Loading bits in from the top, so the first bit
        # ends up as the LSB
        acc >>= 1
        acc |= (bit << 7)
        count = count + 1
        if count == 8:
            data.append(acc)
            acc = 0
            count = 0
    o = open(f"srom_{image}.bin", "wb")
    o.truncate()
    o.write(bytes(data))
    o.close()
```

But, now we have eight images and ... none of them contain any ASCII strings, and none of them look like Alpha machine code (as far as `alpha-linux-gnu-objdump` is concerned, anyway).

## Decoding the images

So, I said the SROM data is loaded into I-Cache? Well, it's literally clocked into the cache lines, bit by bit. But not all the cache line is valid data! Some of the cache line bits are parity, and some are metadata recording which address the line is a cached copy of. It's complicated.

Digital actually put a tool in the Alpha PC SDK, called [`srom.c`](https://github.com/jramstedt/ebsdk/blob/main/ebtools/src/common/srom/srom.c). This tool takes some Alpha machine code, and adds all the tag and parity information, giving you an SROM image you can load serially into the chip on start-up. It turns out that on the Alpha 21164 processor, each cache line is 200 bits long. So in this program, for every sixteen bytes (or, four 32-bit instructions) that go in, and 25 bytes (200 bits) come out.

So I just have to find which of the 16 bytes in every block of 25 bytes is the valid data, right?

No.

The cache line is *complicated* and it turns out the incoming 32-bit words are not stored sequentially. In fact, all the *even* bits go to one place and all the *odd* bits to somewhere else. The `srom.c` tool has this handy table:

```c
int dfillmap [128] = {                  /* data 0:127 -- fillmap[0:127]*/
    42,44,46,48,50,52,54,56,            /* 0:7 */
    58,60,62,64,66,68,70,72,            /* 8:15 */
    74,76,78,80,82,84,86,88,            /* 16:23 */
    90,92,94,96,98,100,102,104,         /* 24:31 */
    43,45,47,49,51,53,55,57,            /* 32:39 */
    59,61,63,65,67,69,71,73,            /* 40:47 */
    75,77,79,81,83,85,87,89,            /* 48:55 */
    91,93,95,97,99,101,103,105,         /* 56:63 */
    128,130,132,134,136,138,140,142,    /* 64:71 */
    144,146,148,150,152,154,156,158,    /* 72:79 */
    160,162,164,166,168,170,172,174,    /* 80:87 */
    176,178,180,182,184,186,188,190,    /* 88:95 */
    129,131,133,135,137,139,141,143,    /* 96:103 */
    145,147,149,151,153,155,157,159,    /* 104:111 */
    161,163,165,167,169,171,173,175,    /* 112:119 */
    177,179,181,183,185,187,189,191     /* 120:127 */
};
```

The same table is included as *Appendix C: Serial Icache Load Predecode Values* in the [Alpha 21164 Hardware Reference Manual].

[Alpha 21164 Hardware Reference Manual]: https://www.cs.cmu.edu/afs/cs/academic/class/15740-f03/public/doc/alpha-21164-hw-ref-manual.pdf

So ... what if I wrote a program to use that table to reverse the encoding, turning 25 byte cache lines back into four 32-bit instruction words. Would that work?

I used Rust this time.

```rust
//! Alpha 21164 SROM decoder

use std::io::Write;

fn main() {
    let mut args = std::env::args_os();
    let _ = args.next();
    let infilename = args.next().expect("Need input filename");
    let outfilename = args.next().expect("Need output filename");
    println!("Reading {}", infilename.to_string_lossy());
    let mut data = std::fs::read(infilename).expect("Failed to load file");
    println!("Read {} bytes", data.len());

    let mut outfile = std::fs::File::create(outfilename).expect("Can't open output file");
    outfile.set_len(0).expect("Can't truncate file");

    let remainder = data.len() % 25;
    if remainder != 0 {
        eprintln!("I want a multiple of 25 bytes for 21164 SROM");
    }

    let mut lines = Vec::new();

    while data.len() >= 25 {
        let remainder = data.split_off(25);
        let mut line = Vec::new();
        for word_bytes in data.chunks_exact(4) {
            let word_bytes: [u8; 4] = word_bytes.try_into().unwrap();
            let word: u32 = u32::from_le_bytes(word_bytes);
            line.push(word);
        }
        data = remainder;
        lines.push(line);
    }

    for line in lines {
        for word in line.iter() {
            print!("0x{:08x} ", word);
        }
        print!(" -- ");
        let decoded = process_line(&line);
        for word in decoded.iter() {
            print!("0x{:08x} ", word);
            outfile.write_all(&word.to_le_bytes()).expect("Writing to output");
        }
        println!();

    }
}

static DFILLMAP: [usize; 128] = [
    /* data 0:127 -- fillmap[0:127]*/
    42,  44,  46,  48,  50,  52,  54,  56,  /* 0:7 */
    58,  60,  62,  64,  66,  68,  70,  72,  /* 8:15 */
    74,  76,  78,  80,  82,  84,  86,  88,  /* 16:23 */
    90,  92,  94,  96,  98,  100, 102, 104, /* 24:31 */
    43,  45,  47,  49,  51,  53,  55,  57,  /* 32:39 */
    59,  61,  63,  65,  67,  69,  71,  73,  /* 40:47 */
    75,  77,  79,  81,  83,  85,  87,  89,  /* 48:55 */
    91,  93,  95,  97,  99,  101, 103, 105, /* 56:63 */
    128, 130, 132, 134, 136, 138, 140, 142, /* 64:71 */
    144, 146, 148, 150, 152, 154, 156, 158, /* 72:79 */
    160, 162, 164, 166, 168, 170, 172, 174, /* 80:87 */
    176, 178, 180, 182, 184, 186, 188, 190, /* 88:95 */
    129, 131, 133, 135, 137, 139, 141, 143, /* 96:103 */
    145, 147, 149, 151, 153, 155, 157, 159, /* 104:111 */
    161, 163, 165, 167, 169, 171, 173, 175, /* 112:119 */
    177, 179, 181, 183, 185, 187, 189, 191  /* 120:127 */
];

fn process_line(line: &[u32]) -> [u32; 4] {
    if line.len() != 6 {
        panic!("Only want 6 words per line");
    }
    let mut output = [0u32; 4];
    for (out_idx, &in_idx) in DFILLMAP.iter().enumerate() {
        let in_word = in_idx >> 5;
        let in_offset = in_idx & 0x1F;
        let bit = (line[in_word] >> in_offset) & 1;
        if bit != 0 {
            let out_word = out_idx >> 5;
            let out_offset = out_idx & 0x1F;
            output[out_word] |= 1 << out_offset;
        }
    }
    output
}
```

It turns out the final byte of the 25 is of no use to us, so I load the file 25 bytes at a time, turn it into six 32-bit words, and process it to produce four 32-bit instructions.

Again, this took some trial and error. I had no idea whether the contents of my SROM chip were valid, or what they should look like. So I used the `srom.c` program to encode some random data, and then I used my program to decode it back again, and I verified that the input file and the output files matched. This took some trial and error, but I got something that was at least round-tripping my random example files correctly.

## Dissasmbling the decoded images

Well, let's just throw one of these files at `objdump` and see what happens.

```console
$ alpha-linux-gnu-objdump -b binary -m alpha -D /mnt/c/Users/msn/OneDrive/Shared/computers/digital/srom_0.decoded  | head -n 40

/mnt/c/Users/msn/OneDrive/Shared/computers/digital/srom_0.decoded:     file format binary


Disassembly of section .data:

0000000000000000 <.data>:
       0:        0f 01 ff 77    pal1d   0x3ff010f
       4:        56 01 ff 77    pal1d   0x3ff0156
       8:        57 01 ff 77    pal1d   0x3ff0157
       c:        39 00 40 d3    bsr     ra,0xf4
      10:        47 00 40 d3    bsr     ra,0x130
      14:        2e 01 40 d3    bsr     ra,0x4d0
      18:        56 01 21 64    pal19   0x210156
...
```

OK, er ... is that right? Is that valid Alpha machine code? I think so!

Reading the [Alpha 21164 Hardware Reference Manual] some more, I see that `pal1d` is a generic mnemonic for the Alpha 21164 specific instruction `HW_MTPR`. That is the instruction that store a value from a CPU register *to* an *Internal Processor Register*. The `pal19` instruction, on an Alpha 21164, is `HW_MFPR`, which means to load a value into a CPU register *from* an *Internal Processor Register*. Basically, I think these *IPRs* are like CP15 system registers on an Arm processor. And, one of them is called `SL_XMIT`, which sounds like something that does serial transmit - exactly what I would expect an SROM Mini Console to do.

But, `objdump` doesn't seem to know about these 21164 specifics, so I need to write a tool which takes an assembly file and re-writes the `pal1d` and `pal19` assembly language into something that helps us understand what's going on. I'll just jam the `alpha-linux-gnu-objdump` call into the SROM decoder above, and post-process the output.

I'm also going to [read some Raymond Chen](https://devblogs.microsoft.com/oldnewthing/20170807-00/?p=96766) to try and get a handle on this Alpha assembly code.

OK, here is that machine code again, but with some auto-generated annotations:

```text
0000000000000000 <.data>:
       0:        0f 01 ff 77    pal1d   0x3ff010f ; HW_MTPR: write zero to ICM
       4:        56 01 ff 77    pal1d   0x3ff0156 ; HW_MTPR: write zero to PALtemp22
       8:        57 01 ff 77    pal1d   0x3ff0157 ; HW_MTPR: write zero to PALtemp23
       c:        39 00 40 d3    bsr     ra,0xf4
      10:        47 00 40 d3    bsr     ra,0x130
      14:        2e 01 40 d3    bsr     ra,0x4d0
      18:        56 01 21 64    pal19   0x210156 ; HW_MFPR: read PALtemp22 to t0
```

Right, but what about the serial stuff? Well I see an IPR called `SL_XMIT` which is for transmitting one bit of data, and another called `SL_RCV` for receiving. It seems the CPU basically has to bit-bash a UART using one output pin and one input pin and some delays to ensure the UART is running at the correct baud rate.

After some poking around, I found what looks like a `get_char` function, which I have tried to annotate (although I don't fully understand it):

```text
get_char:
    191c:      05 14 e1 47      mov     0x8,t4 ; we want eight bits
    1920:      04 04 ff 47      clr     t3
    1924:      03 04 ff 47      clr     t2
char_start:
    1928:      17 01 42 64      pal19   0x420117   ; HW_MFPR: read SL_RCV to t1
    192c:      fe ff 5f f4      bne     t1,0x1928 
    1930:      27 00 60 d3      bsr     t12,0x19d0 ; wait for half bit time
get_bit:
    1934:      28 00 60 d3      bsr     t12,0x19d8 ; wait for bit time
    1938:      17 01 42 64      pal19   0x420117   ; HW_MFPR: read SL_RCV to t1
    193c:      82 d6 40 48      srl     t1,0x6,t1  ; put bit in t1<0>
    1940:      22 07 44 48      sll     t1,t3,t1   ; move bit into correct position for byte
    1944:      03 04 43 44      or      t1,t2,t2   ; OR bit into data byte in t2
    1948:      04 34 80 40      addq    t3,0x1,t3  ; increment bit index
    194c:      25 35 a0 40      subq    t4,0x1,t4  ; decrement loop count
    1950:      f8 ff bf f4      bne     t4,0x1934  ; goto get_bit
    1954:      20 00 60 d3      bsr     t12,0x19d8 ; wait for bit time
    1958:      17 01 42 64      pal19   0x420117   ; HW_MFPR: read SL_RCV to t1
    195c:      00 04 7f 44      or      t2,zero,v0 ; copy received byte to v0
    1960:      02 10 10 45      and     t7,0x80,t1 ; 
    1964:      07 00 40 e4      beq     t1,0x1984  ; goto clr_int_and_exit
    1968:      02 18 0b 44      xor     v0,0x58,t1 ; Is it ASCII 'X'?
    196c:      05 00 40 f4      bne     t1,0x1984  ; goto clr_int_and_exit
    1970:      56 01 42 64      pal19   0x420156   ; HW_MFPR: read PALtemp22 to t1
    1974:      02 f6 41 48      zap     t1,0xf,t1  ; zero bottom four bytes of t1
    1978:      08 11 10 45      andnot  t7,0x80,t7 ; ?
    197c:      02 04 02 45      or      t7,t1,t1   ; ?
    1980:      56 01 42 74      pal1d   0x420156   ; HW_MTPR: write t1 to PALtemp22
clr_int_and_exit:
    1984:      01 00 5f 20      lda     t1,1       ; clear interrupt 33
    1988:      22 37 44 48      sll     t1,0x21,t1
    198c:      15 01 42 74      pal1d   0x420115   ; HW_MTPR: write t1 to HWINT_CLR
    1990:      01 80 fe 6b      ret     zero,(sp),0x1
```

So yeah, definitely looks like my SROM is valid, and it can receive stuff over a serial port by waiting for the start bit, then counting out the bit periods one by one.

## Conclusions

Going back to [Alpha 21164 Hardware Reference Manual], I now see the vital piece of information that was there all along if I'd read the document carefully enough:
slonh
> The SROM load occurs at the internal cycle time of approximately 126 CPU cycles for `srom_clk_h`
> ...
> `srom_data_h/Rx` - Receives SROM or serial terminal data
> `srom_clk_h/Tx` - Supplies clock to SROMs or transmits serial terminal data

So I should try and inject TTL UART signals on the same pin that carries the SROM data on start-up, and I should look for TTL UART output on the pin that carries the SROM data clock signal (and with a 500 MHz CPU I should expect a 4 MHz clock signal, and thus need to sample at at least 16 MHz, and ideally 24 MHz).

OK, what have we learned?

* Alpha CPUs boot from a Serial ROM (the SROM)
* That SROM contains eight images packed together
* Each image is encoded ready to be streamed directly into the I-Cache of the Alpha CPU
* We can reverse that encoding and get the raw images back
* Alpha CPUs have special *Internal Processor Registers* which let them do things like control a couple of GPIO pins (and much more)
* The images in my SROM flash chip seem fine, indicating that the chip isn't corrupted
* Sometimes you need to go on a long journey only to end up back where you started, but the knowledge you gained on the way lets you see a better route to take next time
* We still don't know why my Alpha doesn't boot

## Links

* Github with the source code of the tools I wrote: <https://github.com/thejpster/alpha-srom>
* Alpha Motherboard Software Developers Kit V4.0: <https://github.com/jramstedt/ebsdk>
