+++
title="A quick word on fonts"
date="2014-02-11"
+++

I mentioned before that I might patch the font render to handle proportional as well as monospace. The eagle eyed will notice from the last post that I did. I also changed the font to something a little less CGA and a little more 21st century.

The font fix was easy - add a byte to the start of each glyph describing the actual width of the glyph. I then wrote a tool which worked out the maximum width of each glyph, to save a lot of tedious calculation. Fun arose when I found out the font I was using had glyphs centered in the box rather than left aligned like a sane person might do. Nothing some 16-bit left shifts couldn't fix though.

The font I'm using is Hallfetica Normal from http://www.henningkarlsen.com/electronics/r_fonts.php. 