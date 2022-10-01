+++
title = "I decided to make an 1980's Home Computer in Rust - Part 1"
date = 2018-02-20
+++

I've had a few projects over the past few years using the TI Stellaris Launchpad. It's nothing particularly special - just a Cortex-M4 based LM4F120 MCU at up to 80 MHz with 256 KiB of Flash and 32 KiB of SRAM, an RGB LED and an on-board USB programmer - but it's pretty cheap and I've gotten to know it quite well.

The provided StellarisWare software was a 300 MiB installer, so I threw that out and wrote all of the drivers from scratch. I started out in C, and managed to get a simple car dashboard module working, using an LCD TFT with on-board framebuffer and 8-bit 6800/8080 bus interface (despite the chip not having such a bus - I cheated and used GPIO pins instead). My first attempt at Rust programming was the stellaris-launchpad crate. This has a few demos that either blink the LED or roll it through an RGB rainbow using the PWM timers. From this, I then decided to move the chip support package into a separate crate, in case anyone wanted to use the chip on a different board (which would mean that, for example, while the UART peripheral was at the same memory address, the GPIO pins it was routed to may be different depending on the exact board layout).

Recently I've started a new version of the lm4f120 crate called tm4c123x-hal. The name change reflects TI's new name for basically the exact same part, while the -hal indicates that it's based upon the output of svd2rust and @japaric's new Embedded Hal crate.

At the same time, I was watching videos on Youtube about a new wave of 1980's style 'retro' computing boards - text output, BASIC interpreter, etc - such as the Colour Maximite and the PE6502. In both cases the kits seemed a little expensive (although my benchmark is the Raspberry Pi Zero at $5, which makes anything seem expensive unless it's free), and the Maximite was PIC based (I have no experience with PICs) and the PE6502 was an actual 6502 which, while cute, isn't exactly fast.

An idea started to form that I could put all three of these things together - use my Stellaris Launchpad with the bare minimum of external components and combine it with the Rust code I'd been developing to produce a full BASIC-alike interpreter with graphical output and PS/2 keyboard input. Perfect for my kids to learn to program on and an ideal demonstration of Rust's zero-cost abstractions.

I didn't really know anything about how VGA worked at this point, so the first step was to find out. TinyVGA's timing page is a brilliant resource that gives you the timings for a whole range of standard resolutions. I picked 800x600@60Hz because it uses a 40MHz pixel clock and my LM4F120 can run at 80MHz, giving a nice divide by 2.  To make things easier though, I decided to drop the resolution to 400x300@60Hz, sending each pixel twice (making a 20MHz pixel clock) and sending each line twice.

A VGA monitor takes three analog inputs - red, green and blue - with a peak signal of 0.7V corresponding to maximum brightness. There are also two TTL digital signals - a Horizontal Synchronisation pulse (H-Sync) and a Vertical Synchronisation Pulse (V-Sync). Here are the 800x600@60Hz horizontal timings from TinyVGA:

| Scanline part | Pixels | Time [µs] |
| ------------- | ------ | --------- |
| Visible area  | 800    | 20        |
| Front porch   | 40     | 1         |
| Sync pulse    | 128    | 3.2       |
| Back porch    | 88     | 2.2       |
| Whole line    | 1056   | 26.4      |

What this means is, each line (think of an electron gun sweeping horizontally across an old-fashioned cathode ray tube monitor) consists of 800 pixels of data (of varying brightness), followed by 1 + 3.2 + 2.2 = 6.4 microseconds of 0V on each of the three analog pins. In my case, I'm only driving one pin, giving a green on black display. Exactly 1 microsecond after the pixels for a given line have been draw, the H-Sync line goes high for exactly 3.2 microseconds. This periodic signal is sampled by the monitor and it synchronises its electron beam (or it's Digital to Analog converter, if it's an LCD) to it.

Here are the vertical timings:

| Frame part   | Lines | Time [ms] |
| ------------ | ----- | --------- |
| Visible area | 600   | 15.84     |
| Front porch  | 1     | 0.0264    |
| Sync pulse   | 4     | 0.1056    |
| Back porch   | 23    | 0.6072    |
| Whole frame  | 628   | 16.5792   |

What this means is that once 600 lines have been drawn (300 lines, each drawn twice in my case), there is 28 lines worth (739.2 microseconds) of blank lines drawn. In a similar fashion to the H-Sync, 0.0264 microseconds after the last visible line is drawn, the V-Sync signal goes high for 0.1056 microseconds. Again, the monitor can synchronise the sweeping of the electron beam down the screen (and back up again during the blank period) to this signal.

