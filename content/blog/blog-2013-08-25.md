+++
title="Projects"
date="2013-08-25"
+++

There's so much going on at JP Towers that I feel the need to write some of it down,  lest any of it leaks about of my brain.

I've talked about the Jaguar radio upgrade before so that's one.

I'm planning to implement while house temperature monitoring. This will use the cat6 running to (almost) every room and Dallas one-wire temperature sensors. I'll probably drive them as multiple busses using at Arduino as there are issues configuring a star as a single 'bus'. The sensors are in and have been tested on the Arduino,  I just need to build an adapter to connect to my patch panel and build some sensor 'plugs' using standard 8P8C shells.

I've got a new boiler going in soon.  I've selected a Viessmann 200-W a it has an IR control interface.  This will allow me to disable the heating when we're out and restart it on our journey home using my phone. I can probably use the Arduino for this as well as it'll be in roughly the right location anyway.

My brother has fitted a quad-cam Lexus V8 (1UZ-FE) to his Mazda Bongo camper to replace the broken 2.5 diesel. Mechanically it is all fine but issues with the dash and the speed / RPM pickups mean we probably can't use the old dash clocks unchanged. The Lexus tacho needle driver will fit but the frequency of the input needs adjusting to get the numbers correct. For the speedo we've decided it'll simply be easier to fit a TFT where the speedo was and use a Stellaris Launchpad to output speed and odo/trip on the LCD. I did order a couple of cheap TFT modules off eBay - 2.8" units with an ILI 9325 driver and an SD card slot -but one was cracked in transit and neither appear to work at all. RS have something similar,  but a bit bigger, so I'll give those a try. I also need to build a circuit to interface the micro with the 12v logic used by the Lexus electrics, but I'm hopeful I can use a standard USB PSU.