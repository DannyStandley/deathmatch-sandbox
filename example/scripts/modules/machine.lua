foundmap = manager:findmap(mapname)
mat = manager:loadmaterial(mapfunctions:checkstatetext(foundmap, "material").."/"..manager:getsetting("graphicstype")..".mat")
startscript = mapfunctions:checkstatetext(foundmap, "startscript")
lengthx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "lengthx"))
lengthy = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "lengthy"))
lengthz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "lengthz"))
orgtheta = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "orgtheta"))
orient = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "orient"))
cube = mapfunctions:createcube()
mapfunctions:spawnobjects(0, 0, 0, 0 +lengthx, 0 +lengthy, 0 +lengthz, orient, orgtheta, 0, cube, 1, mapname, mat)
mapfunctions:destroyobj(cube)
if startscript~="" then
manager:runscript(startscript, mapname)
end
