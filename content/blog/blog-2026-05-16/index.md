+++
title = "Finding the Time Part 1 - AArch32"
date = "2026-05-16"
+++

## Intro

I've recently been spending quite a bit of time working on Rust support for legacy 32-bit ARM architectures. Not in the compiler - that work was done in LLVM long ago, and `rustc` can just take advantage of it - and not in the standard library - because these are bare metal targets that only use `core`, and `core` is largely architecture agnostic.

No, what I've been working on is the run-time library [`aarch32-rt`], and the CPU support library [`aarch32-cpu`]. The run-time handles the transition from reset, to running your `fn main()` written in Rust, and the CPU library provides APIs for things like, turning interrupts on, or reading the System Control Register (`SCTLR`). On top of that, I've been writing a bunch of examples to check that those crates work correctly. We have examples for:

* Programming an ARM Generic Interrupt Controller v3 compatible interrupt controller and handling nested interrupts
* Dealing with Undefined Exceptions, Syscalls, Hypercalls and various other kinds of ARM exception
* Running code on two processors, with SMP
* Running in EL2 (i.e. Hypervisor Mode) on ARM processors that support that
* More besides

You can see all the code in the [rust-embedded/aarch32] repository on Github.

[`aarch32-rt`]: https://crates.io/crates/aarch32-rt
[`aarch32-cpu`]: https://crates.io/crates/aarch32-cpu
[rust-embedded/aarch32]: https://github.com/rust-embedded/aarch32/tree/main/examples

## Kinds of ARM

Just to catch everyone up, it's probably worth a quick note explaining why these crates needed to exist, when Rust already works so well on a variety of ARM systems. Broadly speaking, there are five kinds of ARM system.

### The Early Years

