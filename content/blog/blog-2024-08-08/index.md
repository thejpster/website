+++
title = "RP2350 Launch Blog"
date = "2024-08-08"
+++

## Intro

Today sees the announcement of the latest additions to Raspberry Pi's microcontroller line-up - the RP2350 family. I've had prototype units for a while, and you can run Rust code on it today. To my knowledge this is the first ever microcontroller launch with Rust support out-of-the-box.

If you haven't seen the specs elsewhere, let me catch you up:

|                                   |             RP2040              |                              RP235x                              |
| ---------------------------------:|:-------------------------------:|:----------------------------------------------------------------:|
|                     **Main CPUs** |   2x Arm Cortex-M0+ (Armv6-M)   |              2x Arm [Cortex-M33] with FPU (Armv8-M)              |
|                **Alternate CPUs** |              None               |                  2x [Hazard3] (RISC-V RV32IMAC)                  |
|       **Atomic Compare-and-Swap** |               No                |                    Yes (Arm and RISC-V modes)                    |
| **Double-Precision Float Co-Pro** |               No                |                       Yes (Arm mode only)                        |
|                 **Nominal Clock** |             133 MHz             |                             150 MHz                              |
|                  **On-chip SRAM** |             264 KiB             |                             520 KiB                              |
|                **Internal Flash** |              None               |            Either None (RP2350x), or 2 MiB (RP2354x)             |
|                  **Internal OTP** |              None               |     64 pages of 64x 24-bit words (readable as 16-bit + ECC)      |
|                   **Secure Boot** |               No                |                               Yes                                |
|               **External Memory** | 1x QSPI Flash (16&nbsp;MiB max) |        2x QSPI Flash and/or PSRAM (16&nbsp;MiB max each)         |
|              **Flash Partitions** |          Not Supported          |         ROM supports up to 16, with address translation          |
|           **Address Translation** |              None               | Four 4 MiB windows per chip-select, mappable to any 4 KiB offset |
|                         **GPIOs** |            30x 3.3V             |                    30x (xA) or 48x (xB) 3.3V                     |
|                    **PIO Blocks** |                2                |                                3                                 |
|                  **PWM Channels** |               16                |                                24                                |
|                  **ADC Channels** |                4                |                         4 (xA) or 8 (xB)                         |
|                    **DVI Output** | In Software (with 2x overclock) |   Hardware TMDS Encoder & High-Speed Double-Pumped Serialiser    |
|                    **USB Device** |       USB 1.1 Full-Speed        |                        USB 1.1 Full-Speed                        |
|                      **USB Host** |     USB 1.1 Low-/Full-Speed     |                     USB 1.1 Low-/Full-Speed                      |
|                 **Sleep Current** |             180 μA              |                          Down to 10 μA                           |

[Cortex-M33]: https://developer.arm.com/Processors/Cortex-M33
[Hazard3]: https://github.com/Wren6991/Hazard3

As you can see, we've got more of just about everything - plus the fact that either (or both) of the [Cortex-M33]s can be swapped out at boot-time or at run-time for an open-source[^1] [Hazard3] RISC-V core instead. To my eyes the only thing that didn't really improve is that we're still stuck with 11 Mbps *Full-Speed* from USB 1.1, rather than getting an upgrade to the 480 Mbps *High-Speed* mode of USB 2.0 - which is a shame. But hey, it's stilll only a dollar!

[^1]: The source Verilog is available at <https://github.com/Wren6991/Hazard3> under an Apache-2.0 license, but obviously you can't have the [RTL](https://en.wikipedia.org/wiki/Register-transfer_level), or any of the non-RISC-V components from the RP235x.

Also! There's no longer a single SKU - instead there are four variants of the RP235x available at launch.

|                    | RP2040 | RP2350A | RP2350B |  RP2354A   |  RP2354B  |
| ------------------:|:------:|:-------:|:-------:|:----------:|:---------:|
|        **Package** | QFN56  |  QFN60  |  QFN80  |   QFN60    |   QFN80   |
| **Internal Flash** |  None  |  None   |  None   | 2&nbsp;MiB | 2&nbsp;MB |
|          **GPIOs** |   30   |   30    |   48    |     30     |    48     |
|       **ADC Pins** |   4    |    4    |    8    |     4      |     8     |

