+++
title = "The Curious Case of the UNIX workstation layout"
date = "2025-07-19"
+++

## Background

Cathode Ray Dude recently did an excellent video about the history of the PC case, particularly the early- and mid-1990s, and the various mainboard layouts that pre-date the ATX standard. You should watch it. Here it is.

{{ youtube(id="LGoM3Sqr2-w") }}

The rest of this blog will contain some spoilers for that video.

## UNIX workstations

I have a bunch of 1990's RISC/UNIX workstations. I don't really know how it happened, but I went from having literally none back in October 2024, to having:

* Silicon Graphics Power Indigo²
* Sun Ultra 80
* HP 9000 Visualize B132L+
* HP 9000 Visualize C3000
* HP 9000 712 (running NeXTSTEP!)
* Apple PowerMac 7200/90 (ok, Mac OS 7.2 Is Not UNIX, but I could install Linux or NetBSD if I wanted to)

And watching CRD's video. I realised something.

## Silicon Graphics

The Silicon Graphics IRIS Indigo is a tower workstation of the old-school. A light make-over of the previous IRIS 4D series, it has two huge PCBs, which insert vertical into a backplane using rotating clips. I'm pretty sure it's actually a [VME bus design](https://en.wikipedia.org/wiki/VMEbus), both because of that Wikipedia page but because [SGI Depot describes them](http://www.sgidepot.co.uk/elanxs.html) as part of the "IRIS VME Series".

{{ image(img="blog/blog-2025-07-19/Sgi_indigo_mainboard.jpg") }}

(ctvoigt, CC BY-SA 3.0 DE <https://creativecommons.org/licenses/by-sa/3.0/de/deed.en>, via Wikimedia Commons)

But the Indigo² that came after it? Desktop case. Flat mainboard with ports on the rear. PSU on the right. Card riser on the left, with cards on the left. It takes standard PC SIMMs, and has PS/2 connectors for the keyboard and mouse. By jove it looks like LPX.

{{ image(img="blog/blog-2024-11-22/IMG_0152.jpg") }}

Eh, maybe it's a one-off.

## HP 9000

I have wanted a PA-RISC machine for a while, but now I find myself owning three. The HP 9000 series has a long and storied history, and you should just go and read <http://openpa.net> because it is an excellent resource.

My new HP 7000 712 is the machine that HP used to port NeXTSTEP OS to PA-RISC. So, obviously, I've installed NeXTSTEP 3.3 for PA-RISC. I should probably do a whole separate piece about that, because it's retro but also alarmingly familiar to this daily macOS user.

Anyway, the Model 712 looks like this inside, and at the rear.

{{ image(img="blog/blog-2025-07-19/712_inside.JPEG") }}

{{ image(img="blog/blog-2025-07-19/712_rear.JPEG") }}

Definitely not LPX. Much more evocative of low-cost pizza-box Apple Machintoshes of the period, like the Macintosh LC II.

But let's look at the follow-up model, the Visualize B-Class (in this case a B132L+).

{{ image(img="blog/blog-2025-03-22/b132l+ inside.jpg") }}

{{ image(img="blog/blog-2025-03-22/b132l+ slots.jpg") }}

It's a single flat PCB, with connectors at the rear, a card riser on the left with cards leaning to the left. The only weird thing is that the card riser has to be high enough to clear the PSU. But look - it looks really kinda of LPX-like, right? And very different to the model that came before it.

## DEC Alphastation

Early Alphastations were VME based machines. Like the Indigo, I've never had one, but I saw one at RetroFest 2025 in Swindon earlier this year.

I don't have a Creative Commons picture of the insides of a DEC 3000, but here's a website with a bunch of technical details: <https://www.chilton-computing.org.uk/ccd/mainframes/p012.htm>. It's definitely nothing like a PC.

But the Alphastation 500 I had (and failed to fix)?

{{ image(img="blog/blog-2025-07-19/alphastation_500.JPEG") }}

Connectors at the rear. A riser, with cards on the left. Sure looks LPX inspired to me. Also those power connectors look awfully like ATX power connectors (although they don't have the ATX pinout). And we've got standard PC memory, and PS/2 connectors for the keyboard.

## Conclusions

I have no conclusions here. Did Digital and HP and SGI all independently copy the Packard Bell and Dell PCs of the era? Or did they get together in some secret RISC UNIX cabal to re-use PC technolog and cut the price of entry (or, make more profit)? Or is the LPX desktop just the crab of personal computer design, and all lineages will converge here eventually. I have no idea.

But now, whenever I see a machine with ports at the back and a riser card on the left, with cards on the left, I'm going to think of CRD.
