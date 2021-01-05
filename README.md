**05-01-2021**

Completely re-structured the project. All files have a numbered prefix now, you should try and learn in this order.
I also sorted my examples now in to three areas: simple, hires and mcm. A new area fcm for Full Color Mode grafics 
is in the work and will come soon!

simple:
There's a new example which show how to set a custom color palette and even more important how to calculate the RGB-Values correctly.
Another example in this areas shows in detail and in easy steps how to map memory and how to calculate the values for the registers. Check it out!

hires+mcm:
Areas for Hires and Multicolor-Bitmap graphic modes. Including some sample grafics pixeled with my other project "Just Pixel". The examples run only on the MEGA65 because I already included custom color palettes.



**20-12-2020**

Examples for Hires and Multicolor Bitmaps in 65 Mode.
You can paint pictures with Just Pixel and bring it to screen!

**12-12-2020**

Started this repository. The idea is to check in the results and outcomes of my MEGA65 explorations here.
The first thing I did, was to bring Shallans KickAss-Environment into a ACME-based environment.

At the moment I am not interested in the 64 mode on the MEGA65, because this is nothing really new.
I want to work in 65 mode - Yeah! With all the pain! - because I want to learn something new and train my brain!


The obligatory "helloworld":

```build.sh helloworld```


This will build helloworld.asm and puts the binary into a build-folder. The build-script also can start the programm 
either by using the XEMU-Emulator or the DevKit with the m65 tool.

After the "helloworld" I started to play with Graphic modes. I know MCM oder FCM are much more attractive and interesting
but I wanted to start with some basic things! One step after the other! And in terms of graphics for me this is bitmaps 
the good old C64 style. Will it work in 65 mode ? And How ? 

```build.sh hires.asm```

Will paint a very basic Hires Bitmap, and as I wanted to stay with C64 Hires Bitmaps I switched to 320x200 by using $D031.


