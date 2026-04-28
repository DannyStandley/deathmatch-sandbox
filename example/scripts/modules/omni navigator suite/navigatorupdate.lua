updatetimer = 0.23
updatetimer2 = 0
foundmap = manager:findmap(mapname)
foundship = manager:findshipbymap(mapname)
spawnx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawnx"))
spawny = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawny"))
spawnz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawnz"))
orgtheta = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "orgtheta"))
obj = mapfunctions:createobject()
speed = mapfunctions:spawnobject(spawnx, spawny, spawnz, 0, orgtheta, 0, obj, 1, mapname)
mapfunctions:attachtext(speed, "", 0.01)
flightcoords = mapfunctions:spawnobject(spawnx, spawny, spawnz -0.05, 0, orgtheta, 0, obj, 1, mapname)
mapfunctions:attachtext(flightcoords, "", 0.01)
galcoords = mapfunctions:spawnobject(spawnx, spawny, spawnz -0.1, 0, orgtheta, 0, obj, 1, mapname)
mapfunctions:attachtext(galcoords, "", 0.01)
dir = mapfunctions:spawnobject(spawnx, spawny, spawnz -0.15, 0, orgtheta, 0, obj, 1, mapname)
mapfunctions:attachtext(dir, "", 0.01)
mapfunctions:destroyobj(obj)
function update() do
foundmap = manager:findmap(mapname)
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
mapfunctions:destroyobj(speed)
mapfunctions:destroyobj(flightcoords)
mapfunctions:destroyobj(galcoords)
mapfunctions:destroyobj(dir)
manager:removefunction(updatefunction)
return
end
updatetimer2 = updatetimer2 +manager:getdeltatime()
if updatetimer2>updatetimer then
updatetimer2 = 0
mapfunctions:changetext(speed, "Speed: "..luafunctions:str(foundship.speed).." galactic miles per hour.", 0.01)
mapfunctions:changetext(flightcoords, "Flight coordinates: "..luafunctions:str(foundship.shipx)..", "..luafunctions:str(foundship.shipy)..", "..luafunctions:str(foundship.shipz), 0.01)
mapfunctions:changetext(galcoords, "Galactic coordinates: "..luafunctions:str(foundship.galx)..", "..luafunctions:str(foundship.galy)..", "..luafunctions:str(foundship.galz), 0.01)
mapfunctions:changetext(dir, "Direction: "..foundship.dir, 0.01)
end
end
end
