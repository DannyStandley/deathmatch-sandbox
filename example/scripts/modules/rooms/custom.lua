foundmap = manager:findmap(mapname)
nosouthwall = mapfunctions:checkstate(foundmap, "nosouthwall")
nonorthwall = mapfunctions:checkstate(foundmap, "nonorthwall")
nowestwall = mapfunctions:checkstate(foundmap, "nowestwall")
noeastwall = mapfunctions:checkstate(foundmap, "noeastwall")
outdoor = mapfunctions:checkstate(foundmap, "outdoor")
transparent = mapfunctions:checkstate(foundmap, "transparent")
maxx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "maxx"))
maxy = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "maxy"))
maxz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "maxz"))
floor = manager:loadmaterial(mapfunctions:checkstatetext(foundmap, "floor").."/"..manager:getsetting("graphicstype")..".mat")
if outdoor==0 then
ceeling = manager:loadmaterial(mapfunctions:checkstatetext(foundmap, "ceeling").."/"..manager:getsetting("graphicstype")..".mat")
end
if nonorthwall==0 or nosouthwall==0 or noeastwall==0 or nowestwall==0 then
wall = manager:loadmaterial(mapfunctions:checkstatetext(foundmap, "wall").."/"..manager:getsetting("graphicstype")..".mat")
end
plane = mapfunctions:createplane()
cube = mapfunctions:createcube()
mapfunctions:spawnobjects(0, 0, 0, maxx, maxy, 0, 0, 0, 0, plane, 0, mapname, floor)
if outdoor==0 then
if transparent==1 then
mapfunctions:changescale(plane, 0.05, 0.3, 0.05)
end
mapfunctions:spawnobjects(0, 0, maxz, maxx, maxy, maxz, 180, 0, 0, plane, 1, mapname, ceeling)
end
if nowestwall==0 then
mapfunctions:spawnobjects(-1, -1, 0, -1, maxy, maxz, 0, 270, 0, cube, 1, mapname, wall)
end
if noeastwall==0 then
mapfunctions:spawnobjects(maxx, 0, 0, maxx, maxy, maxz, 0, 90, 0, cube, 1, mapname, wall)
end
if nonorthwall==0 then
mapfunctions:spawnobjects(-1, maxy, 0, maxx, maxy, maxz, 0, 0, 0, cube, 1, mapname, wall)
end
if nosouthwall==0 then
mapfunctions:spawnobjects(-1, -1, 0, maxx, -1, maxz, 0, 180, 0, cube, 1, mapname, wall)
end
mapfunctions:destroyobj(plane)
mapfunctions:destroyobj(cube)
