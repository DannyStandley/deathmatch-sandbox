foundmap = manager:findmap(mapname)
foundship = manager:findshipbymap(mapname)
nship = mapfunctions:checkstate(foundmap, "nship")
orgmap = manager:findmap(mapfunctions:checkstatetext(foundmap, "orgmap"))
lengthx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "lengthx"))
lengthy = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "lengthy"))
lengthz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "lengthz"))
if foundship==null or nship==1 and manager.foundship==foundship or nship==1 and manager:getshipscript(manager.foundship)==manager:findshipbymap(foundship.location) then
mapfunctions:spawnlocation(0, 0, 0, 0 +lengthx, 0 +lengthy, 0 +lengthz, orgmap.name, mapname)
end
