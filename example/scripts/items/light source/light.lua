itemstr = manager:splitstr(mapname, ":")
player = manager:findplayer(itemstr[0])
range = luafunctions:tofloatstr(itemstr[3])
intensity = luafunctions:tofloatstr(itemstr[4])
r = luafunctions:tofloatstr(itemstr[5])
g = luafunctions:tofloatstr(itemstr[6])
b = luafunctions:tofloatstr(itemstr[7])
a = luafunctions:tofloatstr(itemstr[8])
mapname = player.location
function setuplight() do
obj = mapfunctions:createobject()
light = mapfunctions:spawnobject(player.orgx, player.orgy, player.orgz +0.5, 0, player.theta, 0, obj, 0, player.location)
mapfunctions:destroyobj(obj)
mapfunctions:attachlight(light, "spot")
mapfunctions:setlightrange(light, range)
mapfunctions:setlightintensity(light, intensity)
mapfunctions:setlightcolor(light, r, g, b, a)
if player:checkstate("lighton")==0 then
mapfunctions:disablelight(light)
end
end
end
setuplight()
function update() do
foundmap = manager:findmap(player.location)
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
mapfunctions:destroyobj(light)
manager:removefunction(updatefunction)
return
end
if player.location~=mapname then
mapfunctions:destroyobj(light)
setuplight()
mapname = player.location
end
misc = mapfunctions:getmisc(light)
misc.orienty = player.theta
misc.orgx = player.orgx
misc.orgy = player.orgy
misc.orgz = player.orgz +0.5
if player:checkstate("lighton")==1 then
mapfunctions:enablelight(light)
else
mapfunctions:disablelight(light)
end
end
end
