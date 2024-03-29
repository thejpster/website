+++
title = "Embedded Rust in 2018"
date = 2018-01-14
+++

I recently picked up an embedded project that I hadn't touched for a few months, so I could add some new features. I was disappointed to note that it no longer compiled - nothing in the code had changed, but it only compiles with Nightly Rust and that had recently had a bunch of changes that completely broke my build. This is then a tale about what I'd like to see from Rust in 2018.

I know there's been a lot of interest in WASM and other 'high level' applications, but Rust also lends itself very well to [embedded development](https://www.cambridgeconsultants.com/insights/vlog-the-future-is-rust). I have a [demonstration project](http://github.com/thejpster/stellaris-launchpad) for the Texas Instruments [Stellaris Launchpad](http://www.ti.com/tool/EK-LM4F120XL) (now rebadged the [Tiva-C Launchpad](http://www.ti.com/tool/EK-TM4C123GXL)). This project comprises approximately three Assembler instructions (to bounce into the [hardfault handler](https://github.com/thejpster/stellaris-launchpad/blob/0aacc869f71432b34c9cbea39df38158aa308ad8/src/common/startup.rs#L421)), and the rest is Rust - no C required! Exception handlers, setting the stack pointer and initialising the `.data` and `.bss` segments can all be done in pure Rust. Thanks to brilliant work by the likes of [@japaric](https://github.com/japaric), with the [Xargo](https://github.com/japaric/xargo) cross-compilation helper and his [excellent tutorials](http://blog.japaric.io/quickstart/), you could even start to argue that writing embedded applications is bordering on easy. Except for one problem:

* embedded rust requires several lang items that aren't stable yet, and
* unstable items are only available on Nightly Rust, but
* nightly Rust moves fast and breaks things, and is not apologetic about that, so...
* embedded builds often break all by themselves.

Here's a list of the lang items I need to get my project to build:

```rust
#![feature(asm)]
#![feature(compiler_builtins_lib)]
#![feature(core_intrinsics)]
#![feature(global_allocator)]
#![feature(lang_items)]
#![feature(naked_functions)]
#![no_std]
```

I need assembler intrinsics (as noted above); the compiler builtins give me memcpy and other functions that the compiler expects to be available; core intrinsics gives me a way to read/write volatile pointers that have side-effects (i.e. memory mapped registers); global allocator is needed to use Box with my custom memory allocator; lang items are required because in `#[no_std]` I need to supply my own panic routines; naked functions are needed for some specific types of fault handler (to avoid the compiler moving a bunch of stuff out of registers before you've had a chance to inspect it); and finally I need to disable the standard library because it isn't available for the 'no OS' platform. Phew!

My most recently nightly breakage came from, I think, recent changes to link time optimisations (LTO). The symptom was that my code compiled and build, but that every function was then garbage collection and my `.text` segment contained exactly zero bytes! I think the fix was to use disable incremental compilation and set codegen-units to 1 in `Cargo.toml`. I'll be honest, I didn't get into the fine detail of exactly which option did what - at this point I was sort of flinging options at the compiler in a desperate attempt to get something to work! Which is because that really isn't what I sat down at the laptop for that evening - I really wanted to do some more work on my NOR flash driver so I can finish my TockOS bootloader.

I think what I'd really like in 2018, is to be able to use a 'known good' nightly; rather than just rolling the dice on whatever happened to come out of the CI system last night, I'd like to be able to take stable Rust, and turn on the experimental features I need. That way, my integration exercises only need to take place every six weeks rather than every time I do a rustup update, and we can all 'settle' on one compiler version rather than working on five projects requiring five different specific versions of nightly. And in an ideal world, I'd like to see some of these features go away - the syntax for inserting assembly instructions into the compiler output for example, shouldn't be too difficult to fix, for example, as C has been doing it for decades. Yes it's ugly, but actually for that I'll take ugly over over experimental. I'd also like to see the core team think a little more about `#[no_std]` development, and ensure that things in libstd that don't need an OS (like IO traits) move into libcore so that we don't have to reinvent the wheel in an incompatible way. And finally, I'd like to see more movement towards an Embedded HAL, so that we can start to share drivers for off-chip components (SPI displays, I2C sensors, etc) as crates, rather than working in separate silos.

Let's make 2018 the year Embedded Rust goes mainstream!
