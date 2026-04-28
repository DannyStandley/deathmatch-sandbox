foundmap = manager:findmap(mapname)
orgmap = manager:findmap(mapfunctions:checkstatetext(foundmap, "orgmap"))
buttonmat = manager:loadmaterial("materials/button/"..manager:getsetting("graphicstype")..".mat")
orgtheta = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "orgtheta"))
spawnx = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawnx"))
spawny = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawny"))
spawnz = luafunctions:tofloatstr(mapfunctions:checkstatetext(foundmap, "spawnz"))
statetype = mapfunctions:checkstatetext(foundmap, "statetype")
state = mapfunctions:checkstatetext(foundmap, "state")
runscript = mapfunctions:checkstatetext(foundmap, "buttonscript")
cube = mapfunctions:createcube()
obj = mapfunctions:spawnobject(spawnx, spawny, spawnz, 0, orgtheta, 0, cube, 0, mapname, buttonmat)
mapfunctions:changescale(obj, 0.1, 0.1, 0.1)
mapfunctions:destroyobj(cube)
interact = manager:addinputaction()
interact:AddBinding("<Keyboard>/"..manager:getsetting("key_interact"))
interact:AddBinding("<Gamepad>/buttonWest")
interact:Enable()
function update() do
foundmap = manager:findmap(mapname)
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
mapfunctions:destroyobj(obj)
manager:removefunction(updatefunction)
return
end
misc = mapfunctions:getmisc(obj)
if interact.triggered and luafunctions:getdistance(player.x, player.y, player.z, misc.transform.position.x, misc.transform.position.z, misc.transform.position.y)<=0.67 +0.001 *1000 then
if statetype=="manager" then
if manager:checkstate(state)==0 then
manager:addstate(state)
else
manager:removestate(state)
end
end
if statetype=="map" then
if mapfunctions:checkstate(foundmap, state)==1 then
mapfunctions:removestate(foundmap, state)
else
mapfunctions:addstate(foundmap, state)
end
end
if runscript~="" then
manager:runscript(runscript, orgmap.name)
end
end
end
end
