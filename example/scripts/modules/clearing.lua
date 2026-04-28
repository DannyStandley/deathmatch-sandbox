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
for a=startx, endx do
mapfunctions:destroyobj(mapfunctions:getobj(a, starty, startz, "plane", orgmap))
mapfunctions:destroyobj(mapfunctions:getobj(a, starty, startz, "cube", orgmap))
for m=starty, endy do
mapfunctions:destroyobj(mapfunctions:getobj(a, m, startz, "plane", orgmap))
mapfunctions:destroyobj(mapfunctions:getobj(a, m, startz, "cube", orgmap))
for y=startz, endz do
mapfunctions:destroyobj(mapfunctions:getobj(a, m, y, "plane", orgmap))
mapfunctions:destroyobj(mapfunctions:getobj(a, m, y, "cube", orgmap))
end
end
end
