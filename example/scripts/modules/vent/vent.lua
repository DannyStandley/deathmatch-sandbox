cube = mapfunctions:createcube()
ventmat = manager:loadmaterial("scripts/modules/vent/"..manager:getsetting("graphicstype")..".mat")
foundmap = manager:findmap(mapname)
orgmap = manager:findmap(mapfunctions:checkstatetext(foundmap, "orgmap"))
orgtheta = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "orgtheta"))
mapfunctions:destroyobj(mapfunctions:getobj(foundmap.movex, foundmap.movey, foundmap.movez, "cube", orgmap))
obj = mapfunctions:spawnobject(0, 0, 0, 0, orgtheta, 0, cube, 1, mapname, ventmat)
obj.name = "vent"
mapfunctions:destroyobj(cube)