The Acorn RISC Machine (ARM) was first introduced in 1985 [as a co-processor for the Acorn BBC Microcomputer](https://en.wikipedia.org/wiki/Acorn_Computers#New_RISC_architecture), using a entirely new 32-bit RISC architecture designed in-house at Acorn. In this design, every instruction was exactly 32-bits in size, meaning that with a 32-bit wide data bus, it could load one complete instruction every time it read from memory. However, the processor only hd a 26-bit address bus. This allowed them to use the unused 8 bits[^1] in the Program Counter register to hold various processor status flags. This is genius - you can save the PC and the CPSR in a single 32-bit write to memory, but also proved to be a problem once they wanted have use than 64 MiB of address space. But, it was enough for the Acorn Archimedes range of machines, which all shipped with various ARM processors using 26-bit addressing, implementing version 2 of the ARM Architecture.

[^1]: I invite you to think about why a 32-bit register holding a 26-bit memory address has 8 spare bits rather than six. Perhaps think about whether a 32-bit instruction can ever live at a memory address that is an odd number.

Incidentally, the ARM Architecture is defined in a documented called the [ARM Architecture Reference Manual](https://psx.arthus.net/sdk/Psy-Q/DOCS/Devrefs/armref.pdf). Now, as ARM the processor technology was spun out from Acorn into ARM the company, that means this document is officially called the ARM ARM ARM (although I guess now the organisation has a trendy lower-case name and the processor architecture no longer stands for Acorn RISC Machine, it's the *arm Arm ARM*).

### 32-bit Addressing

ARM Architecture Version 3 (ARMv3) gave the architecture full 32-bit addressing, at the expense of having to move the CPSR out of the PC, and breaking compatibility with all existing 26-bit applications. The Acorn RiscPC initially shipped with an ARM610 running at 30 MHz, implementing ARMv3, but it mostly ran in 26-bit compatible mode. However if you install RISC OS 4 or newer, [or boot Linux](@/blog/blog-2025-12-02/index.md), it will run in 32-bit mode.

ARMv4 was the first version of the architecture to be implemented outside of ARM - it was licensed by Digital Equipment Corporation (DEC) to use in their StrongARM processor. At 233 MHz processor was so fast, it was purchased by Acorn for use in the final versions of the Acorn RiscPC. Swapping out a 30 MHz ARM610 for a 233 MHz StrongARM must be quite the speed bump.

At later change to ARMv4 introduced a smaller version of the ARM instruction set. It was noted that most instructions didn't need the full 32-bits and, if you were to have an instruction set that only had 16-bit instructions, it would allow you to build an ARM system with a 16-bit wide data bus, making it much cheaper but still keeping the performance acceptable.

The small version of the ARM instruction set is the THUMB instruction set.

Because a thumb is a smaller version of an arm.

What else did you expect from the people who knowingly named a document the ARM ARM ARM?

The THUMB instruction set was added in ARMv4T and all ARM processors from then on supported both instruction sets. Indeed, you can switch between instructions sets on a per-function basis - an ARM function can call a THUMB function which can call an ARM function. Because ARM instructions all live at addresses that are a multiple of four[^2], and all THUMB instructions live at an address that is a multiple of 2, the least significant bit of the Program Counter is always unused told the processor whether it was in THUMB Mode or ARM Mode. This addition did involve the dropping of 26-bit compatibility mode though.

[^2]: Does this help you with the previous footnote?

ARMv4T is the oldest version of the ARM architecture supported by Rust. You can use the `armv4t-none-eabi` and `thumbv4t-none-eabi` targets to run bare-metal code on it, and this is supported by [`aarch32-rt`] and [`aarch32-cpu`]. The choice of target basically only decides which instruction set the compiler will produce by default - using the `#[instruction_set(arm::a32)]` or `#[instruction_set(arm::t32)]` attribute, you can compile individual functions with the 'other' instruction set.

[`armv4t-none-eabi`]:  https://doc.rust-lang.org/rustc/platform-support/armv4t-none-eabi.html

ARMv5TE is the next major revision of the architecture (I think there was an ARMv5T, without the E, but I'm skipping it). The E standards for Enhanced, and indicates that additional instructions are now available, but it is fully ARMv4T compatible. It is supported for bare-metal developing in Rust using the [`armv5te-none-eabi`] and `thumbv5te-none-eabi` targets.

[`armv5te-none-eabi`]: https://doc.rust-lang.org/rustc/platform-support/armv5te-none-eabi.html

ARMv6 is the final revision of what I'm calling the *legacy* ARM architectures, and it's again fully ARMv5TE compatible. There were a couple of minor revisions, worth noting. The first is ARMv6T2, which introduces a bunch of new instructions to Thumb mode - known as Thumb-2 (thankfully dropping the ALL-CAPS). This means you can now get almost all of your program written in Thumb-2, reducing the number of times you need to drop back to ARM mode. But perhaps the most useful update which was ARMv6K (which was a super-set of ARMv6T2). This added SMP support, along with the memory barrier instructions and exclusive load-store instructions that Rust needs to implement the full set of [`core::sync::atomic`] APIs. The [`armv6-none-eabi`] target and `thumbv6-none-eabi` targets assume ARMv6K as a minimum, so if you have a rare ARMv6 processor that doesn't implement ARMv6K, use the ARMv5TE target. There is also an  `armv6-none-eabihf` target, which assumes the use of an FPU, and uses it to pass `f32` and `f64` variables across function calls.

[`core::sync::atomic`]: https://doc.rust-lang.org/stable/core/sync/atomic/index.html
[`armv6-none-eabi`]: https://doc.rust-lang.org/rustc/platform-support/armv6-none-eabi.html

For ARMv7, the architecture was split three ways. This is also the point at which I'm going to switch from the traditional spelling of ARM to the modern spelling of Arm.

### Application Profile

The Armv7-A architecture is the *Application-profile* of Armv7. In this profile, the Memory Management Unit is mandatory, and so this is the architecture designed to run Linux, Android, Apple iOS, Windows CE, and so on. I belive the floating point unit is mandatory, but you might want to avoid using it if you're writing a kernel and don't want the pain of stacking all the floating point registers when switching kernel threads. If you're programming these systems bare-metal then, OK, that's a certainly a choice (perhaps you are writing a bootloader, or a kernel). You will want the [`armv7a-none-eabi`] target, and friends;

[`armv7a-none-eabi`]: https://doc.rust-lang.org/rustc/platform-support/armv7a-none-eabi.html

The Armv7-A architecture was followed with Armv8-A. This introduced a third mode of operation - a 64-bit mode mode called AArch64. The previous two modes became known as A32 and T32, or collectively called AArch32. More revisions have followed, and we're now on Armv9.2-A or something.

### Real-time Profile

The Armv7-R architecture is the *real-time profile* of Armv7. It has some of the new instructions of Armv7, but the MMU is not available. This is the architecture used by vehicle ECUs, or the chip on the back of your hard disk drive. As with Armv8-A, Armv8-R adds both an optional 64-bit mode. Unlike Application-profile architctures, here your processor is *either* AArch64 or AArch32 - there are none that do both, because backwards compatibility is less of an issue for an embedded system. You can program these systems with the [`armv7r-none-eabi`], `armv7r-none-eabihf` and `armv8r-none-eabihf` targets, and their Thumb equivalents.

[`armv7r-none-eabi]: https://doc.rust-lang.org/rustc/platform-support/armv7r-none-eabi.html

### Microcontroller Profile

The Armv7-M architecture was a big revision - out went the old Arm exception vector table they'd had since 1985, and in came a new vector table that also supported vectored interrupts - as standard! They also threw out Arm (A32) mode, leaving only Thumb (T32) mode, and they included a standard timer peripheral, called the SYSTICK. Just to keep you on your toes, they also made a smaller version of Armv7-M which they called Armv6-M, and two v8 versions: Armv8-M Baseline (which is only Armv6-M compatible, in the name of making the chips smaller), and Armv8-M Mainline (which is Armv7-M fully compatible).

## So what is AArch32?

I use the term AArch32 in my libraries to mean:

* ARMv4T, as used in the ARM7TDMI
* ARMv5TE, as used in the ARM926
* ARMv6K, as used in the ARM11576JZ(F)-S
* ARMv7-A, as used in the Arm Cortex-A8
* ARMv8-A in AArch32 mode, as used in the Arm Cortex-A53
* ARMv7-R, as used in the Arm Cortex-R5
* ARMv8-R in AArch32 mode, as used in the Arm Cortex-R52

These architectures all work in fundementally the same way, with the same exception table, the same kind of reset function, the same processor registers, and so on. There's some differences, as you would expect with at least 20 years of evolution of an architecture, but it's easy enough to cover them with the same library.

## OK, but about that time thing

Right, sorry. What you need to know is that most embedded Rust code has been written for microcontrollers that use the Cortex-M line of processors that implement the Arm Microcontroller profile - Armv6-M, Armv7-M, Armv8-M Baseline and Armv8-M Mainline. [Embassy] and [RTIC] both have excellent support for these architectures.

[Embassy]: https://embassy.dev
[RTIC]: https://rtic.rs

But I've been working on the bigger, old, full-fat Arm architecture, and it's not compatible with Armv7-M at all. I mean a lof of the instructions are the same if you're running in Thumb-2 mode, the the exception handlers and the system registers are all completely different.

So, with that all out of the way, next time I want to talk about the Arm Generic Timer, how it's different to the Arm Systick from Armv7-M and friends, and how we can use it to implement async timers for [Embassy] and [RTIC].

