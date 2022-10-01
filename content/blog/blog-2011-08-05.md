+++
title="Darlington Pairs"
date="2011-08-07"
+++


I spent some time today deciding whether I could use a 7 or 8 channel Darlington Pair IC (like the ULN2003A) to drive the point motors. They can only handle 500mA per channel, but it's possible to parallel up multiple ICs to increase the maximum current. The problem is the Vce(sat) is 1.2V and sinking 500mA means each IC will have to dump 600mW of power somewhere. It's nice that the chips are under [20p each](http://uk.farnell.com/texas-instruments/uln2003ane4/darlington-array-7npn-2003-dip16/dp/1210973), but I'd need a lot of chips to drive all 19 point motors (19 solenoids x 2 coils x 3 channels per coil / 7 channels per chip = 17 chips). That's an awful lot of soldering.

The other option is MOSFETs. They can handle huge loads without wasting too much power as heat, so I only need one per motor coil. You seem to have to buy them a singles - there aren't any cheap 7 or 8 way packages. They cost around ~~[65p each](http://uk.farnell.com/fairchild-semiconductor/rfp30n06le/mosfet-n-logic-to-220/dp/1017798?Ntt=RFP30N06LE)~~ [56p each](http://uk.farnell.com/vishay-formerly-i-r/irlz34pbf/mosfet-n-60v-30a-to-220/dp/8651400) if you buy a few (I'd need around 40). But, if you're spending £1.30 per point on MOSFETs, why not just spend £1.77 on an [SN754410](http://uk.farnell.com/jsp/search/productdetail.jsp?sku=9592997). It's almost exactly like an L293N, rated to 2A and will drive two points, so works out at 89p per point and involves less soldering as there are no resistors to worry about.

I am definitely satisfied that the SN754410 or L293N is the way to go. Until I change my mind again, anyway.

Edit: Turns out the SN754410 is only 1A per channel (2A per device). The L293D is 1.2A per channel. I will need the full-fat [L293N](http://uk.farnell.com/texas-instruments/l293ne/ic-driver-half-bridge-4-ch-35ma/dp/1564967), rated to 2A per channel.