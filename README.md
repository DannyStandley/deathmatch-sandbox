# Introduction
## What is this exactly?
As a diehard fan of science fiction and who was raised on stuff like aliens and as a diehard fan of dead space, one of the things i've always wished I could do when playing any game set in a sci fi universe where I could explore a starship (think the sulaco from aliens colonial marines or the ishimura from dead space) is to be able to fly it. As in actually interact with the consoles, the systems and make the ship move through space. And thus, I set out to make a game that, for lack of a better description was the ultimate space sandbox, a space GTA if you will.
In the process of doing this, I set myself 3 major objectives.
* The content and scripting pipeline had to be entirely runtime driven to allow for rappid prototyping and account for the fact I change my mind about 50 times a day.
* The game not only had to be extremely well optimized (i'm too lazy to upgrade my gtx1060 plus i'm a hardcore retro enthuziast) but it also had to be able to look good.
* Entirely moddable into something else, both for code reusage, engine (and platform) portibility.
Six years of development, newmerous frustrations and I ended up achieving all 3 objectives. While i'm still indecisive about the game that i've been building with this, I figured this stuff might be useful to others given the challenges.
## That's cool, but what exactly can I do with this?
Pretty much any kind of world you want, seamless or not, open world or not. This was designed for the creation of entire universes. If you know what a MUD (multi-user dungeon) is, or you are acquainted with its modern offshoot of the MMO, this aims to give you that same scale in video game form, without or with the internet connection and multiplayer, complete with full 3d graphics.
Or to put it another way, this is the game where you could have a ship like the sulaco, a planet like lv426, another ship like the ishimura all together in the same world, fully explorable, fully interactable.
It can be completely cutscene free or have as many cutscenes as you want, if you can dream it and you have the scripting chops you can totally do it.
# Querky things answered, hopefully.
Since my techniques of game development tend to not be at all the modern stuff you see in todays games, this section serves to try and run you through the answers to some questions you might have.
## Why are their no animations or physics?
Ahh, interesting that you should ask. A key thing for this project is that logic (collisions, physics and the like) should not be a part of the visuals. Therefore, animation and physics is simply lua scripting and the manipulation of objects and variables (usually with delta timing in my case). I found that not only did this make it considerably easier for me to develop the world, it made it far more immersive by giving the hole thing a tactile feel.
## Don't you have any models for the vehicles?
While there is an included .obj parcer, this hole projects biggest selling point is that you can interact with the pretty scenery to move it and make it do stuff. Consequently as a result, vehicle interior maps are the exteriors. They will move with vehicles and depending on how things are configured the geometry must share space with other vehicles.
## What's with the weerd save system?
In this project, the state of the world counts as your save file, not your players progress in it.
## Why are coordinates flip flopt?
Simple. I find y as the forward easier to work with, but unity uses z as the forward. So I faked it.
## Do I have to build space stuff?
No, although it was really designed for space settings, and so consequently all vehicles use the ship class.
## Why use unity instead of godot or <insert favourite rendering engine here>
Okay to be honest, out of convenience and because I didn't think this project would get up to the point where it is.
Also because godot was still in the early stages when I started.
It in theory is portible to other engines, you just need to rewrite manager.cs to point to the correct functions or write a replacement for it in your language of choice that includes the necessary lua stuff. As long as lua is available and has the correct functions linked to it your game won't care what's doing all the heavy lifting.
# Getting this to work for your own projects.
In a new unity scene, remove the default directional light (you won't need it here because of the lighting) and create a blank game object called "Game Manager" then, attach the manager script to it.
Have a look at the manager class in manager.cs to see how start and awake work.
Tinker with the settings in your build directory (how you set that up is up to you) under settings.lst to set the necessary stuff up, including your startup script and all that good stuff.
After that you should be good to go.
If you use my build script for cross compiling to all supported platforms, don't forget to edit it to change the name to your game.
# Cross platform support
The project in theory supports all the major platforms of windows, mac OS and linux, as well as android. Android and mac support are untested (i'm working on acquiring an android device and I don't have a new enough mac) so your on your own as far as that's concerned. If it does work let me know though.
Its been tested under windows and under linux. Linux is the platform that's received the most testing as I switched to it a couple years after starting this thing, but the windows build should work perfectly fine.
# The example.
The example is a snapshot of my game (without the assets which you have to provide yourself otherwise it won't work). It shows you how to make a properly optimized fully seamless open world experience complete with exclusive dynamic lighting, complete with starships you can fly and the like.
A lot of it is incomplete, ships don't have supports to sit properly on planets etc but it shows you what you can do.
At the very least it'll probably give you some ideas for techniques you can use in your own games weather you use this or not.
It includes a full character system complete with a character switching mecanic, two planets, one space station, and a couple of ships (one incomplete) for you to play with.
Please note that some areas are a little out of date, this thing has a tendency to evolve quite rappidly on the scripting side.
# A note on AI.
Most of the manager.cs file was written long before I whent from disavowing to fully embracing AI.
99 percent of manager.cs (the main code) is not AI driven (I prefer to only reference AI for coding if i'm genuinely stuck on a problem that I can't get help with otherwise). Its limited to tiny functions like SetDynamicTiling (easily notable because it differs from my usual coding style), and I used it to help me get the obj parcer operational after writing it. The scripts are completely independent of AI as I don't trust it to handle such.
The only place where AI was used heavily is the custom shaders providing a few aesthetic looks, since i'm inexperienced at shader programming and rairly have a need to do it.
Also the texture tools in the tools folder were vibe coded just because I needed something really quick for mipmapping.
# Support stuff.
Disclaimer. You are soly responsible for what you do and create with this code and script thing.
This is a passion project i've worked on for 6 years and made for my own enjoyment, so don't expect top class support on getting it to work for your specific needs.
That said, I hope you have as much fun with it as I did creating it.
## Help, my game isn't optimized/runs at low FPS.
This is entirely dependent on both your settings and how you have your world configured.
If you are using the mapmanager script from the example, try adjusting the load boundrys for your maps and an adjustment on the lighting will help. You ideally want a balance where enough is loaded into memory to make the world appear correctly, but not have too much loaded that'll tank the framerate.
## Where's the documentation for the lua scripting?
Currently, there is no available technical documentation to explain how things work or what they do.
Studdying the manager.cs and the various classes is your best alternative.
I'll probably sit down some day and see if I can't write up some documentation but we'll see.
That said, the included example provides loads of references you can use, particularly the map manager and showing you how settings work.
## Will you help me with my game?
Depends on your deffinition of help. If you mean build it for you no, but if you want some tips or just want me to check out whatever you've done hey let me know and maybe i'll take a look, depending on if i'm able to make the time.
## How can I contact you?
As someone who takes his personal space very seriously, I have no direct line for contact. You can try my youtube channel but do be aware my response frequency is on a weather I feel like being social basis.
