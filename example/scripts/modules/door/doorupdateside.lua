foundmap = manager:findmap(mapname)
if foundmap==null then
manager:removefunction(updatefunction)
return
end
doorsound = sound:load(foundmap.x +0, foundmap.y +0, foundmap.z +0, "maps/union station/sounds/door.ogg", 0, 0, 1)
dooraction = manager:addinputaction()
dooraction:AddBinding("<Keyboard>/"..manager:getsetting("key_interact"))
dooraction:AddBinding("<Gamepad>/buttonWest")
dooraction:Enable()
movetimer = 0.1
movetimer2 = 0
obj = mapfunctions:getobj(0, 0, 0, "door", manager:findmap(mapname))
if obj==null then
sound:freesound(doorsound)
manager:removefunction(updatefunction)
return
end
desty = 0
motion = 0
misc = mapfunctions:getmisc(obj)
if manager:checkstate("open "..mapname)==1 then
misc.orgy = 1
desty = 1
end
function update() do
if foundmap==null or foundmap.loaded==0 then
sound:freesound(doorsound)
manager:removefunction(updatefunction)
return
end
sound:movesound(doorsound, foundmap.x +misc.orgx, foundmap.y +misc.orgy, foundmap.z +misc.orgz)
if motion==1 then
movetimer2 = movetimer2 +manager:getdeltatime()
if movetimer2>movetimer then
movetimer2 = 0
if misc.orgy<desty then
misc.orgy = misc.orgy +0.1
end
if misc.orgy>desty then
misc.orgy = misc.orgy -0.1
end
if luafunctions:getdistance(0, misc.orgy, 0, 0, desty, 0)<=0.1 then
misc.orgy = desty
motion = 0
end
end
end
if mapfunctions:checkstate(foundmap, "interact")==1 then
mapfunctions:removestate(foundmap, "interact")
if manager:checkstate("locked "..mapname)==0 then
if desty==1 then
desty = 0
manager:removestate("open "..mapname)
else
desty = 1
manager:addstate("open "..mapname)
end
motion = 1
sound:play(doorsound)
end
end
if dooraction.triggered and player:checkstate("cantmove")==0 and motion==0 and luafunctions:getdistance(player.x, player.y, player.z, foundmap.x, foundmap.y, foundmap.z)<=0.5 +0.001 *1000 and luafunctions:toint(luafunctions:getdistance(luafunctions:toint(player.x), luafunctions:toint(player.y), luafunctions:toint(player.z), luafunctions:toint(foundmap.x), luafunctions:toint(foundmap.y), luafunctions:toint(foundmap.z)))~=0 then
mapfunctions:addstate(foundmap, "interact")
end
end
end
