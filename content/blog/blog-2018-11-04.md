+++
title = " Monotron at Rust Belt Rust "
date = 2018-11-04
+++

So now [@rustbeltrust](https://twitter.com/rustbeltrust) is over, I thought it was worth writing down a few details about what Monotron can do. It's had a few upgrades since [@RustFest](https://twitter.com/RustFest) Paris! I tried to keep them under wraps to avoid spoilers but I can share them now. This is an un-roll and re-edit of my Twitter thread, and the features listed here are in no particular order:

1. You can upload binary apps into RAM over serial. 24 KiB is reserved for apps, leaving 8 KiB for stack and character RAM. The ROM passes a structure full of function pointers so that apps can access useful functionality, including a vsync function for smooth gameplay.

2. You can write apps in C and in Rust! Example apps include Tiny Basic, a little slideshow about the system, Snake and even a 6502 emulator running an unmodified copy of 6502 Enhanced BASIC.

3. There is a three channel 8-bit wavetable synthesiser running at 37 kHz (the scan-line frequency). It has four 256 byte samples - square, sawtooth, sine and noise. Snake has multi-track title screen music and in-game effects. The output is 8-bit PWM; I realised that unlike I stated in my previous post, I didn't need to use dual 5-bit PWM as you can simply generate 8-bit PWM (0..255) within a 264 sample window. In other words, you can't reach maximum volume. I also wrote a three channel music tracker to play background tunes.

4. There's an Atari compatible 9-pin Joystick interface. I tested it with a knockoff Atari 2600 joystick clone. Snake uses keyboard (over serial) or joystick control.

5. You can change fonts at runtime. It comes with Code Page 850 plus a Teletext font containing all 64 block graphics in both separated and connected forms. Apps can supply their own font / block graphics. I have code that will parse and render genuine 1000 byte Teletext frames.

6. You can embed escape sequences into printed strings to set foreground and background colours, clear the screen and enable double-height text. There's also an on-screen cursor, which makes the command line interface a little easier to use.

7. You can attach a chunk of RAM as a 1 bit-per-pixel bitmap at any scan-line. This is rendered in place of the text, using the text colour attributes, but at half the vertical resolution (so 384px x 288px max, which is ~13 KiB!).

All the source code is on my [GitHub](https://github.com/thejpster/monotron) and it is split in to multiple crates to aid re-use. There are loads of open issues containing thoughts for improvements - please check them out and feel free to send me a PR! In particular I'd love help with PS/2, USB HID and SDMMC support. 