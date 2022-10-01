+++
title = "Stuff has arrived!"
date = "2011-08-01"
+++

The Arduino Uno has arrived,. along with some other bits and pieces.

Firstly, the Arduino Uno is awesome. It's so simple to program. I didn't need to install any drivers (I use Ubuntu). The special Arduino IDE is very light on features, but that makes it very simple to use. I had an LED blinking on and off in no time at all.

The MCP23S17 had me baffled for a while, but I got it up and running eventually. The major pit falls were connecting both GND and VCC on the breadboard to GND on the Arduino (the pins are quite close together and my eyesight isn't that good). The second pitfall was using some example code that presumed I had tied the address pins one low and two high. I'd tied them all low. The third was that I need to strobe reset on power-up - something I'd not seen in any examples. As is usual, multiple intersecting bugs mean each makes the others really hard to find (I'd tried fiddling the addresses and moving the power pins, but never at the same time...). Anyway, it's now running.

I'm using the library from http://arduino.cc/playground/Code/Mcp23s17, but I've had to tweak it as the SPI library supplied with my version of the IDE has SPI spelled all in capitals, whereas the library seems spell it Spi. The API is compatible, fortunately.

I've been talking to some chaps at the office about the best way to drive my point motors and signals. Some searching (http://www.n-gauge.org.uk/BERKON.htm) suggests that the signals I want to use have two LEDs with a common cathode (negative pin). This means I need a high-side switch, which means an NPN transistor driving a PNP transistor. I have a couple of ideas for driving the point motors, but I'm starting with the L293 Half-H bridge chip, which works out at £2.30 each for 10 off, which will supply 20 points. It handles up to 36V but only 2A peak, so with the 11 ohm Peco PL10WE motors I can try up to 22V. When the test motor arrives, I'll start with 12V and see what happens.
