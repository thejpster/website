+++
title = "Back again with The History of PC Audio"
date = "2026-06-27"
+++

Two years after [the last Synthesised event](@/blog/blog-2024-06-29/index.md), I was back again with a revised *History of PC Audio* exhibit.

The hardware is largely the same as before, but with a new hard drive and a new graphics card:

* Pentium III @ 450 MHz
* Abit BE6 mainboard
* Sound Blaster AWE64
* PicoGUS
* 3DFX Voodoo 3 AGP
* 9 GB IBM Deskstar Hard Drive
* MT-32 Pi with MT-32 ROMs and SC-55 SoundFont

The PicoGUS also has some firmware upgrades, as with a single firmware image it now supports:

* MPU-401
* Sound Blaster 16 / Adlib
* Gravis Ultrasound
* Tandy 3-voice
* Creative Music System

I also prepared an MS-DOS interactive batch file, which would configure the PicoGUS into the correct mode, and then launch a suitable game or audio player to demonstrate that mode. That script looks like this.

```text
@echo off
:start
cls
echo This is the History of PC Audio Demo
echo.
echo Pick a synthesiser
echo.
echo 1. The PC Speaker
echo 2. The Tandy 1000 / PCjr (TI SN76496) 
echo 3. The Adlib Music Synthesiser
echo 4. The Sound Blaster
echo 5. The Roland MT-32
echo 6. The Gravis UltraSound
echo 7. The Sound Blaster AWE32
echo 8. The Roland Sound Canvas SC-55
echo 9. Quit Demo
echo.
CHOICE /C:123456789 "What do you want to hear today? "
if errorlevel 9 goto exit
if errorlevel 8 goto sc55
if errorlevel 7 goto awe32
if errorlevel 6 goto gus
if errorlevel 5 goto mt32
if errorlevel 4 goto soundblaster
if errorlevel 3 goto adlib
if errorlevel 2 goto tandy
if errorlevel 1 goto pcspeaker

:pcspeaker
echo PC Speaker demo
echo.
echo Let's play Lemmings 2: The Tribes, but you only
echo get a PC Speaker for sound effects. Make sure to play a level.
echo.
choice Play Lemmings?
if errorlevel 2 goto start
pgusinit /mode mpu
cd l2
copy pcspk.ini l2.ini
l2-fix
cd ..
goto start

:tandy
echo Tandy 1000 / PCjr (SN76496) demo
echo.
echo To hear the Tandy 1000 (which has the same SN76496 Programmable
echo Sound Generator as the PCjr, Sega Master System, and many more,
echo we're using the PicoGUS in "PSG" mode. Sound comes from the SBVGM
echo command-line player to play a tune from the original version
echo of Lemmings.
echo.
choice Play SBVGM?
if errorlevel 2 goto start
pgusinit /mode psg
sbvgm -t2c0 lemming.vgz
goto start

:adlib
echo Adlib demo
echo.
echo Let's play Lemmings 2: The Tribes, but with an
echo Adlib Music Sythesiser. Glorious OPL2 music!
echo.
choice Play Lemmings?
if errorlevel 2 goto start
pgusinit /mode mpu
cd l2
copy adlib.ini l2.ini
l2-fix
cd ..
goto start

:soundblaster
echo Sound Blaster demo
echo.
echo Let's play Lemmings 2: The Tribes, but with a Sound
echo Blaster card. Adlib music, and sampled sound effects.
echo.
choice Play Lemmings?
if errorlevel 2 goto start
pgusinit /mode mpu
cd l2
copy sb.ini l2.ini
l2-fix
cd ..
goto start

:mt32
echo Roland MT-32 demo
echo.
echo Let's play Lemmings 2: The Tribes, but with a Roland
echo MT-32 doing the music, and a Sound Blaster card for the effects.
echo.
echo This is peak PC sound in 1989! Very few could afford it.
echo.
choice Play Lemmings?
pgusinit /mode mpu /mpudelay 1
if errorlevel 2 goto start
mt32pi -m
cd l2
copy mt32.ini l2.ini
l2-fix
cd ..
goto start

:gus
echo Gravis UltraSound demo
echo.
echo Epic Pinball famously came with a sample-based soundtrack instead
echo of one that uses an FM or MIDI synthesiser. The Gravis UltraSound
echo could play these samples in hardware, saving precious CPU time.
echo.
choice Play Pinball?
if errorlevel 2 goto start
pgusinit /mode gus
cd pinball
pinball
cd ..
goto start

:awe32
echo Sound Blaster AWE32 Demo
echo.
echo To demonstrate the EMU-8000 wavetable sampler fitted to the
echo Sound Blaster AWE32, we're using classic top-down shooter
echo Tyrian 2000. Try the jukebox!
echo.
choice Play Tyrian 2000?
if errorlevel 2 goto start
rem Just in case you want to try General MIDI mode
pgusinit /mode mpu
mt32pi -g
cd tyrian2k
setup
cd ..
goto start

:sc55
echo Roland Sound Canvas SC-55 Demo
echo.
echo The Roland SC-55 was THE General MIDI device of the 1990s.
echo What better way to celebrate, than a bit of Doom E1M1?
echo.
choice Doom?
if errorlevel 2 goto start
pgusinit /mode mpu
mt32pi -g
cd doom
doom
cd ..
goto start

:exit
echo OK, bye! Type DEMO to restart.
```