So, I've got to generate two TTL periodic signals - one pretty fast and one fairly slow - plus bash out 300 pixels at 20MHz. My first pass was to generate the sync signals with two timers, leaving the picture entirely blank. My first problem was that at a system clock of 80 MHz, a 16-bit timer isn't large enough to handle the V-Sync. The LM4F120 has six timers, each containing two 16-bit units. You can join these in to one larger 32-bit timer, but it's a bit fiddly. Fortunately the LM4F120 also has six 'wide' timers which are 32-bit pairs that can be joined into one 64-bit timer. Here's the relevant snippets of code to generate a valid signal:

	
```rust
const H_VISIBLE_AREA: u32 = 80 * 20;
const H_FRONT_PORCH: u32 = 40 * 2;
const H_SYNC_PULSE: u32 = 12 * 28;
const H_BACK_PORCH: u32 = 88 * 2;
const H_WHOLE_LINE: u32 = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
const H_SYNC_END: u32 = H_WHOLE_LINE - H_SYNC_PULSE;
const H_LINE_START: u32 = H_WHOLE_LINE - (H_SYNC_PULSE + H_BACK_PORCH);
const V_VISIBLE_AREA: u32 = 600;
const V_FRONT_PORCH: u32 = 1;
const V_SYNC_PULSE: u32 = 4;
const V_BACK_PORCH: u32 = 23;
const V_WHOLE_FRAME: u32 = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;
const V_SYNC_END: u32 = V_WHOLE_FRAME - V_SYNC_PULSE;

let h_timer = p.TIMER0;
// Configure h_timerA for h-sync and h_timerB for line trigger
h_timer.ctl.modify(|_, w| w.taen().clear_bit().tben().clear_bit());
h_timer.cfg.modify(|_, w| w.cfg()._16_bit());
h_timer.tamr.modify(|_, w| {
    w.taams().set_bit();
    w.tacmr().clear_bit();
    w.tamr().period();
    w
});
h_timer.tbmr.modify(|_, w| {
    w.tbams().set_bit();
    w.tbcmr().clear_bit();
    w.tbmr().period();
    w.tbmie().set_bit();
    w.tbpwmie().set_bit();
    w
});
h_timer.ctl.modify(|_, w| w.tapwml().clear_bit());
h_timer.ctl.modify(|_, w| w.tbpwml().set_bit());
h_timer.tapr.modify(|_, w| unsafe { w.bits(0) });
h_timer.tbpr.modify(|_, w| unsafe { w.bits(0) });
h_timer.tailr
    .modify(|_, w| unsafe { w.bits(H_WHOLE_LINE - 1) });
h_timer.tbilr
    .modify(|_, w| unsafe { w.bits(H_WHOLE_LINE - 1) });
h_timer.tamatchr
    .modify(|_, w| unsafe { w.bits(H_SYNC_END - 1) });
h_timer.tbmatchr
    .modify(|_, w| unsafe { w.bits(H_LINE_START - 1) });
h_timer.imr.modify(|_, w| {
    w.cbeim().set_bit(); // PWM triggers the capture event bit
    w
});

let v_timer = p.WTIMER0;
v_timer
    .ctl
    .modify(|_, w| w.taen().clear_bit().tben().clear_bit());
v_timer.cfg.modify(|_, w| w.cfg()._16_bit());
v_timer.tamr.modify(|_, w| {
    w.taams().set_bit();
    w.tacmr().clear_bit();
    w.tamr().period();
    w.tawot().set_bit();
    w
});
v_timer.ctl.modify(|_, w| w.tapwml().clear_bit());
v_timer.tapr.modify(|_, w| unsafe { w.bits(0) });
v_timer.tailr
    .modify(|_, w| unsafe { w.bits(V_WHOLE_FRAME * H_WHOLE_LINE - 1) });
v_timer.tamatchr
    .modify(|_, w| unsafe { w.bits(V_SYNC_END * H_WHOLE_LINE - 1) });
h_timer.icr.write(|w| w.tbmcint().set_bit().tbtocint().set_bit());
v_timer.ctl.modify(|_, w| w.taen().set_bit());
h_timer.ctl.modify(|_, w| w.taen().set_bit().tben().set_bit());
```

I really need to write a Timer API, as it's very fiddly setting all of the badly named registers by hand. But - here's the monitor locking on!


And here's the very basic circuit. The H-Sync and V-Sync are basically connected directly to the monitor cable, while the pin I'm going to use for Green video output goes through a resistive divider to get it nearer to 0.7V.


