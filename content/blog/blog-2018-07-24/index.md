+++
title = "Where next for the Monotron"
date = 2018-07-24
+++

It's a couple of months on from my talk at [RustFest](https://www.youtube.com/watch?v=pTEYqpcQ6lg) on Monotron, so I thought it was worth a quick catch up on where we're going next.

## Graphics and Text

As a recap, Monotron currently generates an 800 x 600 VGA signal at 60 Hz (with a pixel clock of 40 MHz). It does this using three synchronised SPI peripherals, a timer generating the horizontal-sync pulse and a GPIO pin for the vertical-sync. With the CPU running at a clock speed of 80 MHz, the SPI peripherals are clocked at 20 MHz producing 400 horizontal pixels per line. This is half the nominal 800 pixels, but we needed to sacrifice resolution to double the amount of CPU time we have to 4 clocks per pixel (i.e. 32 clocks per 8-bit character column).

The pixels are generated from a 48 x 36 character buffer. Each cell can store one 8-bit character (in [MS-DOS CodePage 850](https://en.wikipedia.org/wiki/Code_page_850)) and one 8-bit attribute value. Currently the attribute value stores a 3-bit (1 red bit, 1 green bit, 1 blue bit) background colour and a 3-bit foreground colour. The font is 8x16 pixels, giving an effective resolution of 384x576 (although with the double-wide pixels this looks like 768x576). We then add an 8-pixel border left and right, and a 12 pixel border top and bottom to bring us out to our nominal 400x600. The total memory consumed by the text buffer is 48 x 36 x 2 = 3,456 bytes, plus a few bytes for counters and other state information.

While this system works well enough, it does limit our graphical abilities to something a bit like MS-DOS text mode. ASCII arts works well enough, but can we do better?

A naive approach of the maximum 400 x 600 resolution (borders be damned) at 3 bits per pixel packed as one 4-bit nibble per pixel would consume 400 x 600 x 4 / 8 = 120,000 bytes. We only have 32,768 bytes of SRAM on total, so that won't fly. Dropping the resolution to 400 x 300 gives us 60,000 bytes so still roughly double.

If we re-instate the borders, and arrange our data as three monochrome images (one red, one green, one blue), we get (384 x 288 / 8) x 3 = 41,472 bytes. Close, but still too much.

One solution is to drop the horizontal resolution further to 192 pixels. This drops our memory requirements to 20,736 bytes. This is quite a lot of our 32 KiB SRAM, but it fits, and we retain exact control over the colour of every single pixel on the screen.

Another solution is to steal a trick from the [Commodore C64](https://www.c64-wiki.com/wiki/Standard_Bitmap_Mode) and the [Sinclair ZX Spectrum](https://en.wikipedia.org/wiki/ZX_Spectrum_graphic_modes#Standard_mode). They both had bitmap graphics modes where you wrote to a monochrome frame-buffer, but each character sized region of the screen was coloured using the 'color RAM' or 'attribute RAM' used for colouring the characters in text mode. This is easy to implement, as rendering 8 pixels from the frame-buffer is exactly the same code that we already have for rendering 8 horizontal pixels from our font glyphs. One downside of this approach is that every 8x8 block of pixels is limited to just two colours. If we drew, say, a white line on a black background and then crossed it with a red line on a black background, the area where those lines cross would need three colours (white, red and black) but only two are available. This is known as [attribute clash](https://en.wikipedia.org/wiki/Attribute_clash) and the ZX Spectrum was (in)famous for it. But, if we do take this approach, we'd only need 384 x 288 / 8 = 13,824 bytes, plus the 3,456 bytes of RAM for text mode, which saves us 3,456 bytes over the full 3-bpp frame-buffer mode above, and at double the horizontal resolution.  Actually, we only need half the text mode RAM but it's easier to keep it whole. Besides, it would allow us to perform a neat trick.

Because we have both pixel sources available - text, and bitmap - we could select which one to use on a line-by-line basis. If we define graphics mode to start and end on two given scan-lines, we could have a split-screen effect. If we used 0 and 576 for full-screen graphics we could need the amount of frame-buffer RAM noted above, but if we allowed ourselves two lines of text (and ASCII-art) at the top of the screen, and five lines of text at the bottom of the screen, we'd only need to supply a 384 x 288 - ((2 + 5) x 8) = 11,136 bytes. Each text row is of course only 8 lines of graphics frame-buffer because we dropped our vertical resolution by half to 288 lines. If we had a 50/50 split (say, for a LOGO application, or perhaps a graphing tool), we'd only need 6,912 bytes. That saves lots of memory for our applications. In addition, by loading a bitmap into graphics memory and then sweeping the start scan-line, we can achieve a neat vertical wipe effect.

## Sound

It turns out, it's fairly straightforward to [generate line-level audio from a 3.3v GPIO pin](https://learn.adafruit.com/adding-basic-audio-ouput-to-raspberry-pi-zero?view=all). You can of course trivially generate a maximum-volume square wave of various frequencies by driving the pin from a Timer. If you go to a much higher frequency however, the you can PWM different effective voltage levels on to the pin and gain much more control over the audio. If we ran our Timer at the full 80 MHz (reading the data-sheet, this seems to be allowed), and generated a new audio sample on every video scan-line (37.878 kHz), then we'd get 2112 timer ticks per audio sample. If we used dual phase-correct 5-bit PWMs (giving an effective 10-bits), this would fit perfectly, as there would be precisely 33 loops of the PWM per scan-line (33 x 2(5+1) = 2112). The PWM outputs would be mixed with 3.9k and 124k 1% resistors (in the ratio 1:32). We probably need to ensure we remain at an integer mutiple of the vertical frequency, to ensure the audio interrupt never overlaps with the video sync interrupt (which would cause visible wobble or distortion on-screen).

How will this sound? I have no idea!

## Programming

No home computer is complete without a programming language. I originally envisioned an interpreted curly-bracket language a bit like Javascript which was compiled down to byte-code on a function-by-function basis. This would have meant that at most only one function needed to be converted to plain text at any one time, but in the end, given the discussions about graphical frame-buffers above, I concluded that 32 KiB of SRAM didn't allow large enough functions to be held in RAM at once to be useful.

The alternative then is to again borrow a trick from the 1980s home computer revolution and allow the user to program in BASIC (or some other new-line delimited language like Rexx). The advantage here is that each line of text entered is syntactically complete and can be compiled down to byte code. Listing the program on screen doesn't consume any memory as each line is decoded from byte-code to plain text, sent to the screen and then discarded. The disadvantage is that line-numbering is required so that relevant lines can be recalled for modification. I had hoped to avoid introducing Monotron users to the horrors of GOTO and GOSUB, but perhaps we can introduce a nice procedure declaration syntax and auto-numbering of lines to make it feel a little more modern. One alternative is to emulate a 6502 processor, complete with a small block of RAM (say 8 KiB) and actually run an original Microsoft 6502 BASIC, such as Commodore BASIC v2. This would give good compatibility with pure-BASIC programs from the era, but quickly fall apart when users attempted to POKE memory mapped registers which don't exist on the Monotron. A middle-ground approach might be to implement a new BASIC in Rust but make it as backwards-compatible as possible with, say, BBC BASIC from the BBC Micro, BBC Master and Acorn Archimedes line of computers. The nice thing about BBC BASIC is that it had a richer set of sound and graphics commands and so fewer programs had to resort to manually POKEing registers. And of course the BBC Micro was host to the original ARM1 based ARM Evaluation System, the great-great-grandchild of which powers the TM4C123 micro-controller that runs the Monotron.

## Interfacing

Monotron currently has a PS/2 keyboard interface which is mostly working. The problem is that you need to sample the input data pretty soon after the rising clock edge, and 37,878 times a second the CPU spends an un-interruptible 64 clocks cycles busy-waiting to align the SPI outputs. Currently this manifests itself as dropped or corrupted keypresses, which spoils the experience somewhat. It turns out though that the TM4C123 upgrade to my LM4F120 micro-controller is identical bar to two minor additions. One, it adds a quadrature input decoder. But two, it adds full USB Host support to the USB Controller, and the Tiva-C Launchpad is fitted with a micro-AB connector to match. As the USB controller has 2 KiB of dedicated FIFO RAM, in theory this would result in less critical interrupt timing and more reliable keyboard input. But, I have to write an entire USB host stack in Rust for the TM4C123 to find out.

I'd also like to remove the USB-Serial text input (handled on UART0, using the dedicated JTAG/USB processor on the Launchpad) and replace it with a data transfer protocol (maybe X-Modem? or Kermit?) and a little desktop application that simulates a disk drive that files can be loaded or saved from. This would allow any programs that have been entered into the Monotron to be saved for later use. Alternatively, I could consider adding FAT filesystem and USB Mass Storage support for writing directly to USB memory stick. This would require the use of USB hub as the Launchpad only has a single micro-AB connector. Maybe a USB Floppy drive would work? Either way, I'd have to implement another USB protocol and a FAT12/16/32 file-system implementation in Rust.