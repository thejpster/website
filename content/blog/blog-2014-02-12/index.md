+++
title="TFT up and running"
date="2014-02-12"
+++

Some success!

I'd been flailing around for a few days, trying to debug the more analog parts of my PCB. I was seeing a 5V rail at around 2V and my board reset when the backlight was connected, but fine without the backlight. This was all not helped by the fact I found I have at least two brand new micro USB cables that don't work (board lights up, CPU just resets - different cable, works perfectly).

So, I've removed the three MIC2005 high side switches and soldered some nice fat wire between the 3.3v input of the LCD and the 3.3v output of the Launchpad, and between the 5V input, Launchpad 5V pin and the backlight power pin.

Success!

If I can't get the load switches to work, it's possible I can get the LCD power consumption down to a manageable level electronically. If that's too high to remain on all the time, I'll probably need to build and off-board power control circuit. I have a spare output pin I can use to indicate "Do not power off" and with a few diodes and a small relay I'll have something that comes on with the ignition and turns off when the micro is happy to turn off.

{{ gallery() }}
