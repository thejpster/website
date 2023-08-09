+++
title = "Audio and PS/2 port testing"
date = "2022-09-29"
+++

In the last post I referred to some testing of the Audio CODEC using CircuitPython. Here's a video showing the code, with the Neotron audio in the background.

{{ youtube(id="gvVBugIMrpM") }}

I also should mention that the PS/2 keyboard is being received on the BMC chip correctly, but work continues on getting data from the BMC to the main RP2040. Comms is working, but only at around 1 MHz currently. Here's a video showing programming the BMC, keycodes being sent to the laptop over the debug log, and the PC Speaker doing a short beep for every keypress.

{{ youtube(id="Jwu3ziLYEgk") }}
