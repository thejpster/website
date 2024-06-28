+++
title = "The History of PC Audio"
date = "2024-06-29"
+++

This is a brief, abridged, and possibly in accurate history of audio on the IBM PC compatible. It's based on an exhibition I prepared for [*Synthesised*](https://www.computinghistory.org.uk/det/72242/Synthesized-(29th-30th-June-2024)/), a special event at the [Centre for Computing History](https://www.computinghistory.org.uk/) in Cambridge, England.

In the beginning there was the [IBM PC 5150](https://en.wikipedia.org/wiki/IBM_Personal_Computer). Launched in 1981, it came with what became known as the "PC Speaker". This was an 8-ohm cone speaker, driven with a transitor from a Intel 8253 Programmable Interval Timer. You got a single channel square wave, of variable frequency and you can turn the beep on or off - that was it.

Despite its limitations, and despite the IBM PC being ostensibly a business machine, many games have support for the PC Speaker, even into the 1990s. For example *Lemmings 2: The Tribes*, and *Epic Pinball* and *Doom*, all from 1993, have PC Speaker support.

In 1983 the IBM PC Jr, and its clone the Tandy 1000, arrived with upgraded sound - a 3-channel *programmable sound generator* in the form of the Texas Instruments [SN76496](https://en.wikipedia.org/wiki/SN76496). You got 3 square waves, and this chip was also seen in the BBC Micro and the Sega Master System. However, this upgrade never made it back into the mainstream PC lineup, and was only ever a niche option, although some games did offer support for what became known as "Tandy Sound".

The next big milestone year was 1987, where two important things happened.

The first was that Adlib released the [Adlib](https://en.wikipedia.org/wiki/Ad_Lib,_Inc.) Music Sythesiser ISA expansion card. This quickly became the new PC standard for audio, and offered nine voices from its [Yamaha YM3812 "OPL2"](https://en.wikipedia.org/wiki/Yamaha_OPL#OPL2) 2-Operator FM synthesiser chip. Most MS-DOS games from 1987 onwards have support for the "Adlib".

The second major release for PC audio in 1987, was the legendary [Roland MT-32](https://en.wikipedia.org/wiki/Roland_MT-32). This was an expensive ($695 in 1987) external MIDI synthesiser module, using Roland's *Linear Arithmetic* engine based on that used in their contemporary professional keyboards. It also came with a companion "intelligent" MIDI interface ISA card, the Roland MPU-401. Not many people had an MT-32 back in the day because it was so expensive. However the developers at Sierra did, and so many games from that stable had special soundtracks written just for the MT-32. The difference compared to the Adlib is just night and day - like the difference between a basic Bontemi Keyboard and a Yamaha DX7.

These days MT-32s are pretty expensive (I mean, cheaper than they were new, but still more than just "fun money"). A cheaper option is to run the [MT32-Pi](https://github.com/dwhinham/mt32-pi) firmware on a spare Raspberry Pi. This open-source project faithfully emulates the MT-32, provided you can give it some *ahem* legally obtained original ROM images.

One major setback with the Adlib was the lack of PCM samples - you could have music, and beeps and boops, but no gun shots, and no sampled screams from the alien monsters you were shooting. In 1989 Creative Labs fixed this with the [Sound Blaster](https://en.wikipedia.org/wiki/Sound_Blaster) - basically an Adlib with added 8-bit mono 23 kHz PCM channel for sound effects. This quickly replaced the Adlib as the must-have sound card for PC, but because the FM synthesis was the same as the Adlib, games often supported both (you just didn't get any sound effects if you didn't have a Sound Blaster). Later revisions included the Sound Blaster Pro, which added stereo PCM audio, Sound Blaster Pro 2, which upgraded the FM synthesis to the backwards-compatible [Yamaha YMF262 "OPL3"](https://en.wikipedia.org/wiki/Yamaha_OPL#OPL3), and the Sound Blaster 16, which upgraded the PCM support to 16-bit stereo 44.1 kHz on a 16-bit ISA card.

In 1991, Roland relased the SC-55. Another external MIDI synthesiser, the main difference over the MT-32 was the adoption of the *General MIDI* standard. In theory this meant that music could be composed on one *General MIDI* synthesiser, and then when played on another, it would sound broadly the same. I'm not sure how well this worked in practice, but the SC-55 is the reference that many games were developed for. Again, most games expected you to have your SC-55 connected to an MPU-401 ISA MIDI interface, like the MT-32. Sound Blaster cards had some kind of rudimentary MIDI interface, but it wasn't MPU-401 compatible, and so game compatibility with MIDI on a Sound Blaster varies widely. Luckily for us, the MT-32 Pi can also load "Sound Fonts" sample packs into its FluidSynth engine, and a wide selection of General MIDI "Sound Fonts" are available, including some very faithful replicas of the SC-55. Games like Doom (1993) have General MIDI support, but not MT-32 support, so the gaming landscape seems to have switched over fairly quickly.

In 1992, a new sound card arrived - one that wasn't Sound Blaster compatible. The Gravis Ultrasound, from Advanced Gravis, had 256K on-board RAM and hardware-based sample mixing using its on-board DSP, taking a bunch of load of the PC's under-powered and over-worked CPU. Games like Epic Pinball used this to great effect, playing quality Amiga-style sample based audio on a 386, when you'd need a Pentium to get the same performance using software-based mixing with a regular Sound Blaster card. This CPU-offloading also meant it was popular in the demo scene, helping eek out every last cycle of performance from any given CPU. However, the 1990s also saw CPUs go from a 33 MHz 486DX to a 1000 MHz AMD Athlon in just 10 years, so after about 1995 the extra support from the sound card became moot because CPUs could just do it all. Therefore not many games supported the Gravis Ultrasound, but those that did sounded great. Of course, hardware that's widely regarded but sold in limited quantities 30 years ago has become highly sought after today. If you can't afford a Gravis Ultrasound, you can use a [PicoGUS](https://picog.us/) instead. This is an ISA card fitted with a Raspberry Pi RP2040 microcontroller and a simple DAC. The RP2040's dual Arm Cortex-M0+ cores can be programmed to emulate a Gravis Ultrasound with excellent compatibility. As a bonus, you can also load Sound Blaster compatible firmware, or an image that gives you a Roland MPU-401 interface. And it's a fraction of the price of a used Gravis Ultrasound. A real bargain.

In 1994, we got the last major advance in PC audio - the Sound Blaster AWE32. This was a Sound Blaster 16 with an EMU8000 sample based sythesiser bolted-on. The design was later cost-reduced into the AWE64, and literally gold-plated for the AWE64 Gold, but all had the same EMU8000 processor. It came with a 512K ROM that contained some passable General MIDI sounds, along with a reverb and chorus engine that produced some pleasing sounds. But Creative Labs gave it a unique API instead of making it accessible as a MIDI device over an MPU-401 interface (even though the card also had a sort-of MPU-401 interface on-board for external MIDI devices). This means that games needed to specifically support the AWE32. Doom did (in a patch release), as did Tyrian (from 1995) and Screamer (also from 1995).

But the AWE32's reign as PC sound supremo was short lived - because the Multimedia PC was here, and that meant we had CD Audio. Games like 1996's Quake didn't bother with a MIDI soundtrack at all, instead filling all that spare space on the CD with a proper Nine Inch Nails sound track. Soon after that CPUs became powerful enough to decode heavily compressed but high quality MP3 files whilst still playing the game, and so the PC based sythesiser was rendered redundant from about 1996 onwards. Indeed, the AC'97 standard said nothing about MIDI - just 16-bit stereo at 48 kHz, and Windows 98 even shipped with a software based MIDI synthesiser, just in case you wanted to run some older software.

So that was it - PC sound exploded in 1987, and it was all over less than a decade later.

At the Synthesised exhibition I hope to have a:

* Pentium III @ 450 MHz
* Abit BE6-II mainboard
* Sound Blaster AWE64
* PicoGUS
* Diamond Viper V770 - nVidia Riva TNT2 Pro graphics card
* Adaptec AHA-2940UW SCSI card with 9GB SCSI Hard Drive
* MT-32 Pi with MT-32 ROMs and SC-55 SoundFont

I will be running:

| Game                  | PC Speaker | Adlib | Sound Blaster | MT-32 | GUS | SB16 | General MIDI | AWE32  | CD Audio |
| --------------------- |:----------:|:-----:|:-------------:|:-----:|:---:|:----:|:------------:|:------:|:--------:|
| Police Quest II (‘88) | 💥          | 💥🎼    |               | 🎼     |     |      |              |        |          |
| Duke Nukem (‘91)      | 💥          |       |               |       |     |      |              |        |          |
| Wolfenstein 3D (‘92)  | 💥          | 💥🎼    | 💥🎼            |       |     |      |              |        |          |
| Lemmings 2 (‘93)      | 💥          | 💥🎼    | 💥🎼            | 🎼     |     |      |              |        |          |
| Doom (‘93)            | 💥          | 🎼     | 💥🎼            |       | 💥🎼  |      | 🎼            | 🎼(‘94) |
| Epic Pinball (‘93)    | 💥          |       | 💥🎶            |       | 💥🎶  | 💥🎶   |              |        ||
| Sam and Max (‘93)     |            | 🎼     | 💥🎼            | 🎼     |     | 💥🎼   | 🎼            |        | 🎶        |
| Tyrian 2000 (‘95)     |            | 🎼     | 💥🎼            |       | 💥🎼  |      | 🎼            | 🎼      ||
| Screamer (‘95)        |            |       | 💥🎼            | 🎼     | 💥🎼  | 💥🎼   | 🎼            | 🎼      | 🎶        |
| Quake (‘96)           |            |       | 💥             |       |     | 💥    |              |        | 🎶        |
| Screamer Rally (‘97)  |            |       | 💥             |       | 💥   | 💥    |              |        | 🎶        |

*Key:* 💥Sound Effects, 🎼 MIDI music, 🎶 PCM sampled music
