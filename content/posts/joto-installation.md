+++
date = "2020-07-22"
title = "Jewels of the Oracle : Installation"
description = ""
tags = [
  "blog",
  "algorithm",
  "games",
]
+++

![Jewels of the Oracle 1995](/images/jotw-game.jpeg)

One of the games my parents used to play in the 1990s was Jewels of the Oracle.
It is a puzzle game set in ancient Mesopotamia consisting of 24 puzzles. They range from logical, geometric
and lingustic puzzles.

My mother was really interested in playing it again. The game came out in 1995, so playing it
on modern hardware is difficult. We searched for various methods that were dead ends. It would not run properly
on the software DOSBox used for running old games. Trying to play it on a Windows 7 machine via compatibility
mode also failed. The last idea I had was to try and run it within a Virtual Machine. I eventually got it
to work, and have left the installation details below.

# Prerequisites

## Virtualbox

First, install Oracle VM Virtualbox for your computer. I have used it on OSX and Windows 10 with success.
You can find the downloads page [here](https://www.virtualbox.org/wiki/Downloads).

## Windows XP ISO

To play Jewels of the Oracle, you need an old version of Windows. I suggest Windows XP. After scouring the internet,
I found the following URL with Windows XP.

https://the-eye.eu/public/MSDN/Windows%20XP/en_windows_xp_professional_with_service_pack_3_x86_cd_vl_x14-73974.iso

## Jewels of the Oracle ISO

Virtualbox allows you to mount ISO files on virtual optical drives inside your VM. This emulates installing from a cd/dvd, like you
would do with an old computer.

I found the following URL to download Jewels of the Oracle.

https://ia803100.us.archive.org/29/items/Jewels_of_thje_Oracle_Discis_1995/Jewels%20of%20thje%20Oracle%20%28Discis%29%281995%29.ISO

# Installation

First, you will want to create a VM with the Windows XP ISO. You will have to have a product key to install. There are many good tutorials on this elsewhere.

Once your Windows XP VM is up, mount  the Jewels of the Oracle ISO as a virtual disk drive. To do this, navigate to `Settings->Storage` and mount Jewels of the Oracle.

![Mount disk drive](/images/jotw-vbox.png)

Once, mounted, run the installer from the `D:/` drive. 

![Run installer from D Drive](/images/jotw-installer.png)

Click yes to everything in the installation. However, once asked to set up the program manager, click No and continue to proceed.
You will instal Quicktime player after but that is it.

![Don't change program manager](/images/jotw-no-program-group.png)

Now that the installation is complete, click Jewels of the Oracle from the startup menu and you are ready to play!

![Jewels Gamescreen](/images/jotw-gamescreen.png)

# Conclusion

Enjoy the game! If you have any questions, feel free to DM me on twitter.



