+++
title="VeeCAD"
date="2011-09-24"
+++

I was recommended to try VeeCAD by a colleague who's a member of [CMES](https://www.cambridgemes.co.uk).

I polished up my schematic in Eagle and, using the VeeCAD recommended export script, generated a netlist that VeeCAD could open. The advantage over diylc is that it tells you when you've not followed the netlist, allowing you to move components around until they fit nice and tightly together while knowing the circuit should still work. The disadvantage is it's slightly less pretty than diylc and it's a touch more fiddly to pick up and move components.

This schematic has 8 high side 12V outputs and 8 strobed 12V output pairs, so it will drive 4 2-aspect signals and 8 points. I think that means I'll need three of these and another, smaller, board that does just the signal outputs. The boards take as an input a 4 wire SPI bus and two pins to control whether the points are driven left or right (it didn't make sense to lose two pins off every MCP23S17 to do this), plus 12V, 5V and GND. The only thing I haven't added is smoothing capacitors for every IC, but there's plenty of spare board space for that.

{{ gallery() }}
