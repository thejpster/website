+++
title="TI Stellaris Launchpad"
date="2012-12-22"
+++

My Stellaris Launchpad finally arrived the other day. I ordered it back when they were under £4 each several months back. They're now about £10, which still isn't bad.

The example software bundle is over 340MB and requires signing up for an account, along with requesting 'permission' to see the code. The drivers seem to be BSD licensed, but the example programs cannot be redistributed. I also tried to get the popular '[Code Sourcery](https://sourcery.mentor.com/GNUToolchain/)' GCC compiler they recommend but all I got was login screens and talk of professional versions.

Screw that.

On Github you will find [my solution](https://github.com/thejpster/launchpad). You can use either the ARM Linux toolchain in the Ubuntu repostories (yes, even for bare-metal programming) or fetch the one built by ARM. No click throughs. No legalese. Just free software. The bits I wrote are even under the MIT license so you can crib away, guilt-free.

So far, the example flashes an LED and changes the colour if you press either of the buttons. I think I'll build up a simple library for GPIO and UART because, you know, that stuff's fun.

Thanks to http://eehusky.wordpress.com/, http://scompoprojects.wordpress.com/ and http://recursive-labs.com/ who gave me some great pointers (although I've used the mildly-insane SCons build system rather than the deeply-insane and incomprehensible Make).
