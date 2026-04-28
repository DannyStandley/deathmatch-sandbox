foundmap = manager:findmap(mapname)
orgtheta = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "orgtheta"))
foundship = manager:findshipbymap(mapname)
function setdial() do
mapfunctions:disablelight(ndial)
mapfunctions:disablelight(sdial)
mapfunctions:disablelight(edial)
mapfunctions:disablelight(wdial)
if foundship.dir=="north" then
mapfunctions:enablelight(ndial)
end
if foundship.dir=="south" then
mapfunctions:enablelight(sdial)
end
if foundship.dir=="east" then
mapfunctions:enablelight(edial)
end
if foundship.dir=="west" then
mapfunctions:enablelight(wdial)
end
if foundship.dir=="northeast" then
mapfunctions:enablelight(ndial)
mapfunctions:enablelight(edial)
end
if foundship.dir=="northwest" then
mapfunctions:enablelight(ndial)
mapfunctions:enablelight(wdial)
end
if foundship.dir=="southeast" then
mapfunctions:enablelight(sdial)
mapfunctions:enablelight(edial)
end
if foundship.dir=="southwest" then
mapfunctions:enablelight(sdial)
mapfunctions:enablelight(wdial)
end
end
end
olddir = ""
function setuplight(obj) do
mapfunctions:attachlight(obj, "point")
mapfunctions:setlightcolor(obj, 1, 1, 1, 1)
mapfunctions:setlightrange(obj, 0.23)
mapfunctions:setlightintensity(obj, 20)
mapfunctions:disablelight(obj)
end
end
interact = manager:addinputaction()
interact:AddBinding("<Keyboard>/"..manager:getsetting("key_interact"))
interact:AddBinding("<Gamepad>/buttonWest")
interact:Enable()
dialmat = manager:loadmaterial("materials/lcd dial/"..manager:getsetting("graphicstype")..".mat")
cube = mapfunctions:createcube()
mapfunctions:changescale(cube, 0.1, 0.1, 0.1)
ndial = mapfunctions:spawnobject(0, 0, 0.3, 0, orgtheta, 0, cube, 1, mapname, dialmat)
setuplight(ndial)
sdial = mapfunctions:spawnobject(0, 0, 0.1, 0, orgtheta, 0, cube, 1, mapname, dialmat)
setuplight(sdial)
edial = mapfunctions:spawnobject(0.1, 0, 0.2, 0, orgtheta, 0, cube, 1, mapname, dialmat)
setuplight(edial)
wdial = mapfunctions:spawnobject(-0.1, 0, 0.2, 0, orgtheta, 0, cube, 1, mapname, dialmat)
setuplight(wdial)
mapfunctions:destroyobj(cube)
function update() do
foundmap = manager:findmap(mapname)
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
manager:removefunction(updatefunction)
return
end
if foundship.dir~=olddir then
olddir = foundship.dir
setdial()
end
if interact.triggered and player:checkstate("cantmove")==0 and luafunctions:getdistance(player.x, player.y, player.z, foundmap.x, foundmap.y, foundmap.z)<=0.5 +0.001 *1000 then
player:addstate("cantmove")
manager:addfunction("scripts/modules/omni flight system/controls.lua", "update", mapname)
end
end
end
