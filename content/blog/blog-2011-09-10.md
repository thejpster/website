+++
title="Signals and Testing"
date="2011-09-10"
+++

I went to the March and District MRC show today. Talked to some great people - made me really enthusiastic about getting stuck in to it all again. www.layouts4u.net had a stand there. I had a look at some N-gauge suitable signals from CR signals. These are the first signals I've seen up close as I've only seen the Berko ones on-line. They have small enamelled copper flying leads with pre-fitted resistors for 12V operation on the two anodes, with a common cathode return. This simplifies the veroboard somewhat as I won't have to worry about the resistors. I am concerned about what to do with the signals while the layout is in storage though. My best suggestion so far is to pull them out of their mounting holes and clamp them to the track using magnetic straps. 

I also tested the L293 driver and I'm hugely surprised to be honest. I expected more fire, or at least some melting.

Edit: JP from 2022 here. The video has been lost.

I do have a problem with the L293 on power up - it drives all four outputs high for a few seconds until the MCP23S17 is initialised. I think if I pull the enable lines low this should stop. Probably not good to drive every point on the layout in both directions simultaneously for a second. Certainly not at 1.2A per point per direction!

Incidentally the diodes you can see on the reverse of the motor are the flyback diodes. These are ultra-fast UF4007s, because that's what I had to hand. I really need to leave it on a soak test to see if the L293 survives.
