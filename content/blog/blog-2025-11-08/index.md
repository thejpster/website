+++
title = "Installing and using HP-UX 9"
date = "2025-11-08"
+++

## Background

A few weeks back I got a note on Bluesky my mate Rob, linking me to a website offering a free computer. The owner was in Cambridge, not far from me, and the computer was an HP 9000/300 Series - a Model 340, specifically.

The HP 9000 line of workstations and servers ran from the early 1980s through to the late 2000s (see this [great history page at openpa.net](https://www.openpa.net/systems/hp-9000_pa-risc_story.html) for more details). It encompassed many processor architectures, including Itanium, HP's own Precision Architecture (aka PA-RISC), and their earlier FOCUS architecture. Alongside the early FOCUS machines, they also had a line of Motorola 68K based UNIX workstations - the 300 series. This is a machine from that series, and I thought a 68030 based UNIX workstation just sounded fascinating. Something of the same kind of processor and vintage as the Macintosh IIx, but part of the lineage that led to my beloved [Visualize B132L+ and C3000 workstations](@/blog/blog-2025-03-22/index.md).

E-mails were exchanged with the owner, Ben, and I was invited to pop over and collect the machine. And then, whilst I was there, it turns out Ben had a few more machines he'd be happy to move on to a new owner, to free up some space. And. Well. I went home with:

* An HP 9000 Model 340 (68030)
* An HP 9000 Model 715 (PA-7000)
* A DEC microVAX 3100 (KA-41)
* An IBM RS/6000 7012-320 (POWER 2)
* A Sun SPARCstation 20 (HyperSPARC)
* A Sun SPARCstation 4 (MicroSPARC)
* A Sun SPARCstation 10 (SuperSPARC)
* Some HP mice, some DDS tapes, and some SCSI terminators

{{ image(img="/blog/blog-2025-11-08/Model340.JPEG") }}

{{ image(img="/blog/blog-2025-11-08/Boot.JPEG") }}

{{ image(img="/blog/blog-2025-11-08/SPARCstation10.JPEG") }}

This haul was frankly ridiculous, and huge thanks to Ben for his generosity. It was also more machines that I literally had space for at home (thanks to a [very large pile of SPARCstations](@/blog/blog-2025-08-20/index.md) I haven't yet moved on) and so I immediately called my friend Matt and arranged to drop of the SPARCstation 10 and the HP 9000 Model 715. I already have an HP 9000 Model 712 and they're similar enough I'm happy to let Matt hold on to the 715 for now. He also had his name down for the SPARCstation 10 I already had, so it made sense to let him have both in case one he needs spares.

Over at Matt's house we fired them up and were delighted to see the both booted up OK, which was very promising.

I've since donated the SPARCstation 4 (working) and the microVAX3100 (sadly dead) to new homes, free of charge. I've also tested the RS/6000, which was also dead, and the SPARCstation 20, which not only worked but turned out to contain *two* ROSS HyperSPARC CPU cards running at 150 MHz. As SPARCstations 20s go, it doesn't really get much better.

But, we're here to talk about HP-UX. And before I can do that, I need to explain that the Model 340 doesn't have a disk drive.

## The HP 9000 Model 340

The system specs for this machine are:

* Motorola 68030 CPU at 16.7 MHz
* Motorola 68882 FPU
* 16 MiB RAM
* High Resolution Colour Graphics Board (1280x1024 in 256 colours at 75 Hz), with output via 3x BNC
* HP-IB interface for disk drives and peripherals
* HIL interface for keyboard and mouse
* 10base2 Ethernet interface

What it does not have, is a floppy controller or a SCSI controller, or any kind of disk controller. You're supposed to either network boot it, or use an HP-IB disk drive.

I also did not have any 10base2 networking gear, a BNC to VGA adapter, any HP-IB cables or devices or a HIL keyboard (although I did have a bag of HIL mice). But, you know, eBay exists, and I was able to get the first three things in short order. The keyboards, however, are outrageously expensive, and being HIL interface, you can't just use a PC keyboard as a substitute.

Here Matt comes to the rescue because it turned out he had an HP 9000 Model 705 kicking around, and that also uses HIL, and he had the keyboard to go with it and seeing as he now had a Model 715, he was happy to let me borrow the 705 and its keyboard in exchange.

Amazingly, the Model 340 appears to be in great working order. When you turn it on, it does a self-test, and then fails to find any devices to boot from. I now do have an HP-IB card (well, a GPIB card) for my Windows XP PC, and a copy of [*HPDrive* from hp9845.net](https://www.hp9845.net/9845/projects/hpdrive/). This is an emulator for HP HP-IB drive units - floppy drives, hard disk drives and CD-ROM drives. I have booted the machine with it, but I found it to be quite slow.

What's more fun though, is putting it into a cluster with the Model 705 and network booting it.

Yes, that a 68030 machine network booting from a PA-RISC machine ... and *sharing the same root filesystem*. But aren't PA-RISC binaries and 68K binaries quite different? Oh yes, they really are. So, how does that work?

## HP-UX 9 for Series 700 (PA-RISC)

I believe there are several versions of HP-UX that support setting up a *cluster*, but HP-UX 9 is the last that supported mixed 68K and PA-RISC clusters (or, as HP would call it, mixed Series 300 and Series 700 suppport). HP-UX 10 dropped 68K support and was PA-RISC only.

So, let's install HP-UX 9 on the Model 705 I got from Matt. I found [this guide quite helpful](https://web-docs.gsi.de/~kraemer/COLLECTION/HPUX/scratch.html) but I'll outline the basic steps here.

{{ image(img="/blog/blog-2025-11-08/Series700.JPEG") }}

{{ image(img="/blog/blog-2025-11-08/HILKeyboard.JPEG") }}

(Side note: look at that keyboard for more than a few seconds, and you'll realise *it's really weird*)

Step 1 is to boot the Install CD, which I do using a BlueSCSI. This formats the hard disk - but only if it recognises the make and model from its `disktab` file. This is an annoyance that seems common to early UNIX systems - SunOS 4 has a similar problem - but I was able to swap some drives around and put a 2GB Seagate ST11200N into the machine, which it seems happy with. You'd certainly have no chance with a more modern 9.1GB drive. Once the format is done, it lays down a very root filesystem, and reboots into it.

Step 2 is the actual installation. I put the image onto the BlueSCSI (I'm using *HP-UX 9.07 Core OS B2826-13716*), and the installation picks it up and asks what packages I want to install. I pick *Select All Filesets on the Source Media*, because I've got plenty of disk space - I think a full install is only about 200 MiB. It takes about 20 minutes to copy the files over, and then we can set up the root password, hostname, IP address, DNS server, and so on.

{{ image(img="/blog/blog-2025-11-08/install.JPEG") }}

## Cluster Mode, Activated

My first attempt at setting up HP-UX 9 on this machine was made difficult because the network card wasn't working. This was either because I had the switch on the rear of the machine in the *Factory Setup* position instead of the *Normal* position, or because I had the internal jumpers set to use the AUI port instead of the BNC, and it knew I didn't have an MAU attached to the AUI port. Either way, I resolved both issues at the same time and after that, the network started up on boot. If you cannot bring up a network interface on a Model 705, check both I guess.

We administer the system using *SAM*. It's a TUI tool, and easy enough to go in and set this machine up as a Cluster host.

```text
┌██████████System Administration Manager (hp705) (1)█████████┐  
│                                                            │  
│                                                            │  
│ ┌────────────────────────────────────┐                     │  
│ │ Printers and Plotters->            ^  [[    Open      ]] │  
│ │ Disks and File Systems->                                 │  
│ │ Peripheral Devices->                                     │  
│ │ Backup and Recovery->                 [ Previous Level ] │  
│ │ Users and Groups->                                       │  
│ │ Routine Tasks->                                          │  
│ │ Process Management->                                     │  
│ │ Kernel Configuration->                                   │  
│ │ Cluster Configuration                                    │  
│ │ Networking/Communications->                              │  
│ │ Remote Administration                                    │  
│ │ Auditing and Security->                                  │  
│ │                                                          │  
│ │                                    v                     │  
│ └────────────────────────────────────┘                     │  
│          Press CTRL-K any time for KEYBOARD HELP           │  
│                                                            │  
│────────────────────────────────────────────────────────────│  
│ [   Exit SAM    ]   [  Options...   ]   [     Help      ]  │  
└────────────────────────────────────────────────────────────┘  
```

```text




               ┌████████████Create Cluster (hp705)█████████████┐              
               │                                               │              
               │ Create an HP-UX Cluster:                      │              
    ┌█████████████████████████Confirmation (hp705)█████████████████████████┐  
    │                                                                      │  
    │ This system ("hp705") does not currently appear to be a cluster      │  
    │ server (because "standalone" appears in the process context from the │  
    │ kernel). Cluster configuration can only be done on a cluster server. │  
    │                                                                      │  
    │ Would you like to create a cluster server?                           │  
    │──────────────────────────────────────────────────────────────────────│  
    │ [Yes  ]]                                                    [  No  ] │  
    └──────────────────────────────────────────────────────────────────────┘  
               │───────────────────────────────────────────────│              
               │ [   OK   ]       [ Cancel ]       [  Help  ]  │  
               └───────────────────────────────────────────────┘  






```

```text

   ┌█████████████████████████Confirmation (hp705)██████████████████████████┐  
   │                                                                       │  
   │ This system ("hp705") should be in single user state before being     │  
   │ converted to a cluster server. Changes to the file system, and a      │  
   │ following reboot, can negatively affect running processes. This       │  
   │ system is not currently in single user state.                         │  
   │                                                                       │  
   │ To view system status, start a new window (or press F7 on a terminal  │  
   │ to escape to a shell), and type "who -r" (see the who(1) manual       │  
   │ entry).                                                               │  
   │                                                                       │  
   │ To bring the system to single user state, visit the Routine Tasks     │  
   │ area of SAM, or exit SAM from the main menu and then type             │  
   │ "/etc/shutdown" (see the shutdown(1M) manual entry). Once the system  │  
   │ is in single user state, you can restart SAM to convert the system to │  
   │ a cluster server.                                                     │  
   │                                                                       │  
   │ Do you want to continue to convert your system to a cluster server    │  
   │ without changing the system to single user state?                     │  
   │───────────────────────────────────────────────────────────────────────│  
   │ [ Yes  ]                                                     [[No  ]] │  
   └───────────────────────────────────────────────────────────────────────┘  

```

Hmmm, OK, fine, I'll drop to single-user mode and do it on the console instead of over telnet. Sorry, no more copy-pastes of the cluster setup process, but you aren't missing much.

Once we're in single user mode, it lets us set up a cluster. And once we've accepted that it's an irreversible process (weird), actually setting up the cluster takes an *age* to complete. It's not immediately clear why it needs to thrash the disk for 20 minutes, but once that's done, we reboot and then we can go back in to *SAM* and add a new machine to the cluster. But, it's only letting us as *S700* machines (i.e. PA-RISC machines), not *S300* machines (that have the 68K architecture).

Another quick side-note here to shout-out to HP-UX for including a sensible `/etc/nsswitch.conf` out of the box - one that looks at the `/etc/hosts` file and then the DNS resolver configured in `/etc/resolv.conf`. Most of you think this a weird thing to celebrate, but some of you have had the pain of installing old versions of Sun Solaris before and you understand.

## HP-UX 9 for Series 300 (68K)

HP-UX 9 for the Series 300 is a different set of install CDs, containg 68K binaries. It makes sense that we cannot add Series 300 machines to our cluster, because we have no 68K binaries for them to boot over the network.

So how you do get Series 300 binaries on a Series 700 machine? You insert the Series 300 *CoreOS* disk (not the bootable *Install* disk), and you install HP-UX for Series 300. Over the top of the existing install.

This is profoundly weird and when I first tried this, I was sure I was doing something wrong about about to trash my whole machine. You can imagine my surprise when, having done this second install of an alien architecture, I was able to add an *S300* machine to my cluster, specifying the Ethernet MAC address of my Model 340, along with an IP address.

You can further imagine my surprise when I connect the Model 340 to the 10base2 network and it boots right up, into HP-UX 9 for 68K, over the network. The root password is the *same* root password I have set up on the Model 705. In fact, it's the same root filesystem. I can make a file on the 705 and see it on the 340. But, binaries (like `/bin/ls`) are PA-RISC code on the 705 and 68K code on the 340. I know this, because the binaries work on each machine, but I can see this using the `file` command.

On the 705:

```console
$ file /bin/ls

```

On the 340:

```console
$ file /bin/ls

```

What on earth is going on? How is one file both a 68K binary and a PA-RISC binary at the same time? It's not the NEXTSTEP trick (inherited by Mac OS X) of so-called *fat binaries*, because look - the file sizes don't match.

I have bad news. That 20 minutes of thrashing when we set up cluster mode? We created ourselves a *Context Dependent Filesystem*. The contents of our filesystem are literally context-dependent.

## Context Dependent Filesystems

Now we get to the point of the blog post. This filesystem is *wild* and I can totally see why HP ditched it in HP-UX 10.

When a file is *context-dependent*, it in fact becomes a directory. Within this directory are files named after the various supported contexts. When you access the filename, you get the contents according to the context you are in. If you access the filename including a `+` character at the end, you can see the directory and the context-dependent files it contains.

```console
$ ls -l /bin/ls+
```

Oh look, our two copies of `ls`!

Directories can also be *context-dependent* and when that happens, each entry it contains is a directory for a specific context. 

Files you create in the usual course of using the system will just be regular files. If you want to create a *CDF*, you use the `makecdf` command. This turns out to be important because if you try and run the VUE desktop on the Model 340, the X11 server will fail to start. This because in HP-UX 9.07 for Series 700, the library is called `FOOOBAR.sl`, and so when we created a cluster, that became a CDF. When we installed HP-UX 9.10 for Series 300, the library is called `FOOBAR2.sl`, which is not an existing CDF, and therefore the installation of the X11 package fails and that file ends up missing. The workaround is to create the CDF manually, and then move over the file from the package install directory, as noted in the error log.
