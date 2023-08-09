+++
title = "LQFPs are confusing"
date = "2021-06-27"
+++

I got the first five v0.5.0 boards back. They look great! I tried soldering on the LQFP-32 STM32 (which I had in stock but JLCPCB did not), and it didn't go well.

The first one I soldered on rotated 90 degrees. Turns out the 'dot' is in the bottom left, not the top left. I'll have to get someone to fix that one with a hot air gun.

The second one went better, but was about 3 degrees out. This was enough to put the legs in between the pads on one side. No good.

The third seemed to go OK (thankfully - I only have one left!). So far, I've knocked up some firmware to blink the LEDs, check the UART and debounce the power button. It's all at <https://github.com/neotron-compute/Neotron-BMC>.
