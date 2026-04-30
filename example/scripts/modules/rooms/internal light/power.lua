foundmap = manager:findmap(mapname)
powermap = mapfunctions:checkstatetext(foundmap, "powermap")
orgmap = manager:findmap(mapfunctions:checkstatetext(foundmap, "orgmap"))
objname = mapfunctions:checkstatetext(foundmap, "objname")
spawnx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawnx"))
spawny = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawny"))
spawnz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawnz"))
obj = mapfunctions:getobj(spawnx, spawny, spawnz, objname, orgmap)
function update() do
foundmap = manager:findmap(mapname)
orgmap = manager:findmap(mapfunctions:checkstatetext(foundmap, "orgmap"))
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 or orgmap==null or orgmap.loaded==0 then
manager:removefunction(updatefunction)
return
end
if manager:checkstate("powered "..powermap)==1 then
mapfunctions:enablelight(obj)
else
mapfunctions:disablelight(obj)
end
end
end
