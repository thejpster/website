+++
title = "Playing ProTracker files"
date = "2023-06-14"
+++

You can now buy Neotron Pico boards direct from Elecrow. See <https://www.elecrow.com/neotron-pico-rev-1-1-assembled.html>. I have very limited stocks, and they are priced at $99 each, for a PCB with all components fitted except the RP2040 and the CR2023 coin-cell. Just add SD Card, Monitor and Keyboard.

I also wrote a ['MOD' file](https://en.wikipedia.org/wiki/MOD_(file_format)) parser. This is the native music format for the program [ProTracker](https://en.wikipedia.org/wiki/Protracker), which ran on the Commodore Amiga. That machine had hardware support for playing four 8-bit samples at a programmable sample-rate (effectively at some integer fraction of the machine's main system clock speed). A ProTracker song is comprised of a song, which is a list of patterns to play. Each pattern contains 64 lines, and each line states whether to start playing a sample on each of the four channels, or not, and if so at what frequency and with which effect (pitch slide, volume slide, etc).

I wrote the parser first, in Rust obviously, and published it as <https://github.com/thejpster/neotracker>. I then wrote a proof-of-concept song player which uses the information parsed from the MOD file to process through the song, pattern by pattern and line by line, sending audio samples to the Portable Audio Library. This runs on Linux, macOS or Windows. Once that broadly worked, I wrote a new version of the player which could run on Neotron OS. For now, the OS just lets you open an `AUDIO$` device, and any bytes written there are copied to a ring buffer which is spooled out in the background to an RP2040 PIO block running an I2S program.

It's not perfect - a bunch of effects aren't handled properly, and I'm possibly not looping the samples correctly. But it's good enough to play some of the simpler files - here's a video of it in action:

<iframe width="560" height="315" src="https://www.youtube.com/embed/ONZhDrZsmDU?si=xUz-8gWdkz50lUxN" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
