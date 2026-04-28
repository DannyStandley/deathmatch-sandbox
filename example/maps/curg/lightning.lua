lightningmat = manager:loadmaterial("materials/standard planet pack/lightning/material.mat")
flashtimer = 31
flashtimer2 = 0
closetimer = 0.3
closetimer2 = 0
lightning = null
function randomtime() do
flashtimer = luafunctions:random(3, 61)
end
end
lightsound = null
randomtime()
function update() do
foundmap = manager:findmap(mapname)
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
if lightning~=null then
mapfunctions:destroyobj(lightning)
end
if lightsound~=null then
sound:freesound(lightsound)
end
manager:removefunction(updatefunction)
return
end
if lightsound~=null and sound:checkplaying(lightsound)==0 then
sound:freesound(lightsound)
lightsound = null
end
if lightning~=null then
closetimer2 = closetimer2 +manager:getdeltatime()
if closetimer2>closetimer then
closetimer2 = 0
mapfunctions:destroyobj(lightning)
lightning = null
flashtimer2 = 0
randomtime()
end
end
if lightsound==null and lightning==null then
flashtimer2 = flashtimer2 +manager:getdeltatime()
if flashtimer2>flashtimer then
flashtimer2 = 0
closetimer2 = 0
cube = mapfunctions:createcube()
lightning = mapfunctions:spawnobject(20, 20, 10, 0, 0, 0, cube, 0, mapname, lightningmat)
lightnum = luafunctions:random(1, 4)
lightsound = sound:load(foundmap.x +20, foundmap.y +20, foundmap.z, "maps/curg/sounds/lightning"..luafunctions:str(lightnum)..".ogg", 0, 1, 1, 1, true)
if player.location~="maps/curg/surface.lua" then
sound:mufflesound(lightsound, 0)
end
sound:play(lightsound)
mapfunctions:destroyobj(cube)
if mapfunctions:checkstate(manager:findmap(player.location), "canseeweather")==1 then
mapfunctions:attachlight(lightning, "point")
mapfunctions:setlightrange(lightning, luafunctions:random(5, 50))
mapfunctions:setlightintensity(lightning, luafunctions:random(1, 100))
mapfunctions:setlightcolor(lightning, 1, 1, 1, 1)
end
end
end
end
end
