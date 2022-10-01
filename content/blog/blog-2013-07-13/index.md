+++
title = "Raspberry Jam!"
date = 2013-07-13
+++

A couple of months ago, I went to a Raspberry Jam in Cambridge at the Centre for Mathematical Science. It was a great day out and I met some really interesting people, but the vending machine was a) a long way away and b) terrible anyway, and we had a lot of people in a small meeting room. "Next time", I bravely announced, "you should come over to my office. We'll lay on coffee and everything..."

Well, fast forward a few months and quite a lot of planning, and the second Cambridge Raspberry Jam of 2013 came to Cambridge Consultants.

Mike Horne is the local Raspberry Jam organiser and we're all very grateful to him for arranging these Jams and giving us Pi enthusiasts somewhere to go and talk about what we love. Mike arranged all the ticketing, the demos and the speakers. I arranged with Darina at Cambridge Consultants so we could borrow the reception area, and have teas and coffees and cakes laid on, name badges, etc. Many thanks for Darina for sorting this!

Myself, Mike and our two marshals (Rebecca Hoath and Alan Egan) arrived early to get set up and help those with demos. Thanks to our marshals for coming in to work on their day off and helping make the day a great success.

We kicked off with a brief hello from Mike, followed by an introduction to Cambridge Consultants by Tim Fowler. Tim talked about what Cambridge Consultants do and some of the projects they've worked on in past. These include internet radios, satellite telephones, round tea bags for Tetleys (yes, really) and the ground breaking VideoCore processor which they span out as a company called Alphamosaic. That spin-out was then bought by Broadcom about 9 years ago and it formed the basis of Broadcom's Mobile Multimedia division. That division is, of course, responsible for the Raspberry Pi, which contains a fourth-generation VideoCore processor at its heart.

We had six excellent presentations on the day (including one surprise addition at the end). I'll try and recap them briefly here.

Up first was Ryan Walmsley. Ryan talked about his first year with the Raspberry Pi and listed the many projects he's been working on. You'll most likely know of Ryan through his Rastrack website, which now has 30,000 Raspberry Pi's listed and is registration is included as an option in the standard raspi-config script. He also talked about his efforts getting Raspberry Pi recognised as a valuable distributed computing platform, demonstrating some examples he'd built on the BOINC platform.

Up next was the original Raspberry Pi designer Gert van Loo. Gert gave a really interesting talk on designing electronics for mass production. Did you know, the cost of a small capacitor or resistor is dwarfed by the proportional amount it costs you to hire the pick and place machine for the half-second it takes to lay out the component? For example, if you can get four resistors in a single package but they happen to cost, say 10 times the price, that might not actually be a bad deal because the robot will lay one large part much quicker than four smaller ones. Quicker layout means more boards per hour which means less cost per board. He also talked about the value of adding lots of 'just in case' options to your early designs - although you will of course always forget to add the one you need - and the simple joys of the physical effects you can generate when working with embedded programming. As an embedded engineer, I second that sentiment entirely.

Gert also brought along his son, David, and four Raspberry Pis set up to the audience to try their hand at embedded programming and drive a few Gertboards. This was a very popular activity.

I took the third presentation slot and talked about the work I'd been doing at Cambridge Consultants with the Zoological Society of London (ZSL). We've been building some remote camera traps for wildlife monitoring, but working with the tricky requirement that they had to upload images to the internet in near-realtime, from anywhere on the planet. Oh, and they had to last for ages on a single charge, survive extremes of temperature, submersion in water, angry hyenas, the usual. We've built some prototype cameras using Atmel XMega processors for low power consumption, and linked them with a bespoke wireless protocol to a central node, which houses a Raspberry Pi and an Iridium satellite modem. This modem incidentally, was designed by Cambridge Consultants so we know it inside-out. I was also able to share some pictures of the field trials - undertaken in an actual field at ZSL Whipsnade Zoo!

We then took a break for coffee and cake and everyone had a chance to look around the exhibits in the atrium people had brought along for the day.

Suitably refreshed, we sat back down for our fourth talk, which was given by Boris Adryan. Sticking to our entirely accidental "Embedded Engineering" theme, Boris talked about the trials and tribulations of monitoring the temperature of his wife's greenhouse wirelessly and how he was then able to use the technology at work to diagnose a dodgy refrigeration unit whose demonstrably poor temperature control was causing problems with some of his experiments.

Our fifth and final scheduled speaker was Jim Darby who also continued the embedded theme, by talking about how the Arduino board can be used in conjunction with a Raspberry Pi. Rather than using a slideshow, Jim bravely proceeded to talk through a whole series of live demos, from using a Pi to program an Arduino with a basic 'blinking light' demo, through to his amazing chain of colour changing LEDs, arranged as a 600-bit shift register. Here's a brief video and remember, each of these LEDs is individually controllable, so just about any pattern conceivable is possible:

{{ youtube(id="_ye1tVV5qXc") }}

Our final 'surprise' speaker of the day was High Altitude Balloon hero Dave Ackerman, who regaled us with tails of chasing his balloons across Europe, having sent them up so high they were able to take pictures of the curvature of the earth. Dave also brought along his latest project - a Babbage bear from the Raspberry Pi shop that had been stuffed with a Raspberry Pi, batteries, camera and long-range wireless modem. Babbage hung around the Cambridge Consultants atrium, taking in the view and broadcasting it live to anyone in the area with a suitable receiver.

We then retired to the atrium again to chat and look around some more demos. The event was so popular, people stayed around for over an hour past the official closing time. It's just too much fun talking to like minded individuals about all the projects we either have undertaken or want to undertake next!

I was very grateful that Eben and Liz Upton could join us on the day and I know many of the jammers were very excited to meet them in person.

I'm looking forward to the next Jam already!

{{ gallery() }}




