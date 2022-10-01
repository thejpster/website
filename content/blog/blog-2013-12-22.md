+++
title="LCD Success!"
date="2013-12-22"
+++

I can now blit coloured rectangles to a small 4" LCD. Bloody /RD (pin E1) was stuck as an output, even though I'm clearly telling it to be an input. This broke the LCD self-init. Why will have to wait for another day - for now, I've unplugged it.

In other news:

* I can't set optimisations to O2 or O3 without my code crashing on startup. O1 is fine.
* Function calls appear to be very slow on the LM4F. Inlining a bunch of stuff speeded it up no end.
* Even with heavy inlining, it's still taking a while to draw the screen. We'll see how it goes when I'm rendering glyphs instead of boxes. Plus, 16 bit mode will help - I'm writing 3 bytes per pixel at the moment.


