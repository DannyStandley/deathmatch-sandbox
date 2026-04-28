removemaps = manager:spawnstringlist()
maps = manager:getmaps()
for a = 0, maps.Count -1 do
if maps[a].name~="maps/galaxy/galaxy.lua" and mapfunctions:checkstate(maps[a], "dontsave")==1 then
removemaps:Add(maps[a].name)
end
manager:unloadmap(maps[a].name)
maps[a].loaded = 0
end
for a=0, removemaps.Count -1 do
foundmap = manager:findmap(removemaps[a])
manager:removeshipmap(manager:findshipbymap(removemaps[a]), foundmap)
manager:removemap(foundmap)
end
