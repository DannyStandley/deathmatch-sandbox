# Stuff to get done when i'm not procrastinating or conditions warrant me being able to test the thing.
* Multiplayer, this has already been started with LightNetLib a few years back but the project whent through so many changes in that time I never finished it. Probably needs its own custom server.
Ideally should be as adaptable and moddable as the rest of the project.
* making sure mac OS support and android actually work properly. I don't have any immediet plans to get a recent enough mac as they are rather expensive, but android support will hopefully be workable once I switch phones.
* A few tiny tweeks and optimizations to get materials and textures unloaded from memory when they are no longer needed. This is a task that'd probably take at most 5 minutes, I just haven't decided on the implementation yet.
* Completely redo example as it is now grossly out of date. Thankfully, with the full conversion to a moo like database complete with internal lua scripts in place of moo code, this will be the last time this happens.
* Completely strip and remove ship class as the lua scripting should be able to handle stuff like this now, plus its wasteful on the resources to have ships as hard coded GameObjects of the MonoBehaviour class.