In this blog, where I say *RP235x* I mean any of *RP2350A, RP2350B, RP2354A, or RP2354B*. Where I say *RP2350x* I mean one of the flash-less parts. Where I say *RP235xA* or *xA* I mean any QFN60 RP235x part and for *RP235xB* or *xB* I mean any QFN80 RP235x part.

All RP235x have the same silicon die, so the good news we can largely ignore these when thinking about the software. Even the internal Flash is actually *Flash in Package* and so works just like the external flash. The GPIOs on the 60 pin package are not actually the first 30 GPIOs on the die, due the way the pads are bonded internally, but a remapping function inside the silicon means you can pretend they are the first 30 GPIOs. This is only relevant due to a silicon errata that means the remapping doesn't work from Arm Non-Secure mode, but oh well. Most code will run in Secure Mode anyway.

I was given access to various early revisions of the RP2350A, fitted to a pre-production Raspberry Pi Pico 2.

## But does it run Rust?

Of course you can compile Rust code for it. For the Arm [Cortex-M33] cores, use `thumbv8m.main-none-eabihf`. For the [Hazard3] RV32IMAC cores use `riscv32imac-unknown-none-elf`. I've tried both and had no issues from a compiler point of view.

My experimental HAL is at <https://github.com/thejpster/rp-hal-rp2350-public>. As of today, that repo is public, but archived. I hope the changes will be taken upstream at <https://github.com/rp-rs>, but I'm about to go on vacation, so I won't be sending the PR. Plus there are some outstanding questions that I want the community to weigh in on:

* Should it be in the same repo, or a different repo as the RP2040 HAL?
* Can you write a common driver for both RP2040 and RP2350, e.g. for the UART, when the chips have different PAC crates and hence different PAC UART types?
* How much work should we put into making it easy to write an application that compiles for either RP2040 or RP2350?
* Should the examples be moved out of the HAL repo, because some of them don't compile for RISC-V and that makes the CI pipeline tricky?
* How do you write a RISC-V interrupt handler, to provide RISC-V RP2350 code with the same `#[interrupt]` macro that Arm RP2350 code gets to enjoy?
* Who's going to be first to blow the SECURE_MODE OTP bit and see if we can boot signed Rust firmware on this thing?

**Edit:** OK so a few months later I've come back here to a) fix some typos in the examples, and b) let you know that RP2350 HAL support is now available at <https://github.com/rp-rs/rp-hal> so you should go and use that version instead. Not much has changed, but there are probably some useful bug fixes.

## Never mind the details, show me the demo

I have ported the <https://github.com/rp-rs> HAL to RP235x, along with a few of the examples:

```bash=
rustup target add thumbv8m.main-none-eabihf
rustup target add riscv32imac-unknown-none-elf
git clone https://github.com/thejpster/rp-hal-rp2350-public
cd rp-hal-rp2350-public/rp235x-hal
# It builds for Arm
cargo build --example pwm_blink --target thumbv8m.main-none-eabihf --all-features
picotool load -t elf ./target/thumbv8m.main-none-eabihf/debug/pwm_blink
# Some examples (the ones without interrupts) also build for RISC-V!
cargo build --example pwm_blink --target riscv32imac-unknown-none-elf --all-features
picotool load -t elf ./target/riscv32imac-unknown-none-elf/debug/pwm_blink
```

You will need to follow Raspberry Pi's instructions on how to compile `picotool` using their Pico SDK. Unfortunately, the standard Rust tools like `probe-rs` won't work with the RP2350 until someone adds Arm Debug Interface v6 support, which is highly non-trivial (and well beyond my skills).

## A recap of Rust on the RP2040

The RP2040 has two Arm Cortex-M0+ CPUs, and so the appropriate Rust target is `thumbv6m-none-eabi`.

There are two independent implementations of a Rust stack for the RP2040:

* `rp2040-hal` from <https://github.com/rp-rs>
* `embassy-rp` from <https://github.com/embassy-rs>

The `rp2040-hal` is the one I have worked on, but I hear good things about `embassy-rp` too - especially if you are looking to write Async Rust for your RP2040. Both will let you write Rust code for your RP2040, and use all the integrated peripherals with nice high-level drivers.

## What works today in Rust

