+++
title = "Arm Microcontroller Compilation Options in Rust"
date = "2024-09-29"
+++

## Intro

The [Rust Platform Docs] highlight lots of options you can turn on when programming an Arm microcontroller. But what do they do? Let's have a look!

[Rust Platform Docs]: https://doc.rust-lang.org/nightly/rustc/platform-support/arm-none-eabi.html

Here's our sample source code:

```rust=
#![no_std]

#[no_mangle]
pub fn f32_add4(x: [f32; 4], y: [f32; 4]) -> [f32; 4] {
    [
        (x[0] * 2.0) + y[0],
        (x[1] * 2.0) + y[1],
        (x[2] * 2.0) + y[2],
        (x[3] * 2.0) + y[3],
    ]
}

#[no_mangle]
pub fn f64_add4(x: [f64; 4], y: [f64; 4]) -> [f64; 4] {
    [
        (x[0] * 2.0) + y[0],
        (x[1] * 2.0) + y[1],
        (x[2] * 2.0) + y[2],
        (x[3] * 2.0) + y[3],
    ]
}

#[no_mangle]
pub fn i32_add4(x: [i32; 4], y: [i32; 4]) -> [i32; 4] {
    [
        (x[0] * 2) + y[0],
        (x[1] * 2) + y[1],
        (x[2] * 2) + y[2],
        (x[3] * 2) + y[3],
    ]
}

#[no_mangle]
pub fn i8_i16_add(x: i8, y: i16) -> i16 {
    i16::from(x) + i16::from(y)
}
```

We're going to look at the Cortex-M7 (`thumbv7em-none-eabi`), Cortex-M33 (`thumbv8m.main-none-eabi`), Cortex-M85 (`thumbv8m.main-none-eabi`). Other Arm CPUs will be similar, but this covers the basics. We're sticking to the *soft-float* ABI (`eabi`) so that we can turn the FPU on and off. If we used the *hard-float* ABI (`eabihf`), we would have to have the FPU enabled.

## Cortex-M7

The [Arm Cortex-M7](https://developer.arm.com/Processors/Cortex-M7) is a [high-performance core with almost double the power efficiency of the older Cortex-M4](https://en.wikipedia.org/wiki/ARM_Cortex-M#Cortex-M7).

### Plain build

The Cortex-M7 can have either no FPU, a single-precision FPU (for processing `f32` values) or a double-precision FPU (for handling `f32` and `f64`) values. We use the `thumbv7em-none-eabi` target for this CPU, which assumes we have no FPU. Let's build our sample:

```bash
rustc sample.rs --emit asm --target=thumbv7em-none-eabi --edition 2021 --crate-type=rlib -C opt-level=3
cat sample.s | grep -v -e "\s\.[a-z]" -e "^\."
```

I've stripped out the assembler directives using `grep`, because they are not interesting to us today (although freel free to have a look and see what you're missing). Let's just look at the assembly code for each function:

```text
f32_add4:
        push    {r4, r5, r6, r7, lr}
        add     r7, sp, #12
        push.w  {r8, r9, r10, r11}
        sub     sp, #4
        mov     r4, r0
        ldrd    r6, r0, [r1, #8]
        ldrd    r10, r11, [r1]
        mov     r1, r0
        mov     r5, r2
        bl      __aeabi_fadd
        ldr     r1, [r5]
        str     r1, [sp]
        ldr     r1, [r5, #12]
        ldrd    r9, r8, [r5, #4]
        bl      __aeabi_fadd
        str     r0, [r4, #12]
        mov     r0, r6
        mov     r1, r6
        bl      __aeabi_fadd
        mov     r1, r8
        bl      __aeabi_fadd
        str     r0, [r4, #8]
        mov     r0, r11
        mov     r1, r11
        bl      __aeabi_fadd
        mov     r1, r9
        bl      __aeabi_fadd
        str     r0, [r4, #4]
        mov     r0, r10
        mov     r1, r10
        bl      __aeabi_fadd
        ldr     r1, [sp]
        bl      __aeabi_fadd
        str     r0, [r4]
        add     sp, #4
        pop.w   {r8, r9, r10, r11}
        pop     {r4, r5, r6, r7, pc}
```

