+++
title = "Back to our regular programming"
date = 2015-07-14
+++

A recent holiday gave me time to catch up on things. One of them was the electronics to control the automatic signalling for my model railway.

I found an interesting chip from ONsemi. The NCV7608 is a 8-way FET driver with SPI interface. The particularly useful feature is that it exposes both drain and source on each of the 8 output FETs, allowing it to be used for high-side and low-side applications.

A small PCB with an [NCV7608](http://www.onsemi.com/pub_link/Collateral/NCV7608-D.PDF) could operate 8 colour signalling aspects, regardless of whether they were wired common-anode or common-cathode and regardless of the voltage the resistors were set for. With an RDS(on) of 1.2 ohms, the chip can source (or sink) a fair amount of current before going pop, so you could also use it as a relay driver to operate points (although perhaps driving the points directly might be a bit ambitious).

I feel some Eagling coming on.