The RP235x has two Arm Cortex-M33 CPUs, and so the appropriate Rust target for Arm mode is `thumbv8m.main-none-eabihf`. The appropriate target for RISC-V mode is `riscv32imac-unknown-none-elf`.

So far I have:

* Tested these examples on production silicon in Arm mode **and** RISC-V mode:
    * [*ADC*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/adc.rs)
    * [*ADC FIFO DMA*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/adc_fifo_dma.rs)
    * [*ADC FIFO Poll*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/adc_fifo_poll.rs)
    * [*Alloc*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/alloc.rs)
    * [*Architecture Flip*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/arch_flip.rs)
    * [*Binary Info*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/binary_info_demo.rs)
    * [*Blinky*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/blinky.rs)
    * [*Block Loop*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/block_loop.rs)
    * [*PIO Blink*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/pio_blink.rs)
    * [*PIO DMA*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/pio_dma.rs)
    * [*PIO Proc-Macro Blink*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/pio_proc_blink.rs)
    * [*PIO Side-Set*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/pio_side_set.rs)
    * [*PWM Blinky*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/pwm_blink.rs)
    * [*ROM Funcs*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/rom_funcs.rs) (with added OTP output)
    * [*UART*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/uart.rs)
    * [*UART DMA*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/uart_dma.rs)
    * [*USB Serial*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/usb.rs)
