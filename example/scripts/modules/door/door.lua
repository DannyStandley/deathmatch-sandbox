foundmap = manager:findmap(mapname)
matstr = mapfunctions:checkstatetext(foundmap, "mat")
if matstr=="" then
mat = manager:loadmaterial("scripts/modules/door/"..manager:getsetting("graphicstype")..".mat")
else
mat = manager:loadmaterial(matstr.."/"..manager:getsetting("graphicstype")..".mat")
end
cube = mapfunctions:createcube()
orgmap = manager:findmap(mapfunctions:checkstatetext(foundmap, "orgmap"))
orgtheta = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "orgtheta"))
destroyx = foundmap.movex
destroyy = foundmap.movey
destroyz = foundmap.movez
if mapfunctions:checkstatetext(foundmap, "destroyx")~="" then
destroyx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "destroyx"))
destroyy = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "destroyy"))
destroyz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "destroyz"))
end
mapfunctions:destroyobj(mapfunctions:getobj(destroyx, destroyy, destroyz, "cube", orgmap))
obj = mapfunctions:spawnobject(0, 0, 0, 45, orgtheta, 0, cube, 1, mapname, mat)
obj.name = "door"
mapfunctions:destroyobj(cube)
if mapfunctions:checkstate(foundmap, "side")==1 then
manager:addfunction("scripts/modules/door/doorupdateside.lua", "update", mapname)
else
manager:addfunction("scripts/modules/door/doorupdate.lua", "update", mapname)
end
