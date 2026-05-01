foundship = manager:getshipscript(manager:findship(mapname))
minboundx = -1000.99
minboundy = -1000.99
minboundz = -1000.99
maxboundx = 1000.99
maxboundy = 1000.99
maxboundz = 1000.99
if foundship:checkstate("autopilot")==1 then
manager:addfunction("scripts/ship/autopilot.lua", "update", mapname)
end
for a=0, foundship.states.Count -1 do
if foundship.states[a]=="runscript" then
manager:addfunction(foundship.states[a +1], "update", foundship.shipname)
end
end
movetimer = 0.1
movetimer2 = 0
if foundship.dir=="" then
foundship.dir = "north"
end
if foundship.facedir=="" then
foundship.facedir = foundship.dir
end
function update() do
movetimer2 = movetimer2 +manager:getdeltatime()
if movetimer2>movetimer then
movetimer2 = 0
if foundship.speed<=0 and foundship.desiredspeed<1 then
foundship.desiredspeed = 0
end
foundship:acceleration()
foundship:powerloop()
if foundship.location=="" then
shipx = foundship.galx
shipy = foundship.galy
shipz = foundship.galz
else
shipx = foundship.shipx
shipy = foundship.shipy
shipz = foundship.shipz
end
if foundship.dir=="north and up" then
shipy = shipy +0.0001 *foundship.speed
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="south and up" then
shipy = shipy -0.0001 *foundship.speed
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="east and up" then
shipx = shipx +0.0001 *foundship.speed
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="west and up" then
shipx = shipx -0.0001 *foundship.speed
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="northeast and up" then
shipx = shipx +0.0001 *foundship.speed
shipy = shipy +0.0001 *foundship.speed
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="northwest and up" then
shipx = shipx -0.0001 *foundship.speed
shipy = shipy +0.0001 *foundship.speed
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="southeast and up" then
shipx = shipx +0.0001 *foundship.speed
shipy = shipy -0.0001 *foundship.speed
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="southwest and up" then
shipx = shipx -0.0001 *foundship.speed
shipy = shipy -0.0001 *foundship.speed
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="north and down" then
shipy = shipy +0.0001 *foundship.speed
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="south and down" then
shipy = shipy -0.0001 *foundship.speed
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="east and down" then
shipx = shipx +0.0001 *foundship.speed
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="west and down" then
shipx = shipx -0.0001 *foundship.speed
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="northeast and down" then
shipx = shipx +0.0001 *foundship.speed
shipy = shipy +0.0001 *foundship.speed
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="northwest and down" then
shipx = shipx -0.0001 *foundship.speed
shipy = shipy +0.0001 *foundship.speed
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="southeast and down" then
shipx = shipx +0.0001 *foundship.speed
shipy = shipy -0.0001 *foundship.speed
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="southwest and down" then
shipx = shipx -0.0001 *foundship.speed
shipy = shipy -0.0001 *foundship.speed
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="northeast" then
shipx = shipx +0.0001 *foundship.speed
shipy = shipy +0.0001 *foundship.speed
end
if foundship.dir=="northwest" then
shipx = shipx -0.0001 *foundship.speed
shipy = shipy +0.0001 *foundship.speed
end
if foundship.dir=="southeast" then
shipx = shipx +0.0001 *foundship.speed
shipy = shipy -0.0001 *foundship.speed
end
if foundship.dir=="southwest" then
shipx = shipx -0.0001 *foundship.speed
shipy = shipy -0.0001 *foundship.speed
end
if foundship.dir=="up" then
shipz = shipz +0.0001 *foundship.speed
end
if foundship.dir=="down" then
shipz = shipz -0.0001 *foundship.speed
end
if foundship.dir=="north" then
shipy = shipy +0.0001 *foundship.speed
end
if foundship.dir=="south" then
shipy = shipy -0.0001 *foundship.speed
end
if foundship.dir=="east" then
shipx = shipx +0.0001 *foundship.speed
end
if foundship.dir=="west" then
shipx = shipx -0.0001 *foundship.speed
end
if foundship.location~="" then
if shipx<minboundx or shipx>maxboundx or shipy<minboundy or shipy>maxboundy or shipz<minboundz or shipz>maxboundz then
oldship = manager:findshipbymap(foundship.location)
destarea = foundship.shipname
locatemap = manager:findmap(foundship.location)
if mapfunctions:checkstatetext(locatemap, "bound"..foundship.dir)~="" then
foundship.location = mapfunctions:checkstatetext(locatemap, "bound"..foundship.dir)
destarea = manager:findmap(foundship.location).location
if foundship.dir=="north" then
shipy = minboundx
end
if foundship.dir=="south" then
shipy = maxboundy
end
if foundship.dir=="east" then
shipx = minboundx
end
if foundship.dir=="west" then
shipx = maxboundx
end
if foundship.dir=="northeast" then
shipx = minboundx
shipy = minboundy
end
if foundship.dir=="northwest" then
shipx = maxboundx
shipy = minboundy
end
if foundship.dir=="southeast" then
shipx = minboundx
shipy = maxboundy
end
if foundship.dir=="southwest" then
shipx = maxboundx
shipy = maxboundy
end
if foundship.dir=="down" then
shipz = maxboundz
end
if foundship.dir=="up" then
shipz = minboundz
end
end
for d=0, foundship.maps.Count -1 do
foundship.maps[d].location = destarea
end
end
end
if foundship.location=="" then
foundship.galx = shipx
foundship.galy = shipy
foundship.galz = shipz
else
foundship.shipx = shipx
foundship.shipy = shipy
foundship.shipz = shipz
end
for a=0, foundship.maps.Count -1 do
if foundship.maps[a]~=null then
movex = foundship.shipx +foundship.maps[a].movex
movey = foundship.shipy +foundship.maps[a].movey
movez = foundship.shipz +foundship.maps[a].movez
manager:movemap(foundship.maps[a], luafunctions:toint(movex), luafunctions:toint(movey), luafunctions:toint(movez))
if player.location==foundship.maps[a].name then
player:updatecoords()
manager:movecamera(player.x, player.y, player.z +0.5)
manager:orientcamera(player.ztheta, player.theta, 0)
player:setpos(player.x, player.y, player.z)
end
end
end
end
end
end
