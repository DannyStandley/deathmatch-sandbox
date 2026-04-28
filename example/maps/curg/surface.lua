foundship = manager:getshipscript(manager:findship("curg"))
foundmap = manager:findmap(mapname)
manager:changeskybox(manager:loadmaterial("materials/standard planet pack/sky2/material.mat"))
function spawnmap(x, y, z) do
smapname = "maps/curg/smap"..luafunctions:str(luafunctions:random(0, 1000000000))
smap = manager:spawnmap(smapname..".lua", x, y, z, -10, -10, -100, 60, 60, 100, "curg")
smap.filename = smapname..".map"
mapfunctions:addstate(smap, "object curg")
mapfunctions:addstate(smap, "dontsave")
mapfunctions:addstate(smap, "runscript maps/curg/gensurface.lua")
mapfunctions:addstate(smap, "nofile")
mapfunctions:addstate(smap, "removeonunload")
manager:addmaptoship(smap, foundship)
end
end
spawnmap(-51, -51, 0)
spawnmap(0, 0, 0)
spawnmap(51, 0, 0)
spawnmap(0, -51, 0)
spawnmap(-51, 0, 0)
spawnmap(0, 51, 0)
spawnmap(51, 51, 0)
spawnmap(-51, 51, 0)
