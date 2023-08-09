+++
title = "Talking about Monotron at RustFest"
date = 2018-05-26
+++

So, today I did a talk about Monotron at [RustFest Paris](https://paris.rustfest.eu). You can find the code on my Github and/or on crates.io:

* [The top-level crate](https://github.com/thejpster/monotron)
* The generic embedded [VGA Framebuffer Driver](https://github.com/thejpster/vga-framebuffer-rs), with callbacks for hardware specific bits
* The [command-line menu system](https://github.com/thejpster/menu)
* The [PS/2 keyboard driver](https://github.com/thejpster/pc-keyboard) (unfinished)
* The [tm4c123x-hal](https://github.com/thejpster/tm4c123x-hal) and [tm4c123x](https://github.com/thejpster/tm4c123x) chip support crates
* The excellent [Cortex-M](https://crates.io/crates/cortex-m) and [Cortex-M-RT](https://crates.io/crates/cortex-m-rt) crates from japaric.

If you want to buy a [Tiva-C Launchpad](http://www.ti.com/tool/ek-tm4c1294xl) (it's the same as a Stellaris Launchpad) of your very own, try [RS Components](https://uk.rs-online.com/web/p/processor-microcontroller-development-kits/7950729/), or [Farnell](http://uk.farnell.com/texas-instruments/ek-tm4c123gxl/launchpad-tiva-c-evaluation-kit/dp/2314937?st=Tiva-C%20launchpad) or [Digi-Key](https://www.digikey.com/product-detail/en/texas-instruments/EK-TM4C123GXL/296-35760-ND/3996736). Just add a VGA connector and three resistors. The [Github README](https://github.com/thejpster/monotron/blob/master/README.md) tells you where to put them but I take no responsibility if you blow something up - double-check your working with an oscilloscope before risking your monitor!

The video of the talk will be on the RustFest Paris website soon!

If you want to ask a question, catch me on IRC (try #rust-embedded) or as @therealjpster on Twitter. If you want to know more about Embedded Rust, the [Embedded Rust Working Group](https://github.com/rust-lang-nursery/embedded-wg) has some excellent help on offer.

If you want to help make Montron better, check out the issue list and send me a PR!

Edit: JP from 2022 here, this project has now been archived. Check out https://neotron-compute.github.io instead!
