# Notes on the included example.
This was a dump of my game dated aypral 28th 2026, with all the assets like textures and sounds removed.
The example will not work if you attempt to start it without adding your own assets in first. Note that it is very rough because at the time of this writing, things are still being refined and i'm always rearanging.
# What does this example do?
It demonstrates a fully seamless open world game that has full on space travel and locations you can visit, complete with spaceships that are both explorable and pilotable. Including fully moving interior geometry.
The open world is (with the acception of some TINY AO for graphics modes that support it because I didn't finish graphics mode effects scripting in time) 100 percent exclusively dynamic lit.
No baking, no lightmaps. One of the planets even has a colony building complex that shows you how you can set up a press button to cut or restore power setup.
It also shows you possibilitys for how you can potentially avoid the traps of modern AAA gaming by having every single building on your maps enterable and explorable.
Its possible to pilot vehicles, such as the cargo hauler. Docking is occomplished by aligning a door that normally would go into the skybox (this counts as an airlock) with another door on another object that also goes nowhere. It can be a little bit tricky to master this especially as i'm still ironing out the details, but what you ideally want to do is maneuver your ship so that when one door is opened, the player will have to walk forward and open the door you just aligned with to get inside the space station or whatever you've docked with.
Landing on planets is simply a case of aligning with the ground. However, i'd not suggest attempting this as the cargo hauler doesn't have any supports like landing legs, so consequently you'll get some really nasty clipping issues.
Again, this is meerly a starting point that also provides several scripts you can use in your own projects, not a playable game.
