+++
title="Moving in a different direction"
date="2012-10-28"
+++

I recently purchased a 1995 Jaguar Sovereign (you might know it as a Jaguar XJ, but the Sovereign spec doesn't actually wear an XJ badge anywhere). It has a CD changer in the boot and a radio/cassette in the dash. The radio is rumoured to only accept a specific model of CD changer while using the Alpine M-BUS protocol. What I want to do is build an M-BUS to UART adaptor out of an Arduino, or a TI Stellaris Launchpad (mine's on back order) and use that to control a Raspberry Pi running an MP3 playback daemon. Six disc buttons gives you six playlists and the skip forwards / backwards should be usable too.

While I wait for the Launchpad, I've been putting my Arduino to use trying to probe the data pins, without too much success I might add. What I have managed to do is:

* Build a 5V switch-mode power supply to turn the car's 12V (or actually 10V to 14V) supply into something the Arduino (and a Raspberry Pi) can handle. I'm using the LM2576 of which I picked up three off eBay at £1.20 each.
* Power the radio up on the bench, along with the CD changer. The changer gets all its power and data from one 8-pin DIN cable.
* Probe the 8-pin DIN pinout.

The 8 pin DIN cable has inside, the following colour wires (numbered is as you look at the pins on the male, or the solder buckets on the female):

* Brown - pins 4 and 5. Always at 0v.
* Yellow - pin 7. Permanent 12V.
* Red - pin 6. Switched 12V.
* Black - pin 8. Always at 0V.
* Audio Right, Audio Left and Audio Ground in a separate bundle (pins 2, 3 and 1)

I've connected the Arduino to every pin (using a CD4049 hex-inverter / buffer I found in a kit of PSU components) and saw nothing changing. Looking back at the results, I'm wondering if Black is the data bus but that it requires the CD changer to pull it up. What I need to do is wire up the 8 pin plug and an 8 pin socket back to back with a bit of stripboard in the middle so I can sniff what's going on. The trouble is, the 8-pin DIN socket on a flying lead that I bought off eBay is confusing...

* Pin 6 is blue
* Pin 7 is red
* Pin 1 is both black/yellow and black
* Pin 2 and 3 are yellow and white (audio)
* Pin 4 is green
* Pin 5 is brown
* Pin 8 is n/c

So, I can't use this connector as the pin I suspect Jaguar use M-BUS (pin 8) is n/c and the audio ground (Pin 1) comes out on two separate wires. Removing the back of the connector confirms this - there's nothing connected to pin 8. Still, it looks like I should be able to add an extra wire in to that middle pin if I'm careful.
