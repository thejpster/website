+++
title = "New Bike!"
date = "2015-02-26"
+++

I decided to switch from taking the bus to work, to cycling. As it's about 14 miles each way, I thought the best starting point as an electric bike. Then, if it's a howling gale or horizontal rain, I'll still be able to make the journey without collapsing.

The bike I chose was the [Kudos Tourer](http://www.kudoscycles.com/) with Nexus 8-speed Hub. It's quite an interesting setup, and not very well documented, so I thought it was worth a few notes.

The battery pack slides on to a shelf on the rear pannier. It is a 36V nominal 10Ah pack, which charges up to 42 V open circuit. It has a key switch and the battery management and balancing must be internal. There is a four pin socket on the back, of which two pins are connected, and an RCA phono jack under the handle for charging. The charger is from Sans and its rated output is 42V 2A. My first battery wouldn't charge and my second had an intermittent cutout. Hopefully my third will be reliable!

The battery power comes into a hollow plastic box stuffed with wiring. Tidy it isn't!

The schematic is pretty simple. Battery voltage goes into the metal control box, via bullet connectors, and is also tapped off for the LED lights. You can see the red and black wires at the bottom of the picture above, with the blue/green bullet covers and the heatshrink where the lighting cables have been soldered on. and The lights operate via a latching switch on the handlebars made by Wuxing . The front light says it is a [Spanninga Owl](http://www.spanninga.com/products/headlamps/owl/), but it's wired in rather than battery powered. I can't tell the make of the rear light but both seem OK. There is no interaction between the lighting circuit and the motor controller - they both just run directly off the battery voltage.

The controller drives a [Bigstone C300 LCD](http://www.bigstone-nj.com/products/lcd-display/c300-0) via both a 4-pin and a 3-pin cable. I'm guessing one is LCD output and the other is the input from the four buttons. The interface is described on that page as "UART or CAN" so maybe I need to crack out the Picoscope and take a look. The control box also has has brake cutoff inputs from both brake levers (probably also from Wuxing), wheel speed input from a sensor on the rear wheel and an "axis input" which comes from a sensor on the crank. Motor output is via a yellow/blue/green 3 core cable labelled "Motor A", "Motor B" and "Motor C".  I've managed to find a copy of the user manual (edit: and since lost it again). It explains how to switch from km/h to mph and what all the various icons mean.

The controller itself is labelled BST-TY11050036, and something visually very similar is sold in kit with the C300 on Alibaba, but I can't find out much more about it. I'd open it up, but warranties and all that...

{{ gallery() }}
