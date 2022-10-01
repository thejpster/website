+++
title="Wires"
date="2011-08-14"
+++

Well, it's pretty good on board size, but perhaps I should expand it a few rows to try and tidy up some of the wiring.

I drew it using DIY Layout Creator 3 (beta). It crashed a couple of times (and, to be fair, the wiring is insane), but the autosave recovered me perfectly and it's far faster than Fritzing.

The top bank of resistors is to drive common-cathode pairs of LEDs. This is because that's how the Berko signals come (I believe) and it was easiest to make the repeaters on the panel work the same way. The bank of resistors below that show the status of the points on the panel, and they use two LEDs top-to-tail with a switched centre. I did that to halve the number of outputs needed, at the expense of doubling the number of resistors. The bank below that are the four MCP23S17 I/O expanders (three of which have UDN2981 source drivers fitted to drive the signals) and the bottom bank are the L293 motor drivers. I will set every side of every L293 to high/low or low/high simultaneously (bad things will happen if I set it high/high!) and strobe the enable lines for the points to be set, one at a time. 

Edit: The picture is now lost to time
