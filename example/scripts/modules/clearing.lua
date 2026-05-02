foundmap = manager:findmap(mapname)
linkx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "linkx"))
linky = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "linky"))
linkz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "linkz"))
startx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "startx"))
starty = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "starty"))
startz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "startz"))
endx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "endx"))
endy = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "endy"))
endz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "endz"))
orgmap = manager:findmap(mapfunctions:checkstatetext(foundmap, "orgmap"))
if orgmap==null then
maps = manager:getmaps()
for a=0, maps.Count -1 do
if maps[a].location==foundmap.location and maps[a].movex==linkx and maps[a].movey==linky and maps[a].movez==linkz then
orgmap = maps[a]
end
end
end
objects = manager:spawnlist()
for a=0, orgmap.mapobjects.Count -1 do
if orgmap.mapobjects[a].name=="cube" or orgmap.mapobjects[a].name=="plane" then
misc = mapfunctions:getmisc(orgmap.mapobjects[a])
if misc.orgx>=startx and misc.orgx<=endx and misc.orgy>=starty and misc.orgy<=endy and misc.orgz>=startz and misc.orgz<=endz then
objects:Add(orgmap.mapobjects[a])
end
end
end
for a=0, objects.Count -1 do
mapfunctions:destroyobj(objects[a])
end
objects:Clear()
