+++
title = "More Arm Microcontroller Compilation Options in Rust"
date = "2024-10-03"
+++

## Intro

No sooner had I [published the last piece](@/blog/blog-2024-09-29/index.md) than I found something *really cool* that I don't think is that well known.

The Cortex-M33 is an Armv8-M processor - that is, it implements the Microcontroller Profile part of Version 8 of the Arm Architecture Specifcation.

The Cortex-M55 and Cortex-M85 are Armv8.1-M processors, which means they implement Version 8.1. I sort of knew this, but didn't pay any real attention to what it means. But I should have done.

## Branch and Loop Instructions

Armv8.1-M introduces new *Branch and Loop Instructions*. They are listed at <https://developer.arm.com/documentation/101928/0101/The-Cortex-M85-Instruction-Set--Reference-Material/Armv8-1-M-branch-and-loop-instructions/List-of-Armv8-1-M-branch-and-loop-instructions>, but I'll try and explain with some code examples.

## A basic loop

Let's say we want to process some data.

```rust
#[no_mangle]
pub fn double_values(data: &mut [u8]) {
    for item in data.iter_mut() {
        *item = *item * 2;
    }
}
```

Let's compile for Armv8-M Mainline, with `opt-level=s`.

```bash
rustc sample.rs --emit asm --target=thumbv8m.main-none-eabi --edition 2021 --crate-type=rlib -C opt-level=s
cat sample.s | grep -v -e "\s\.[a-z]" -e "^\."
```

We get:

```text,linenos
double_values:
        cbz    r1, .LBB0_2
.LBB0_1:
        ldrb   r2, [r0]
        subs   r1, #1
        lsl.w  r2, r2, #1
        strb   r2, [r0], #1
        bne    .LBB0_1
.LBB0_2:
        bx     lr
```

This is roughly:

* Line 2: If `r1` is zero, leave
* Line 4: Load a byte from a pointer in `r0`, into `r2`
* Line 5: Subtract 1 from `r1`
* Line 6: Double the value in `r2`
* Line 7: Store a byte to the pointer in `r0`, and then increment `r0` by 1
* Line 8: Loop back to Line 4 if `r1` is not zero

If we want to process, say, 46 bytes, this will loop 46 times and it will take roughly 370 clock cycles.

If we compile for `opt-level=3`, we get a lot of loop unrolling but no new instructions.

## Now with Armv8.1-M

Let's now tell LLVM we have a Cortex-M55, and we want to do `opt-level=2`.

```bash,linenos
rustc sample.rs --emit asm --target=thumbv8m.main-none-eabi --edition 2021 --crate-type=rlib -C opt-level=2 -C target-cpu=cortex-m55
cat sample.s | grep -v -e "\s\.[a-z]" -e "^\."
```

We get:

```text,linenos
double_values:
        push      {r7, lr}
        mov       r7, sp
        cmp       r1, #0
        it        eq
        popeq     {r7, pc}
        dlstp.8   lr, r1
.LBB0_2:
        vldrb.u8  q0, [r0]
        vshl.i8   q0, q0, #1
        vstrb.8   q0, [r0], #16
        letp      lr, .LBB0_2
        pop       {r7, pc}
```

It didn't do any loop-unrolling! But what *did* it do?

* Line 4-6: Check if the slice length is zero and if so, return immediately
* Line 7: Setup a do-loop with tail predication
  * The length of the loop is in `r1`
  * Use `lr` to count how many items are left
* Line 9: Vector load N bytes from the pointer in r0 to the 128-bit register `q0`
  * N will either be 16, or `lr`, whichever is smaller
* Line 10: Vector shift left each of the N bytes in `q0`
* Line 11: Vector store N bytes from `q0` to the pointer in `r0`
* Line 12: Decrement `lr` and if it is not zero, return to the label on Line 8

As I understand it, the `letp` instruction isn't even really an instruction that needs to be executed. The loop state is held within the processor outside of the normal registers, and resetting PC back to the loop start and doing the loop decrement effectively takes zero cycles. This loop will take 

The impressive thing here is that we didn't have to have any instructions for "handle this in units of 16 bytes, and once that's done, deal with whatever remainder is left over one byte at a time". It's all done in hardware - during a 'do loop', the vector instructions process either 16 bytes, or the number of bytes remaining if you're at the end of the slice. If we want to process 46 bytes, this loop repeats only 3 times - with bytes `0..=15`, `16..=31` and then the remaining `32..=45`. By my calculations ([and looking at this PDF](https://alifsemi.com/whitepaper/cortex-m55-optimization-and-tools/)) this will take around 65 clocks cycles. Yet it's no bigger, in terms of code space, than the old non-MVE `opt-level=s` loop, which took around 370 clock cycles. I'll take 5x performance, thank you very much!

## Conclusion

With Rust and Armv8.1-M Branch and Loop Extensions, we get very small code and very fast code - an excellent combination. I would love to see stable support for recompiling libcore to take advantage of these kinds of new instructions, or a new `thumbv81m.main-none-eabi{hf,}` pair of targets which default to using at least Integer MVE, and ideally Floating Point MVE.
