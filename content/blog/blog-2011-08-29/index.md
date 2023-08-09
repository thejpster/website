+++
title="Bluetooth"
date="2011-08-29"
+++

I've spent the past couple of days re-laying track. I'd laid the two outer loops with Gaugemaster foam underlay, but it doesn't seem particularly compatible with Peco point motors. When I laid the track, that wasn't a problem, but now I want to automate everything, it is. So, the track's coming up in sections and I'm drilling ~6mm holes under one end of the tie bar on each point. I have one motor on a mounting plate that I'm offering up to check the holes are large enough and aligned correctly - you'd be surprised how hard that is to do.

I've also decided (for today, at least) that wiring up indicator lamps and push switches is all too 1980s. I think I'm going to start by connecting the Arduino to my laptop and developing a serial protocol for activating the points and signals. The upgrade path is then to connect over Bluetooth using Serial Port Profile to either my Nokia N900 or one of those dirt cheap Android tablets that seem to be flooding the market at the moment.

While I was following down that avenue, it occurred to me that an L293 driven from one of the PWM outputs of the Arduino would make a passable train controller. I could then have both signalman and train driver apps, the latter offering full inertia simulation.

I've also been looking at [Raspberry Pi](https://www.raspberrypi.org) ARM based SBC. I have HDMI-enabled TVs in the rooms I'm most likely to operate the railway in, so I would run the signalman and/or train-driver apps on the Raspberry Pi and watch the output on the big screen. Again, I can start by working with the laptop.