This target doesn't use the FPU, so it's calling the `__aeabi_fadd` function to do the floating point addition. The inputs to the function are two arrays of floats, the pointers for which arrive in `r1` and `r2`. The register `r0` holds a pointer to the array we are returning (which the caller has pre-allocated).

In case you were wondering why `sp + 12` is stored in `r7`, when it never appears to read from `r7`, that's the *frame pointer*. It shows the maximum bound for the stack usage for the current frame (i.e. function) and is quite useful to the debugger. We can't turn it off because the target has it enabled. We can see that with:

```bash
rustc +nightly --target=thumbv7em-none-eabi --print target-spec-json -Z unstable-options
```

This produces:

```json
{
  "abi": "eabi",
  "arch": "arm",
  "c-enum-min-bits": 8,
  "crt-objects-fallback": "false",
  "data-layout": "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64",
  "emit-debug-gdb-scripts": false,
  "frame-pointer": "always",
  "is-builtin": true,
  "linker": "rust-lld",
  "linker-flavor": "gnu-lld",
  "llvm-target": "thumbv7em-none-eabi",
  "max-atomic-width": 32,
  "metadata": {
    "description": "Bare ARMv7E-M",
    "host_tools": false,
    "std": false,
    "tier": 2
  },
  "panic-strategy": "abort",
  "relocation-model": "static",
  "target-pointer-width": "32"
}
```

Anyway, let's look at the `f64` version of the function:

```text
f64_add4:
        push    {r4, r5, r6, r7, lr}
        add     r7, sp, #12
        push.w  {r8, r9, r10}
        mov     r6, r1
        mov     r8, r0
        ldrd    r0, r1, [r1, #24]
        mov     r5, r2
        mov     r3, r1
        mov     r2, r0
        bl      __aeabi_dadd
        ldrd    r2, r3, [r5, #24]
        bl      __aeabi_dadd
        strd    r0, r1, [r8, #24]
        ldrd    r0, r1, [r6, #16]
        mov     r3, r1
        mov     r2, r0
        bl      __aeabi_dadd
        ldrd    r2, r3, [r5, #16]
        bl      __aeabi_dadd
        strd    r0, r1, [r8, #16]
        ldrd    r0, r1, [r6, #8]
        mov     r3, r1
        ldrd    r4, r9, [r6]
        mov     r2, r0
        bl      __aeabi_dadd
        ldrd    r2, r3, [r5, #8]
        ldrd    r6, r10, [r5]
        bl      __aeabi_dadd
        strd    r0, r1, [r8, #8]
        mov     r0, r4
        mov     r1, r9
        mov     r2, r4
        mov     r3, r9
        bl      __aeabi_dadd
        mov     r2, r6
        mov     r3, r10
        bl      __aeabi_dadd
        strd    r0, r1, [r8]
        pop.w   {r8, r9, r10}
        pop     {r4, r5, r6, r7, pc}
```

Pretty similar to the last one, except it's calling `__aeabi_dadd` to add two 'doubles' (double-precision floating point values, which is a `double` in C or an `f64` in Rust).

Now let's look at the integer addition function `i32_add4`.

```text
i32_add4:
        push   {r4, r5, r6, r7, lr}
        add    r7, sp, #12
        str    r11, [sp, #-4]!
        ldrd   r12, lr, [r1]
        ldrd   r3, r1, [r1, #8]
        ldm.w  r2, {r4, r5, r6}
        ldr    r2, [r2, #12]
        add.w  r1, r2, r1, lsl #1
        add.w  r2, r6, r3, lsl #1
        add.w  r3, r5, lr, lsl #1
        add.w  r6, r4, r12, lsl #1
        strd   r2, r1, [r0, #8]
        strd   r6, r3, [r0]
        ldr    r11, [sp], #4
        pop    {r4, r5, r6, r7, pc}
```

