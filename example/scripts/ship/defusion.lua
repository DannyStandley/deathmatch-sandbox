foundship = manager:findshipbymap(mapname)
epoint = null
ships = manager:getships()
for a=0, ships.Count -1 do
ship = manager:getshipscript(ships[a])
if ship:checkstatetext("type")=="engage point" and luafunctions:getdistance(foundship.galx, foundship.galy, foundship.galz, ship.galx, ship.galy, ship.galz)<=1 then
epoint = ship
end
end
if epoint~=null then
foundship.galx = luafunctions:toint(epoint.galx)
foundship.galy = luafunctions:toint(epoint.galy)
foundship.galz = luafunctions:toint(epoint.galz)
mapfunctions:removestate(foundship.maps[0], "skybox materials/fusion space/material.mat")
foundship.location = epoint.maps[0].name
for a=0, foundship.maps.Count -1 do
foundship.maps[a].location = epoint.maps[0].location
end
end