The very observant will notice the monitor reports 56 Hz not 60 Hz. The very very observant will note that the value for H_SYNC_PULSE should be 128 x 2, not 12 x 28. It turns out monitors are pretty tolerant of lousy video signals! I fixed this error in a later version.

The next step was to clock out some pixels. I've seen some examples on things like AVR chips use hand rolled assembler pushing pixels out of GPIO ports, but I've got an SPI peripheral (acually three) so I decided to use that. It took quite a while to get interrupts working as it turns out, when an LM4F120 timer is in PWM mode (which I used to get the sync pins moving automatically as the two timer periods elapse), standard Timer interrupts don't work. Instead you must use a 'PWM Capture Interrupt' which is basically the same thing, but with a different name. In my ISR, I just loaded some 0xFFFF words into the SPI peripheral's 16-bit wide, 8 word deep FIFO. Once I was happy that was working, I created a Framebuffer in SRAM as a mutable static and got the ISR to read from that. I also set up a second interrupt to count the number of lines that had been clocked out so far, so I could read from the correct line in the frame buffer.

At this point, the ISRs look like this. You can see I'm now driving the V-sync from the line interrupt, meaning I no longer need the Wide Timer 0 I was using before. The mutable statics make me a bit sad, and the busy waiting in the ISR trying to get all 25 words (25 x 16 = 400 pixels) into the SPI FIFO makes me very sad, but it works for now.


```rust
fn start_of_line(fb_info: &mut FrameBuffer) {
    let gpio = unsafe { &*tm4c123x_hal::tm4c123x::GPIO_PORTC::ptr() };

    fb_info.line_no += 1;

    if fb_info.line_no == V_WHOLE_FRAME {
        fb_info.line_no = 0;
        unsafe { bb::change_bit(&gpio.data, 4, true) };
    }

    if fb_info.line_no == V_SYNC_PULSE {
        unsafe { bb::change_bit(&gpio.data, 4, false) };
    }

    if (fb_info.line_no >= V_SYNC_PULSE + V_BACK_PORCH)
        && (fb_info.line_no < V_SYNC_PULSE + V_BACK_PORCH + V_VISIBLE_AREA)
    {
        // Visible lines
        // 600 visible lines, 300 output lines each shown twice
        fb_info.fb_line = Some((fb_info.line_no - (V_SYNC_PULSE + V_BACK_PORCH)) >> 1);
    } else if fb_info.line_no == V_SYNC_PULSE + V_BACK_PORCH + V_VISIBLE_AREA {
        fb_info.frame = fb_info.frame.wrapping_add(1);
    } else {
        // Front porch
        fb_info.fb_line = None;
    }
}

fn start_of_data(fb_info: &FrameBuffer) {
    let ssi = unsafe { &*tm4c123x_hal::tm4c123x::SSI2::ptr() };
    if let Some(line) = fb_info.fb_line {
        for word in fb_info.buffer[line].iter() {
            ssi.dr.write(|w| unsafe { w.data().bits(*word) });
            while ssi.sr.read().tnf().bit_is_clear() {
                asm::nop();
            }
        }
    }
}

extern "C" fn timer0a_isr() {
    let timer = unsafe { &*tm4c123x_hal::tm4c123x::TIMER0::ptr() };
    // let cs = unsafe { CriticalSection::new() };
    let mut fb_info = unsafe { &mut FRAMEBUFFER };
    start_of_line(&mut fb_info);
    timer.icr.write(|w| w.caecint().set_bit());
}

extern "C" fn timer0b_isr() {
    let timer = unsafe { &*tm4c123x_hal::tm4c123x::TIMER0::ptr() };
    // let cs = unsafe { CriticalSection::new() };
    let fb_info = unsafe { &mut FRAMEBUFFER };
    start_of_data(&fb_info);
    timer.icr.write(|w| w.cbecint().set_bit());
}
```

The next test put out three different stripes (one for each third of the screen) plus two characters copied into the framebuffer as a bitmap, just to see what they'd look like.

And here's a Rust logo. I used Gimp to scale, convert to 1-bpp and save as an X Bitmap file, which it turns out is just a C file containing a char array. I then wrote a tiny bit of C (I know, I know!) to convert this to 16-bit hex words surrounded with square brackets which I could then place in my Rust source file as the array initialiser for the framebuffer memory.

Well that about wraps up this post. You can see the work in progress at https://github.com/thejpster/hal-demos/blob/master/examples/hello_vga.rs and next time I'll talk about font rendering and how I plan to turn this from a hacked up example to a nicely laid out application.

{{ gallery() }}

