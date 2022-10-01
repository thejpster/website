+++
title = "Welcome!"
date = "2011-07-01"
+++

I'm considering adding some form of electronic control to my N-gauge model railway.

It's a fairly compact layout, at 5' x 3' (approx 1500mm x 900mm), but has around 16 points. I'm done the layout in AnyRail and will post up the schematic soon.

I've ordered an Arduino Uno (http://arduino.cc/) to get things rolling on the automation side, along with:

* Microchip MCP23S17 16-pin I/O expander with SPI interface - http://uk.farnell.com 
* Texas Instruments L293 rated at 2A (not the weedy 1.2A L293D) - http://uk.farnell.com 
* Some LEDs and 330 ohm resistors (so about 13mA @ 5V) - http://uk.farnell.com 
* Some breadboard and jumper wires - http://oomlout.co.uk

The idea behind the port expander is that the Uno doesn't have many pins, and the Arduino Mega is a bit pricey (~£50, as opposed to ~£20). You can think of the MCP23S17 as an upgrade to the common 74HC595 shift register. Controlled via SPI, you can set each of the 16 pins as an input or an output and generate interrupts when the inputs change. It'll handle around 20mA source/sink, so it should drive some LEDs for testing.

I've also taken the opportunity to lean gEDA, the schematic editor for Linux. I've made some symbols for the L293 and the MCP23S17. I'll upload those soon, too. 

Edit: JP from 2022 here. These old posts are copied from my old blog "Railway Electronics" which used to be at http://railwayelectronics.blogspot.com/ (since defunct thanks to Google deciding to start charging me a lot of money for my Google for Domains account).
