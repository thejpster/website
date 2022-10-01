+++
title="LCD Frustration"
date="2013-12-20"
+++

So, I've been trying to get this Displaytech LCD module to function, as part of the Mazda's TFT dashboard. Without the aid of a scope or logic analyser, it was extremely difficult to debug the 8-bit parallel (8080 style) interface. So, I've managed to lay my hands on a Salea Logic16 - the most amazing logic analyser I've ever used. The software is just gorgeous, even under Linux. Unhooking my board and connecting the analyser instead, very quickly I was able to determine that the Displaytech module's on-board Atmega is sending valid commands at the panel on startup, configuring it as 480x272 as expected. Because when my Stellaris board comes along and reads out those registers I'm getting absurd values (15 x 793), this means my board is probably pulling a line during the critical startup phase. Next stop - connect it all back together and probe with a scope to find out what I'm doing wrong. 

