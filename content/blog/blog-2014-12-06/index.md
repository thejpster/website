+++
title = "We're at PiWars"
date = "2014-12-06"
+++

## Intro

So Matt Lane, Matt Kingston and myself have spent the last few months putting together our entry for PiWars. We're very grateful to our bosses at www.cambridgeconsultants.com for allowing us to indulge in our hobby and supporting us with some of the parts. Last night was pretty hectic. I left the guys at about 11pm to catch my bus, but they stayed well after that. There are various challenge we need to complete and we're there or thereabouts for most of them:

* Line Following, autonomously
* Drive up to a wall without hitting it
* Chase a ball through a goal
* Drive flat out in a straight line
* Do a three point turn, autonomously
* Sumo challenge
* Aesthetics
* Code quality
* Obstacle course

Right now it's 10:40am and the we're up on the line following course at 10:55. I haven't seen many other tracked robots, so we're hopeful about the obstacle couse - assuming we survive the Sumo and don't blow the H-bridge!

The specs of our robot, named Steve for reasons we don't remember, are:

* Raspberry Pi B+
* Arduino Pro Mini (5V / 16MHz)
* UBEC switch mode power supply
* 6x 2500mAh AA Ni-MH cells
* L298N H-bridge board
* Seeedstudio Ultrasonic ranger
* Raspberry Pi Camera
* Dagu Rover 5 Chassis
* SparkFun Nokia 5110 LCD

Wish us luck!

## Two Runs In

So, not bad so far...

Our robot valiantly completed the line following challenge, but 2m47 over the 5m00 time limit. Great work by Matt Lane implementing an OpenCV based line following algorithm using the Raspberry Pi Camera. I'm calling that a moral victory, even if we were disqualified for being too slow.

Next up was the Proximity Challenge. The first run was a bit of a disaster - we stopped over 30cm from the board. Discussions ensued, and we demonstrated against a nearby door that our robot was capable of much better. We weren't allowed to modify the course, but we did move a few nearby shiny objects which we thought might be interfering. Our second run netted us 20.5mm (yes, millimetres). Result! The third run came in at 28mm. The runs are added together, so the failed run cost us quite a bit. We'll have to see if anyone else gets a failed run too.

Next up, Robot Golf at 11:35.

## Only Sumo Left

Three point turn was interesting. Our practice run was a farce as the robot jiggled on the spot and then stopped. It turns out, upping the main control rate meant it was checking the distance remaining from the last command before the Arduino had processed it. This meant it always saw zero and ran all the motor commands in quick succession. A quick code tweak later and we were back in business. I thought our proper run was pretty poor, but the judge was happy and declared we were third so far that day!

Straight line speed test was a good as we could manage as our robot is quite slow.

The obstacle course, again, was about as good as we could do. No penalties and all obstacles cleared in 45 seconds would have been good in the morning, but a recent run at 25 seconds had set the bar very high.

Now we wait for the sumo, with a fresh set of cells in hand. Fingers crossed!

## Sumo round 3 - Win!

Given two bys, due to competitors failing to present themselves, we entered straight in to round 3 against another Dagu Rover 5. Flashy Rover was built and run by one of our suppliers, Dawn Robotics. Evenly matched for some time, we managed to get under them and once in their back, it was game over.

Round 4 beckons.

## Prizes!

Second place in code quality with 42/44. Damn those last minute hacks!

## Sumo final

Beaten by a tricky wedge. Very chuffed to get in to the final though.

## End Result

"Steve" won second place in the over £75 category. Not fast and not massive, but good at most of the challenges. Hurrah!

{{ gallery() }}
