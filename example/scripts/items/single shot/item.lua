function setupshell() do
cube = mapfunctions:createcube()
mapfunctions:changescale(cube, 0.1, 0.1, 0.1)
shell = mapfunctions:spawnobject(player.orgx, player.orgy, player.orgz, player.ztheta, player.theta, 0, cube, 0, mapname, shellmat)
mapfunctions:destroyobj(cube)
mapfunctions:attachlight(shell, "spot")
mapfunctions:setlightintensity(shell, 20)
mapfunctions:setlightrange(shell, 20)
mapfunctions:setlightcolor(shell, 1, 1, 1, 1)
mapfunctions:hideobject(shell)
misc = mapfunctions:getmisc(shell)
end
end
oldstate = "item|"..mapname
mapstr = manager:splitstr(mapname, ":")
maxammo = luafunctions:tointstr(mapstr[2])
ammo = luafunctions:tointstr(mapstr[3])
damage = luafunctions:tofloatstr(mapstr[5])
recoil = luafunctions:tofloatstr(mapstr[6])
range = luafunctions:tofloatstr(mapstr[7])
ptype = mapstr[8]
material = mapstr[9]
firesound = mapstr[10]
reloadsound = mapstr[11]
accuracy = 0
oldammo = ammo
destorgx = 0
destorgy = 0
destorgz = 0
orgtheta = 0
speedtimer = 0.01
speedtimer2 = 0
firetimer = luafunctions:tofloatstr(mapstr[4])
firetimer2 = 0
firing = 0
oldplayer = player
player = manager:findplayer(mapstr[0])
if player==null then
manager:removefunction(updatefunction)
return
end
mapname = player.location
if manager:findmap(mapname)~=null then
shellmat = manager:loadmaterial(material.."/"..manager:getsetting("graphicstype")..".mat")
setupshell()
end
fireaction = manager:addinputaction()
fireaction:AddCompositeBinding("DPad"):With("Down", "<Keyboard>/"..manager:getsetting("key_"..ptype))
fireaction:AddCompositeBinding("DPad"):With("Down", "<Gamepad>/rightTrigger")
fireaction:Enable()
firesound = sound:load(0, 0, 0, firesound, 0, 0, 1, false)
reloadsound = sound:load(0, 0, 0, reloadsound, 0, 0, 1, false)
function update() do
if player:checkstate("delete")==1 or oldplayer:checkstate("switchplayer")==1 or manager:findmap(player.location)==null then
mapfunctions:destroyobj(shell)
sound:freesound(reloadsound)
sound:freesound(firesound)
manager:removefunction(updatefunction)
return
end
if player.location~=mapname and manager:findmap(mapname)~=null and manager:findmap(player.location)~=null then
mapfunctions:destroyobj(shell)
mapname = player.location
foundmap = manager:findmap(mapname)
setupshell()
end
if ammo~=oldammo then
oldammo = ammo
oldstate = manager:replacestring(oldstate, player.playername..":", "")
player:removestate(oldstate)
oldstate = "item|"
mapstr[3] = luafunctions:str(ammo)
for a=1, mapstr.Length -1 do
oldstate = oldstate..mapstr[a]
if a<mapstr.Length -1 then
oldstate = oldstate..":"
end
end
player:addstate(oldstate)
end
foundmap = manager:findmap(mapname)
if foundmap~=null then
sound:movesound(firesound, foundmap.x +player.orgx, foundmap.y +player.orgy, foundmap.z +player.orgz)
sound:movesound(reloadsound, foundmap.x +player.orgx, foundmap.y +player.orgy, foundmap.z +player.orgz)
if firing==0 then
misc.orientx = player.ztheta
misc.orienty = player.theta
misc.orgx = player.orgx
misc.orgy = player.orgy
misc.orgz = player.orgz
end
end
if firing==1 then
speedtimer2 = manager:getdeltatime()
if speedtimer2>speedtimer then
speedtimer2 = 0
destorgx = destorgx +manager:round(manager:sin(orgtheta *manager:getpi() /180))
destorgy = destorgy +manager:round(manager:cos(orgtheta *manager:getpi() /180))
destorgz = destorgz -0.1
if foundmap~=null and foundmap.loaded==1 then
misc.orgx = destorgx
misc.orgy = destorgy
misc.orgz = destorgz
misc.orienty = orgtheta
end
if luafunctions:getdistance(player.orgx, player.orgy, player.orgz, misc.orgx, misc.orgy, misc.orgz)>=0.1 *range or manager:checkmove(100, misc.transform.position.x, misc.transform.position.z, misc.transform.position.y)~=null then
firing = 0
if foundmap~=null and foundmap.loaded==1 then
mapfunctions:hideobject(shell)
end
end
end
end
if player:checkstate("reload")==1 and ammo==0 and sound:checkplaying(reloadsound)==0 then
player:updatecoords()
player:setpos(player.x, player.y, player.z)
sound:play(reloadsound)
ammo = maxammo
accuracy = 0
end
if player:checkstate("reload")==1 and ammo~=0 and sound:checkplaying(reloadsound)==0 then
player:removestate("reload")
player:removestate("fire")
firing = 0
firetimer2 = 0
return
end
if player:checkstate("reload")==0 and player:checkstate("fire")==1 then
firetimer2 = firetimer2 +manager:getdeltatime()
if firetimer2>firetimer then
firetimer2 = 0
if foundmap~=null and oldplayer.area==player.area then
player:updatecoords()
player:setpos(player.x, player.y, player.z)
if ammo<=0 then
player:addstate("reload")
player:removestate("fire")
return
end
ammo = ammo -1
sound:play(firesound)
firing = 1
misc.orgx = player.orgx +manager:round(manager:sin(player.theta *manager:getpi() /180))
misc.orgy = player.orgy +manager:round(manager:cos(player.theta *manager:getpi() /180))
misc.orgz = luafunctions:random(player.orgz +0.1, player.orgz +1.1)
destorgx = misc.orgx
destorgy = misc.orgy
destorgz = misc.orgz
accuracy = accuracy +(0.1 *recoil)
dir = luafunctions:random(0, 10)
if dir<=5 then
orgtheta = misc.orienty -accuracy
else
orgtheta = misc.orienty +accuracy
end
mapfunctions:showobject(shell)
end
player:removestate("fire")
return
end
end
if player:checkstate("cantmove")==0 and firing==0 and player:checkstate("reload")==0 and player:checkstate("fire")==0 and manager:checkinputmovement(fireaction).y<0 and manager:checkmainplayer(player)==1 then
player:addstate("fire")
end
if manager:checkinputmovement(fireaction).y==0 then
player:removestate("fire")
firetimer2 = firetimer +1
accuracy = 0
end
end
end
