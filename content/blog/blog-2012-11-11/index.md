+++
title="Jaguar / Alpine AJ9500R radio / cassette"
date="2012-11-11"
+++

There was a slight mistake in the last pinout, which I've now corrected. Looking at other Alpine M-BUS pinouts (search for S601 on this page), it appears to be exactly as per the standard, except they've swapped the central ground pin with the M-BUS data pin. I suppose this is to thwart those trying to add a generic Alpine changer.

While I've got all my electronics stuff over the dining room table, I thought I might take the AJ9500R radio apart and try and find out why it has sporadic memory failures. The symptoms are, no control over volume on power up and, if it's been unplugged, inability to recognise the correct radio code (although when that happens it also doesn't record the incorrect attempts count so you can just power cycle it and try again). I'm guessing this is a failure of the EEPROM memory.

Here's the PCB. The EEPROM is the X24C01 in the centre labelled IC502.

There are datasheets online. I might try and tack on a tiny wire and monitor the I2C interface to see if the chip is returning sensible results or garbage. New ones are available from Farnell.
