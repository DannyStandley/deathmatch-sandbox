addmaps = manager:spawnstringlist()
removemaps = manager:spawnstringlist()
checktimer = 1
checktimer2 = 0
function update() do
checktimer2 = checktimer2 +manager:getdeltatime()
if checktimer2>checktimer then
checktimer2 = 0
if addmaps.Count>0 then
for a=0, addmaps.Count -1 do
if manager:findmap(addmaps[a])==null then
newmap = manager:loadmap(addmaps[a])
nship = null
ship = mapfunctions:checkstatetext(newmap, "object")
if ship~="" then
nship = manager:getshipscript(manager:findship(ship))
end
if nship~=null then
manager:addmaptoship(newmap, nship)
manager:movemap(newmap, luafunctions:toint(nship.shipx +newmap.movex), luafunctions:toint(nship.shipy +newmap.movey), luafunctions:toint(nship.shipz +newmap.movez))
if newmap.location=="follow" then
if nship.location=="" then
newmap.location = nship.shipname
else
newmap.location = manager:findmap(nship.location).location
end
end
else
manager:movemap(newmap, newmap.movex, newmap.movey, newmap.movez)
end
end
end
addmaps:Clear()
end
if removemaps.Count>0 then
for a=0, removemaps.Count -1 do
foundmap = manager:findmap(removemaps[a])
if foundmap~=null then
foundship = manager:findshipbymap(foundmap.name)
if foundship~=null then
manager:removeshipmap(foundship, foundmap)
end
manager:removemap(foundmap)
end
end
removemaps:Clear()
end
if manager:findmap(player.location)~=null and manager:findmap(player.location).loaded==1 then
maps = manager:getmaps()
for a=0, maps.Count -1 do
if maps[a].name~=player.location then
loadx = maps[a].x +maps[a].loadx
loady = maps[a].y +maps[a].loady
loadz = maps[a].z +maps[a].loadz
maxloadx = maps[a].x +maps[a].loadmaxx
maxloady = maps[a].y +maps[a].loadmaxy
maxloadz = maps[a].z +maps[a].loadmaxz
if maps[a].loaded==1 or maps[a].location~=player.area then
if luafunctions:toint(player.x)<loadx or luafunctions:toint(player.x)>maxloadx or luafunctions:toint(player.y)<loady or luafunctions:toint(player.y)>maxloady or luafunctions:toint(player.z)<loadz or luafunctions:toint(player.z)>maxloadz or player.area~=maps[a].location then
manager:unloadmap(maps[a].name)
unloadscript = mapfunctions:checkstatetext(maps[a], "unloadscript")
if unloadscript~="" then
manager:runscript(unloadscript, maps[a].name)
end
if maps[a].name~="maps/galaxy/galaxy.lua" and mapfunctions:checkstate(maps[a], "dontsave")==1 and maps[a].location~=player.area then
removemaps:Add(maps[a].name)
end
end
end
if maps[a].location==player.area and maps[a].loaded==0 and luafunctions:toint(player.x)>=loadx and luafunctions:toint(player.x)<=maxloadx and luafunctions:toint(player.y)>=loady and luafunctions:toint(player.y)<=maxloady and luafunctions:toint(player.z)>=loadz and luafunctions:toint(player.z)<=maxloadz then
orgmap = manager:findmap(mapfunctions:checkstatetext(maps[a], "orgmap"))
if orgmap==null or orgmap.loaded==1 then
runscript = mapfunctions:checkstatetext(maps[a], "runscript")
if runscript=="" then
runscript = maps[a].name
end
manager:runscript(runscript, maps[a].name)
maps[a].loaded = 1
for m = 0, maps[a].states.Count -1 do
if maps[a].states[m]=="loadmap" and manager:findmap(manager:replacestring(maps[a].states[m +1], ".map", ".lua"))==null then
addmaps:Add(maps[a].states[m +1])
end
end
end
end
end
end
end
end
end
end