* Tested these examples on production silicon in Arm mode only:
    * [*Multicore FIFO Blink*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/multicore_fifo_blink.rs)
    * [*Float Test*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/float_test.rs) (new for RP235x, with DCP support)
    * [*POWMAN Test*](https://github.com/thejpster/rp-hal-rp2350-public/blob/main/rp235x-hal/examples/powman_test.rs)
* Run the [Neotron Pico BIOS] and [Neotron OS] on production silicon in Arm mode, with:
    * SD Card support
    * VGA Video (640x480 in 16 colours) using PIO
    * I2S Digital Audio using PIO
    * I2C and SPI
    * 490,752 bytes free SRAM
    * Increased performance, even at the same clock speed, thanks to the bigger CPU core and richer Armv8-M instruction set
* Booted Rust applications from the start of flash, and from inside partitions.

[Neotron Pico BIOS]: https://github.com/neotron-compute/neotron-pico-bios
[Neotron OS]: https://github.com/neotron-compute/neotron-os

These changes are in a fork of the `rp-rs` repositories, [which I am making public today](https://github.com/thejpster/rp-hal-rp2350-public). I can confirm that from an application point of view, few changes are likely to be required. The biggest API change in the HAL is around the removal of the RTC peripheral - the closest functionality is now the `POWMAN` peripheral's Always On Timer with its 64-bit 1ms tick. That and there are now two standard Timer peripherals, so you have to be specific about which one you want to use.

## A recap of booting the RP2040

The RP2040 boots from its internal Mask ROM. This ROM looks for and executes the special 256-byte *boot-block* at the beginning of flash, which reprograms the external flash controller into high-speed QSPI mode before your code boots. It then uses the vector table located right after the boot block (at flash address `0x100`, or memory address `0x1000_0100`) to start your application, just like a 'regular' Arm CPU.

## Booting the RP235x

This was the biggest challenge for me in terms of porting our existing Rust code to run on RP235x, so I want to go into a bit of detail here to help anyone that follows me down this road.

Basically, things are A Bit More Complicated on RP235x:

1. There are two "cores", and each "core" can be in either Arm ([Cortex-M33]) mode or RISC-V ([Hazard3]) mode.
2. This choice is remembered across a core reset.
3. The Arm [Cortex-M33] cores can run code in *Secure Mode* or *Non-Secure Mode*, and peripherals / memory ranges can be locked to only be accessible from *Secure Mode*.
4. The RISC-V [Hazard3] cores can run code in *Machine-mode* or *User-mode*, and peripherals / memory ranges can be locked to only be accessible from *Machine Mode*.
5. The Boot ROM is the first thing a core runs.
6. Therefore there is both a RISC-V ROM and an Armv8-M ROM. Actually I think the RISC-V ROM runs a tiny Arm emulator to execute the Arm version of the code - or at least it used to in earlier versions.
7. The ROM needs to work out where your code is, and whether you want to run Arm code on the [Cortex-M33] or RISC-V code on the [Hazard3].
8. The ROM also handles firmware signing, partition tables, Secure/Non-Secure mode, OTP boot, UART boot, executing from SRAM, etc
9. There's on-chip [One-Time-Programmable Flash](#other-cool-stuff-rom-and-otp) which can affect boot by containing:
    * Hashed Public Keys, for verifying that signing keys are valid,
    * A custom bootloader, or
    * Custom QSPI flash configuration.

On the RP235x, the 256 byte boot block is gone - the ROM can now automatically program the external Flash Controller work with various common kinds of QSPI flash (hurrah!). It has a list of commands and clock dividers to try, but if your flash chip is so weird the ROM can't make it work, you can put your custom flash configuration in OTP.

While the old boot block is gone, you do now need to provide a new data structure called an *Image Definition*, somewhere within the first 4 KiB of your Flash. This *Image Definition* is a specific form of a structure called a *Block*. The *Image Definition* tells the ROM (or other tools) information about your application. *Blocks* must be formed into a closed linked-list called a *Block Loop*. If you have one *Block*, it must point to itself.

```text
┏━━━━━━━━━━━━━━━━━━━┓
┃ 0xffffded3        ┃ The magic 32-bit start value            } Header
┣━━━━━━━━━━━━━━━━━━━┫
┃ Item 0            ┃
┣━━━━━━━━━━━━━━━━━━━┫
┃ ...               ┃
┣━━━━━━━━━━━━━━━━━━━┫
┃ Item N━1          ┃
┣━━━━━━━━━━━━━━━━━━━┫
┃ Num Words         ┃ How many words in this block            }
┣━━━━━━━━━━━━━━━━━━━┫                                         }
┃ Next Block Offset ┃ Relative offset to next block in list   } Footer
┣━━━━━━━━━━━━━━━━━━━┫                                         }
┃ 0xab123579        ┃ The magic 32-bit end value              }
┗━━━━━━━━━━━━━━━━━━━┛
```

Supported items include (but are not limited to):

* `IMAGE_DEF` - Specifying which CPU core and mode the code should run on/in (Arm Secure Mode, Arm Non-Secure Mode or RISC-V)
* `VERSION` - Major/minor version information, and optional roll-back protection
* `HASH_DEF` and `HASH_VALUE` - A Hash of the firmware or *Block*
* `SIGNATURE` - An asymmetric (`secp256k1`) signature of the firmware or *Block*
* `LOAD_MAP` - Whether the code should be executed from Flash, or copied to RAM and executed, or ignored because it contains data and not code
* `VECTOR_TABLE` - Setting a specific location for the interrupt vector table in Arm mode
* `ENTRY_POINT` - Setting a custom Stack Pointer and `_start` function address
* `PARTITION_TABLE` - splitting the flash into *Partitions*

Keeping things simple, I think that the minimum *Image Definition* you need to boot an RP235x is:

```text
┏━━━━━━━━━━━━━━━┓
┃ 0xffff_ded3   ┃ The magic 32-bit start value          } Header
┣━━━━━━━━━━━━━━━┫
┃ 0x1021_0142   ┃ Boot in Arm Secure Mode
┣━━━━━━━━━━━━━━━┫
┃ 0x0000_01ff   ┃ This block was 1 word long            }
┣━━━━━━━━━━━━━━━┫                                       }         
┃ 0x0000_0000   ┃ Offset to next block (points at self) } Footer
┣━━━━━━━━━━━━━━━┫                                       }
┃ 0xab12_3579   ┃ The magic 32-bit end value            }
┗━━━━━━━━━━━━━━━┛
```

These 32-bit values should be stored in little-endian format.

A single block points to itself with an offset of zero, but you might want to add a second *Block* to the end of you flash image, containing a hash or a signature of the image. Indeed, `picotool` can *seal* an ELF file or UF2 file and add such a new *Block* for you, connecting it in to the *Block Loop* that previously only contained the *Image Definition* at the start of flash.

To *seal* a file with a hash, you would do something like:

```bash=
picotool seal \
    --verbose \
    --major 1 --minor 0 \
    --hash \
    ./target/thumbv8m.main-none-eabihf/release/examples/rom_funcs -t elf \
    ./target/rom_funcs_hashed.elf
```

To *seal* a file with a signature (a cryptographically protected hash), you would do something like:

```bash=
# Make an elliptic curve keypair
openssl ecparam -name secp256k1 -genkey -noout -out ec-secp256k1-priv-key.pem

# Sign the binary with the key I just made
picotool seal \
    --verbose \
    --major 1 --minor 0 \
    --sign \
    ./target/thumbv8m.main-none-eabihf/release/examples/rom_funcs -t elf \
    ./target/rom_funcs_signed.elf \
    ./ec-secp256k1-priv-key.pem \
    ./target/rom_funcs_signed_otp.json
```

That second command produces both a signed file, and a JSON list of OTP values that need to be set (which `picotool` can do for you).

These signatures are only checked when the RP235x is in *Secure Boot* mode, and that is controlled by a bit in the OTP. I haven't been brave enough to flip that bit on my one and only Pico 2 board.

In addition to *Image Definitions*, you can also create a *Partition Table*, which is another kind of *Block*. A *Partition Table* can describe up to 16 partitions in Flash, and control whether they are for code or data, whether they are A or B partitions (for OTA upgrade and try-before-you-buy), and whether they are for Arm Secure, Arm Non-Secure, or RISC-V code.

You don't have to hash your *Partition Table* but it's probably a good idea, so your RP235x will never try to use a corrupt partition table. And do note that Secure Mode code can always do whatever it likes and over-ride the partition table, but Non-Secure mode code, and the ROM routines, will obey it, as will `picotool`. At run-time, your current *Partition Table* lives in its own special piece of RAM (up around `0x4000_0000` I think). If you have a *Partition Table* then when you drag-and-drop a UF2 file to the USB Mass Storage interface, it will be written to the appropriate partition automatically, based on the UF2 Family ID.

Let's use `picotool` to add this partition table to a Pico 2:

```json
{
  "version": [1, 0],
  "unpartitioned": {
    "families": ["absolute"],
    "permissions": {
      "secure": "rw",
      "nonsecure": "rw",
      "bootloader": "rw"
    }
  },
  "partitions": [
    {
      "name": "Armageddon",
      "id": 0,
      "size": "2044K",
      "families": ["rp2350-arm-s"],
      "permissions": {
        "secure": "rw",
        "nonsecure": "rw",
        "bootloader": "rw"
      },
      "ignored_during_riscv_boot": true
    },
    {
      "name": "Riscy Business",
      "id": 1,
      "size": "2044K",
      "families": ["rp2350-riscv"],
      "permissions": {
        "secure": "rw",
        "nonsecure": "rw",
        "bootloader": "rw"
      },
      "ignored_during_arm_boot": true
    }
  ]
}
```

```console
$ picotool partition create my-table.json my-table.uf2

$ picotool load -u -v -x my-table.uf2
Loading into Flash: [==============================]  100%

The device was rebooted to start the application.

$ picotool partition info
un-partitioned_space :  S(rw) NSBOOT(rw) NS(rw), uf2 { absolute }
partitions:
  0(A)       00002000->00201000 S(rw) NSBOOT(rw) NS(rw), id=0000000000000000, "Armageddon", uf2 { rp2350-arm-s }, arm_boot 1, riscv_boot 0
  1(A)       00201000->00400000 S(rw) NSBOOT(rw) NS(rw), id=0000000000000001, "Riscy Business", uf2 { rp2350-riscv }, arm_boot 0, riscv_boot 1

$ picotool load -u -v -t elf ./rp-hal-rp2350-public/target/thumbv8m.main-none-eabihf/debug/examples/binary_info_demo
Family id 'rp2350-arm-s' can be downloaded in partition 0:
  00002000->00201000
Loading into Flash: [==============================]  100%
Verifying Flash:    [==============================]  100%
  OK

$ picotool load -u -v -t elf ./rp-hal-rp2350-public/target/riscv32imac-unknown-none-elf/debug/examples/binary_info_demo
Family id 'rp2350-riscv' can be downloaded in partition 1:
  00201000->00400000
Loading into Flash: [==============================]  100%
Verifying Flash:    [==============================]  100%
  OK 

$ picotool info -b -l
Partition 0
 Program Information
  name:          rp235x-hal Binary Info Example
  version:       0.1.0
  web site:      https://github.com/rp-rs/rp-hal
  description:   A GPIO blinky with extra metadata.
  binary start:  0x10000000
  target chip:   RP2350
  image type:    ARM Secure

 Build Information
  pico_board:        pico2
  build attributes:  debug

Partition 1
 Program Information
  name:          rp235x-hal Binary Info Example
  version:       0.1.0
  web site:      https://github.com/rp-rs/rp-hal
  description:   A GPIO blinky with extra metadata.
  binary start:  0x10000000
  target chip:   RP2350
  image type:    RISC-V

 Build Information
  pico_board:        pico2
  build attributes:  debug
```

The flags to `picotool load` are:

* `-u` to update (skip sectors that were already correct)
* `-t elf` to indicate that the file is ELF format, even if it didn't have a `.elf` extension
* `-v` to verify, and
* `-x` to reboot/execute the image we just wrote.

It is important to reboot after writing a new *Partition Table* to ensure it's picked up by the ROM. After that, we wrote two images - one Arm and one RISC-V, and `picotool` put them in the correct partition automatically. If Core 0 is in RISC-V mode at boot-up, the RISC-V image will run, and if Core 0 is in Arm mode, the Arm image will run. You can switch CPU modes with a ROM function call, or with a command like `picotool reboot -c riscv`.

I have a `const fn` in the HAL which can build a hashed *Partition Table* that looks bit-for-bit identical to the one `picotool` produces; this might be useful if you ever want to embed a partition *inside* a binary rather than flashing it separately. You might do that if you are writing a custom bootloader, which scans/verifies/boots the partitions in a different way to how the ROM does it. As if that wasn't enough, the ROM actually allows for *two* *Partition Tables* and/or bootloaders to be defined, using what it calls *Slots*. Normally the first 4K sector of Flash is *Slot 0* and the second 4K sector is *Slot 1*, and *Slot 1* is ignored if *Slot 0* is valid. If you want to do an OTA upgrade involving a different *Partition Table*, you can put the new table in *Slot 1* and tell the ROM to use it on the next reboot. If it works, I think your application is supposed to erase the table in *Slot 0*. You can also use OTP to increase the size of the slots, in case 4K isn't enough (e.g. if you have a custom bootloader).

## A word on Address Translation

You might be wondering how the RP2350 executed an image linked to run from `0x1000_0000`, even though it was written to a partition starting at `0x2000` bytes into the flash chip (which would normally appear at `0x1000_2000` in memory). The answer is Address Translation.

The RP235x lets you access QSPI devices, as the RP2040 does, through a 16 MiB window of address space at `0x1000_0000`. Any reads here are sent to a small cache, and if there is a cache miss, a cache line is loaded from the QSPI chip whilst the read transation is stalled.

The changes for RP235x are:

* There are now two QSPI chip select pins
* There are now two 16 MiB windows, `0x1000_0000` and `0x1100_0000`
* Each QSPI chip-select can be Flash, or PSRAM (so you could have two 16 MiB PSRAM devices for 32 MiB of RAM)
* Each 16 MiB window is now actually four 4 MiB windows
* Each 4 MiB window can be mapped to any address within its associated QSPI chip, on 4 KiB boundaries 

This means you can link you applications to run from `0x1000_0000`, but write them to any 'partition' within the chip. The ROM can read enough metadata from your *Partition Table* and application *Image Definition* to set-up the address translation so the application appears to be running from `0x1000_0000` despite not being at the start of the chip.

Further, I think this enough to implement a multi-process UNIX:

* Put a flash chip on CS0 and a SRAM on CS1
* Put the kernel in a flash partition, linked with `.text` and `.rodata` at `0x10C0_0000` (which is the top 4 MiB window for CS0) and `.data` and `.bss` at `0x2000_0000` (which is the internal SRAM).
* Put various applications in other flash partitions, each linked with `.text` and `.rodata` at `0x1000_0000`, and with `.data` and `.bss` at `0x1100_0000`.
* When you start a process, allocate a chunk of PSRAM and make a note of it. Also copy/init `.data` and `.bss` as required.
* When the kernel switches to a process, set up the translation registers (and flush the relevant QSPI cache lines, sadly) for that specific application for both the flash (at `0x1040_0000`) and the PSRAM you allocated (at `0x11000_0000`).
* You can either use software interrupts to enter the kernel, or use a *vDSO* style mechanism either in internal SRAM, or in a permanently mapped window on CS1 (maybe `0x11C0_0000`).
* You'd use the internal SRAM for kernel stuff, as it's faster, and it cannot be address translated - it always lives at `0x2000_0000`.

Note though that this is not enough to run full *Linux*, as the RP235x cannot do page faults, and you only have four memory mapped windows per chip-select. You'd have to run *uCLinux*, and that [runs on the STM32 already](https://github.com/torvalds/linux/blob/master/arch/arm/configs/stm32_defconfig) so you could port it to RP235x even without the Address Translation stuff.

## Other cool stuff - ROM and OTP

The OTP (One-Time Programmable memory) is organised as 64 pages, each with 64 words. You can read each word through one base address, and have the hardware apply ECC correction to the data, giving you 16 error-corrected bits. The error-correction value obviously depends on all of the 16 data bits, and so these words are *write-once*, but are highly reliable.

You can also read each word through a different base address, and get access to the raw 24-bits. This is useful when the word is designed to be modified at various points in the chip's life, by pushing specific bits from a `0` to a `1`. When a word is used in this fashion, it will typically contain multiple copies of the data internally (maybe three 8-bit values), or the same data will be written to multiple OTP words so a majority vote can be taken.

The ROM reads specified words from OTP on startup, such as:

* Whether OTP contains a secure bootloader and where that code should be copied to in RAM before executing it
    * If all your code fits in OTP, you could have a flashless RP2350x
    * Or you could a have a flashless RP2350x by injecting code at boot using the ROM UART bootloader that runs on the QSPI pins
* Results from factory test, including:
  * A 64-bit 'public' unique ID (you can fetch it from the USB bootloader).
  * A 128-bit 'private' unique key (you can't fetch it from the USB bootloader).
* Flags indicating where to boot from (OTP, Flash, etc), and whether Secure Boot is enabled
* The version number of the most recently installed application (for roll-back protection)
* Whether the USB Bootloader should blink an LED, and which GPIO it is on.
    * This doesn't work on QFN60 devices due to a silicon errata.
* SHA-256 hashes of up to 3 `secp256k1` boot keys (actual `secp256k1` keys are stored in flash with the application - these are just hashes for verifying that the key is valid)
* Six 128-bit OTP access keys, that can be used to restrict subsequent access to OTP
* Whether the ROM should pause a moment on start-up to attempt to detect a 'double tap' on the nRST/RUN pin - this will cause the chip to enter the USB bootloader automatically, without needing to hold the BOOT0 button

## Is the Flash encrypted?

No. If you want to encrypt your application you'll need to put a bootloader in OTP that verifies the application in Flash and then decrypts it into the 520 KiB internal SRAM and executes it from there. Or actually, the ROM might have this functionality built-in? But either way, the only safe place to execute *secure* code is from the internal SRAM. Or *maybe* using one of the flash-in-package RP2354x models - I guess it depends on your threat model.

## Sparking DVI output - HSTX and TMDS

The High Speed Transmitter (HSTX) can generate valid DVI-D video signals, using a hardware TMDS (*transition-minimised-differential-signalling*) 8:10 encoder. It has RLE support, flexible colour-depth conversion (converting between 1 and 16 bpp to 3x8-bpp, using programmable shifts and masks), and runs the outputs at 2x its input clock. This means you can produce crisp 24-bit colour at 640x480@60Hz, storing just, say, 4-bpp in RAM, and using a sensible 126 MHz HSTX clock on the second PLL. The only limitation is you must use GPIOs 12 to 19, and the maximum HSTX is 150 MHz (for 300 million bits per second per pin) - so no 800x600 as far as I can tell.

The SIO block also contains an additional separate TMDS encoder. This might be useful for sending TMDS encoded data over GPIO pins that the HSTX isn't routed to, at the expense of a bit more CPU time required to move the data about.

Both handle TMDS DC-offset balancing even if you want to do pixel-doubling (for, say, running Doom at 320x400).

## Fast(-ish) f64 calculations on the DCP

The [Cortex-M33] has a single-precision (`f32`) FPU - that's all Arm offer. To improve performance for `f64` operations, Raspberry Pi have designed and fitted a *Double-precision Co-Processor* (or *DCP*). This is much smaller than a regular FPU, and it cannot execute Arm double-precision FPU instructions. It can, however, handle a 64-bit load or store every clock cycle, and it can compute some of the funamental building blocks of a software-floating-point implementation much faster than the [Cortex-M33] could run the equivalent integer instructions. 

To use the DCP you must set up the 64-bit X and Y registers with two `mrrc` instructions to copy two 32-bit registers to one 64-bit register in Co-Processor 4. You then perform various operations on those registers using `cpd` instructions, and finally read out your result using an `mcrr` instruction to read back a 64-bit Co-Processor register into two 32-bit Arm registers. Raspberry Pi provide some heavily macro'd assembly code to do this, and I have reverse engineered the macros and written the equivalent assembly code in a `global_asm!` block within the HAL. Currently I have implemented `__aeabi_dadd` for adding two `f64s` and `__aeabi_dmul` for multipling two `f64s`. Hopefully it's then obvious how you might implement `__aeavi_ddiv` or various other operations. The functions are available in `hal::dcp`, or you can use them to replace the default software implementations in compiler-builtins by enabling the feature `dcp-fast-f64`.

### Benchmarks

Running the `float_test` example with `thumbv8m.main-none-eabi` or `thumbv8m.main-none-eabihf` targets gives us these results, averaged over 1000 iterations of a loop containing `state = state <OP> constant`.

| Datatype | Operation | Engine          | Mean no. Clock Cycles |
| -------- | :-------- | --------------- | --------------------: |
| `f64`    | Add       | Software        |                 150.0 |
| `f64`    | Add       | DCP-accelerated |                  23.8 |
| `f64`    | Multiply  | Software        |                 117.0 |
| `f64`    | Multiply  | DCP-accelerated |                  41.0 |
| `f32`    | Add       | Software        |                  87.5 |
| `f32`    | Add       | FPU             |                   3.4 |
| `f32`    | Multiply  | Software        |                  75.6 |
| `f32`    | Multiply  | FPU             |                   3.4 |

__NB:___ Calling the functions in the `hal::dcp` module is slower than letting LLVM lower the operation to a call to `__aeabi_XXX` which I think is because of differences in calling-convention; the functions in `hal::dcp` have to do a `D0` to `R0, R1` copy, then call the assembly code, and then copy the value back into `D0`, but the `__aeabi_XXX` functions have the `aapcs` calling convention and so values turn up in the correct registers).

## Where did the RTC go?

The Real Time Clock has gone. Instead, the POWMAN peripheral has a 1ms-resolution *Always-On Timer* which remains running even when the rest of the chip is asleep. You can run it off the internal Low Power Oscillator (which I measured to be about 6% fast in its untrimmed state on my specific example), or from the Crystal Oscillator, or from an external 1 Hz or 1 kHz square wave. It has an alarm function to bring the chip out of sleep too.

What it doesn't have, is any idea what days or months are. If you want to have a Gregorian Calendar on your RP235x, you'll need a software library like [chrono](https://crates.io/crates/chrono).

## What doesn't work today in Rust

* The new HSTX peripheral (for DVI output)
* The SIO's standalone TMDS Encoder
* The SHA256 engine
* Using the new `POWMAN` peripheral to enter deep-sleep states
* Writing to OTP
* Programming with [`probe-rs`](https://probe.rs)
    * The RP235x uses Arm Debug Interface v6, which isn't yet supported in `probe-rs` - people are looking at it!
* Interrupts in RISC-V mode
    * We need a driver for the Hazard3's `Xh3irq` peripheral (similar to the Arm NVIC)
    * The `cortex-m-rt` crate and the `risc-v-rt` crate define interrupts in different ways
* Probably a bunch of other stuff

This is not a challenge, it's an opportunity!

## Final Thoughts

The RP235x family is a deeply impressive. Being able to freely switch between Arm and RISC-V modes is completely unique and offers fascinating opportunities for experimentation. Carrying over the peripherals from RP2040 means it's easy to get started, and having advanced flash partition support, OTP and Secure Boot means production-grade applications can be much more robust than on RP2040. All this, and it's the same price as the old one.
