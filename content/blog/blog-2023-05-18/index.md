+++
title = "You can now load from disk..."
date = "2023-05-18"
+++

Over the past couple of weeks I've been working on SD Card support for the Neotron Pico. The broad schedule ran like this:

1. Detect when a card is inserted into the slot.

2. Detect when a card is removed from the slot.

3. When a BIOS "List Block Devices" API is called, initialise the SD Card and report its actual capacity.

4. Remember the fact that the card is initialised so we don't initialise it again needlessly.

5. Update the Neotron OS so it can read and write arbitrary blocks from disk. Test this using the Neotron Desktop BIOS and a disk image.

6. On the Pico BIOS, support the "Block Read" and "Block Write" BIOS API calls.

7. On the Neotron OS, implement the BlockDevice trait from the SD Card library over the BIOS API calls, and implement a basic DIR command.

8. Change the OS "load" command to load a file from disk into RAM, instead of reading keyboard input.

9. Profit!

Somewhere in there was a step around "re-write the embedded-sdmmc crate so it makes more sense internally, and so it allows you to create a new driver object (unsafely) without rebooting the SD Card".

{{ youtube(id="GsJM-4GaIEM") }}

Right now, I have branches open on three different projects (Neotron Pico BIOS, Neotron OS and embedded-sdmmc) and I need to close them and push out updated versions in the right order, so the next one in the tree can depend on a published version of the previous one ... but if you have all the right branches checked out, you can do something like this:

Now, it's a [real computer](https://www.youtube.com/watch?v=7Fa-69AhxPg)!
