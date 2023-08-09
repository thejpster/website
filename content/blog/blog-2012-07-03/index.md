+++
title="Relays"
date="2012-07-03"
+++

It turns out you can get relays from Farnell for about 55p each. You need two SPST relays per point, plus something that can switch the 30mA coil current @ 12V DC. Having played about with PCB schematics and vero-board layouts, I'm starting to think relays would be a more robust option than the L293 drivers. It also frees me up to purchase standard Peco motors rather than the 2A 'E' high-efficiency motors, and reduces concerns with regard to supplying the motors from a capacitor discharge unit. I may even be able to throw two points in a crossover on one output. Whereas the signals are common cathode, the relays are single coils which work in either polarity. As the UDN2981 (8 way high-side switch) and ULN2803 (8 way low-side Darlington array) are largely pin compatible - you just need to switch the GND and 12V over - I can use the cheaper ULN2803 fitted to the signal control boards for controlling the relays, which reduces the BOM by a couple of pounds per board. Then all I need is a board containing the relays (and possible a home made CDU). This board could even be built first and operated with push switches in order to test the points. 