It's using `add.w lsl #1` to add a value shifted-left by 1 (which is the same as multiplying by two) and it does it four times. I have no idea why it chose `ldrd` to load the four values from the pointer in `r1` yet chose `ldm.w` and `ldr` to load the four values from the pointer in `r2`. You'd think they'd be loaded in the same way given the arguments are of the same type.

Finally let's look at our simple `i8_i16_add` function.

```text
i8_i16_add:
        sxtab  r0, r1, r0
        bx     lr
```

Every Armv7E-M CPU has DSP support, so it gives us a single `sxtab` instruction to do a signed-expand-and-add. If we didn't have DSP support this would be separate `sxtb` and `add` instructions. The DSP extensions aren't about doing SIMD, but are about doing common Digital Signal Processing operations with fewer instructions. You can see a [full list of DSP instructions here](https://developer.arm.com/documentation/100166/0001/Programmers-Model/Instruction-set-summary/Table-of-processor-DSP-instructions).

### Build with `-Ctarget-cpu=cortex-m7`

When we compile for a given architecture, LLVM assumes a baseline set of functionality that every implementation of that architecture will have. However, it won't know any specifics about the processor we are running on, such as the length of the pipeline, or whether any instructions can be executed in parallel (a so-called [*superscalar*](https://en.wikipedia.org/wiki/Superscalar_processor) processor).

As it happens, the Cortex-M7 is a six-stage *superscalar* processor. So let's tell Rust that's what we have, with `-C target-cpu=cortex-m7`. Specifying this will cause LLVM to assume we have a Cortex-M7 with a double-precision FPU, because it always assumes the maximum set of features for a CPU and that's the shiniest Cortex-M7 you can have. If we only had a single-precision FPU we'd need to also add `-C target-feature=-fp64` to turn off the double-precision support, and if we had no FPU at all we'd need to add `-C target-feature=-fpregs`. All the combinations I know about are itemised in the [Rust Platform Docs].

Let's assume we do have that double-precision FPU - like on, say, an NXP i.MX RT1060 - so the defaults are fine.

```bash
rustc sample.rs --emit asm --target=thumbv7em-none-eabi --edition 2021 --crate-type=rlib -C opt-level=3 -C target-cpu=cortex-m7
cat sample.s | grep -v -e "\s\.[a-z]" -e "^\."
```

```text
f32_add4:
        vldr      s0, [r1]
        vldr      s2, [r1, #4]
        vadd.f32  s0, s0, s0
        vldr      s4, [r1, #8]
        vldr      s8, [r1, #12]
        vadd.f32  s2, s2, s2
        vldr      s6, [r2]
        vadd.f32  s4, s4, s4
        vadd.f32  s8, s8, s8
        vldr      s10, [r2, #8]
        vadd.f32  s0, s0, s6
        vldr      s6, [r2, #4]
        vldr      s12, [r2, #12]
        vadd.f32  s2, s2, s6
        vstr      s0, [r0]
        vadd.f32  s0, s4, s10
        vstr      s2, [r0, #4]
        vadd.f32  s2, s8, s12
        vstr      s0, [r0, #8]
        vstr      s2, [r0, #12]
        bx        lr
```

Now it's copying the floats into the `s0` register, and friends, and using the `vadd.f32` instruction to do a floating-point add.

```text
f64_add4:
        vldmia    r1, {d0, d1, d2, d3}
        vadd.f64  d0, d0, d0
        vldmia    r2, {d4, d5, d6, d7}
        vadd.f64  d1, d1, d1
        vadd.f64  d0, d0, d4
        vadd.f64  d2, d2, d2
        vadd.f64  d3, d3, d3
        vadd.f64  d1, d1, d5
        vadd.f64  d2, d2, d6
        vadd.f64  d3, d3, d7
        vstmia    r0, {d0, d1, d2, d3}
        bx        lr
```

Because LLVM assumed we had a double-precision FPU, it's copying the floats into the `d0` register, and friends, and using the `vadd.f64` instruction to do a double-precision floating-point add.

If we had told rustc that we only had a single precision FPU with `-C target-cpu=cortex-m7 -C target-feature=-fp64` (or if we had told it we had a Cortex-M4, which is single-precision only), then this function would have looked exactly like it did for the plain build.

The `i32_add4` function does the same instructions as before, but they have be re-arranged - presumably to extract the most performance from our superscalar CPU.

```text
i32_add4:
        push   {r4, r5, r6, r7, lr}
        add    r7, sp, #12
        str    r11, [sp, #-4]!
        ldm.w  r1, {r3, r12, lr}
        ldm.w  r2, {r4, r5, r6}
        ldr    r1, [r1, #12]
        ldr    r2, [r2, #12]
        add.w  r3, r4, r3, lsl #1
        str    r3, [r0]
        add.w  r3, r5, r12, lsl #1
        str    r3, [r0, #4]
        add.w  r3, r6, lr, lsl #1
        str    r3, [r0, #8]
        add.w  r1, r2, r1, lsl #1
        str    r1, [r0, #12]
        ldr    r11, [sp], #4
        pop    {r4, r5, r6, r7, pc}
```

Weird that it decided the fast way to load four integers was to load three integers with `ldm` and then one integer with `ldr`. But at least it decided to load the two arrays using the same instructions this time.

The `i8_i16_add` didn't change - it was basically one instruction already.

## Cortex-M33

The [Arm Cortex-M33](https://developer.arm.com/Processors/Cortex-M33) is a [is similar to the Cortex-M4](https://en.wikipedia.org/wiki/ARM_Cortex-M#Cortex-M33) but supporting Armv8-M with Mainline Extensions. It has a 3-stage pipeline and is *single-issue* (that is, it is not *superscalar*).

### Plain build

The Cortex-M33 can have either no FPU, or a single-precision FPU (for processing `f32` values). It can also optionally have DSP extensions, or not. We use the `thumbv8m.main-none-eabi` target for this CPU. Let's build our sample:

```bash
rustc sample.rs --emit asm --target=thumbv8m.main-none-eabi --edition 2021 --crate-type=rlib -C opt-level=3
cat sample.s | grep -v -e "\s\.[a-z]" -e "^\."
```

If we diff this output against the plain `thumbv7em-none-eabi` build, we see the only thing that changed is the `i8_i16_add` function:

```text
i8_i16_add:
        sxtb  r0, r0
        add   r0, r1
        bx    lr
```

The SXTAB instruction is from the DSP extension, and that's optional on Armv8-M, so LLVM has to do separate sign-extension and add operations here.

We can turn the DSP extension on with `-C target-feature=+dsp` and then the output looks just like the Armv7E-M version.

### Build with `-Ctarget-cpu=cortex-m33`

Now let's tell Rust we have a Cortex-M33, with `-C target-cpu=cortex-m33`. This will cause LLVM to assume we have a Cortex-M33 with a single-precision FPU, because it always assumes the maximum set of features for a CPU and that's the best a Cortex-M33 can have. It also enables the DSP extension.

```bash
rustc sample.rs --emit asm --target=thumbv8m.main-none-eabi --edition 2021 --crate-type=rlib -C opt-level=3 -C target-cpu=cortex-m33
cat sample.s | grep -v -e "\s\.[a-z]" -e "^\."
```

```text
f32_add4:
        vldr      s0, [r1]
        vldr      s2, [r1, #4]
        vldr      s4, [r1, #8]
        vldr      s6, [r1, #12]
        vldr      s8, [r2]
        vldr      s10, [r2, #4]
        vldr      s12, [r2, #8]
        vldr      s14, [r2, #12]
        vadd.f32  s0, s0, s0
        vadd.f32  s2, s2, s2
        vadd.f32  s4, s4, s4
        vadd.f32  s6, s6, s6
        vadd.f32  s0, s0, s8
        vadd.f32  s2, s2, s10
        vadd.f32  s4, s4, s12
        vadd.f32  s6, s6, s14
        vstr      s0, [r0]
        vstr      s2, [r0, #4]
        vstr      s4, [r0, #8]
        vstr      s6, [r0, #12]
        bx        lr
```

Rather than *load-load-add-load-load-add...* the scheduler has decided to emit *load-load-load...add-add-add...*. Perhaps because the Cortex-M33 has a shorter pipeline than the Cortex-M7. But basically these are the same instructions but in a different order.

```text
f64_add4:
        push    {r4, r5, r7, lr}
        add     r7, sp, #8
        vpush   {d8, d9, d10, d11, d12, d13, d14}
        vldr    d0, [r1]
        mov     r4, r0
        vldr    d13, [r1, #8]
        vldr    d11, [r1, #16]
        vldr    d8, [r1, #24]
        vmov    r0, r1, d0
        mov     r5, r2
        mov     r2, r0
        mov     r3, r1
        bl      __aeabi_dadd
        vldr    d0, [r5]
        vldr    d14, [r5, #8]
        vldr    d12, [r5, #16]
        vldr    d9, [r5, #24]
        vmov    r2, r3, d0
        bl      __aeabi_dadd
        vmov    d10, r0, r1
        vmov    r0, r1, d13
        mov     r2, r0
        mov     r3, r1
        bl      __aeabi_dadd
        vmov    r2, r3, d14
        bl      __aeabi_dadd
        vmov    d13, r0, r1
        vmov    r0, r1, d11
        mov     r2, r0
        mov     r3, r1
        bl      __aeabi_dadd
        vmov    r2, r3, d12
        bl      __aeabi_dadd
        vmov    d11, r0, r1
        vmov    r0, r1, d8
        mov     r2, r0
        mov     r3, r1
        bl      __aeabi_dadd
        vmov    r2, r3, d9
        bl      __aeabi_dadd
        vmov    d0, r0, r1
        vstr    d10, [r4]
        vstr    d13, [r4, #8]
        vstr    d11, [r4, #16]
        vstr    d0, [r4, #24]
        vpop    {d8, d9, d10, d11, d12, d13, d14}
        pop     {r4, r5, r7, pc}
```

The `f64_add4` function cannot use the FPU to perform the addition, but it can use `vldr` or *Vector Load Pair* to take a double-precision register and split it into two integer registers, one containing the top-half and one containing the bottom-half.

Before, it generated something like this for each item in the array:

```text
        ldrd  r0, r1, [r1, #24]
        mov   r5, r2
        mov   r3, r1
        mov   r2, r0
        bl    __aeabi_dadd
        ldrd  r2, r3, [r5, #24]
        bl    __aeabi_dadd
        strd  r0, r1, [r8, #24]
```

Now it generates:

```text
        vldr  d0, [r1]
        vmov  r0, r1, d0
        mov   r2, r0
        mov   r3, r1
        bl    __aeabi_dadd
        vldr  d0, [r5]
        vmov  r2, r3, d0
        bl    __aeabi_dadd
```

Is `vldr` and `vmov` faster than `ldrd` and `mov`? I assume so. I guess you could look at the cycle counts in the processor specification if you wanted.

```text
i32_add4:
        push   {r4, r5, r6, r7, lr}
        add    r7, sp, #12
        str    r11, [sp, #-4]!
        ldm.w  r1, {r3, r12, lr}
        ldr    r1, [r1, #12]
        ldm.w  r2, {r4, r5, r6}
        ldr    r2, [r2, #12]
        add.w  r3, r4, r3, lsl #1
        add.w  r1, r2, r1, lsl #1
        add.w  r5, r5, r12, lsl #1
        add.w  r6, r6, lr, lsl #1
        stm.w  r0, {r3, r5, r6}
        str    r1, [r0, #12]
        ldr    r11, [sp], #4
        pop    {r4, r5, r6, r7, pc}
```

Our `i32_add4` function is similar, but uses `stm` and `str` rather than two `strd`. Again, I have no idea why.

Our `i8_i16_add` is back to using the `sxtab` instruction because LLVM assumed the Cortex-M33 has the optional DSP extension enabled. You can turn it off with `-C target-feature=-dsp` if yours doesn't have it.

## Cortex-M55

The [Arm Cortex-M55](https://developer.arm.com/Processors/Cortex-M55) has a 4-stage pipeline and supports supporting Armv8.1-M with Mainline Extensions. According [to this white-paper](https://armkeil.blob.core.windows.net/developer/Files/pdf/white-paper/introduction-to-arm-cortex-m55-processor.pdf), it only has limited dual-issue support and thus doesn't count as a *superscalar* processor.

The Cortex-M55 is interesting because it optionally has M-Profile Vector Extensions (MVE), with the specific implementation known as *Helium*. These are *single-instruction-multiple-data* (SIMD) instructions, similar to *Neon* on the larger Application-profile Arm cores, or SSE on an Intel CPU. Yes, Helium is a lighter version of Neon. The Brits do love a good pun (and this is coming from the company that decided the smaller version of an Arm instruction was a Thumb instruction...)

Our target is still `thumbv8m.main-none-eabi` so that won't have changed from the Cortex-M33 plain build, so let's go right to tell LLVM we have a Cortex-M55. LLVM assumes we have both integer and floating-point MVE support, and the DSP extension. Note that using `-C opt-level=3` is important here, as that enables the auto-vectorisation optimisation.

```bash
rustc sample.rs --emit asm --target=thumbv8m.main-none-eabi --edition 2021 --crate-type=rlib -C opt-level=3 -C target-cpu=cortex-m55
cat sample.s | grep -v -e "\s\.[a-z]" -e "^\."
```

```text
f32_add4:
        vldrw.u32  q0, [r1]
        vadd.f32   q0, q0, q0
        vldrw.u32  q1, [r2]
        vadd.f32   q0, q0, q1
        vstrw.32   q0, [r0]
        bx         lr
```

Hot diggity! MVE gives us the `vldrw.u32` instruction which can pull four 32-bit values from memory, into our new 128-bit `qX` registers. The `vadd.f32` instruction can operate on those `qX` registers to perform four additions at the same time. So our whole loop is now just five instructions.

Sadly MVE doesn't support double-precision floats, so the `f64_add4` function is unchanged. However...

```text
i32_add4:
        vldrw.u32  q0, [r1]
        vshl.i32   q0, q0, #1
        vldrw.u32  q1, [r2]
        vadd.i32   q0, q0, q1
        vstrw.32   q0, [r0]
        bx         lr
```

It can do integers too, so again, just five instructions to double four values and then perform four additions.

If you want MVE without specifying that you have the Cortex-M55 (or Cortex-M85), it's the `+mve` flag for integer MVE, and `+mve.fp` for floating-point MVE.

Again, we have DSP enabled by default so it has the `sxtab` version of `i8_i16_add`.

## Conclusions

We've seen that changing the `target-cpu` can not only change the order of the instructions emitted, but also enable additional CPU features (that we may or may not actually have on our CPU). These can drastically reduce the size of our code and increase the performance - especially when using the M-Profile Vector Extensions.

Why not try coming up with some algorithms in Rust and seeing what affect the different Arm architectures have and what the different `target-cpu` options will do. It's all listed in the [Rust Platform Docs].
