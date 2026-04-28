foundship = manager:getshipscript(manager:findship(mapname))
function update() do
if manager:checkpaused()==0 then
if manager:checkstate()=="menus" or foundship:checkstatetext("destx")=="" or foundship:checkstatetext("desty")=="" or foundship:checkstatetext("destz")=="" then
foundship:removestate("autopilot")
manager:removefunction(updatefunction)
return
end
destx = luafunctions:tofloatstr(foundship:checkstatetext("destx"))
desty = luafunctions:tofloatstr(foundship:checkstatetext("desty"))
destz = luafunctions:tofloatstr(foundship:checkstatetext("destz"))
destgalx = luafunctions:tointstr(foundship:checkstatetext("destgalx"))
destgaly = luafunctions:tointstr(foundship:checkstatetext("destgaly"))
destgalz = luafunctions:tointstr(foundship:checkstatetext("destgalz"))
if foundship.galy<destgaly and foundship.galx<destgalx then
if foundship.galz>destgalz then
foundship.dir = "northeast and down"
end
if foundship.galz<destgalz then
foundship.dir = "northeast and up"
end
if foundship.galz==destgalz then
foundship.dir = "northeast"
end
end
if foundship.galx> destgalx and foundship.galy>destgaly then
if foundship.galz>destgalz then
foundship.dir = "southwest and down"
end
if foundship.galz<destgalz then
foundship.dir = "southwest and up"
end
if foundship.galz==destgalz then
foundship.dir = "southwest"
end
end
if foundship.galx<destgalx and foundship.galy>destgaly then
if foundship.galz>destgalz then
foundship.dir = "southeast and down"
end
if foundship.galz<destgalz then
foundship.dir = "southeast and up"
end
if foundship.galz==destgalz then
foundship.dir = "southeast"
end
end
if foundship.galx>destgalx and foundship.galy<destgaly then
if foundship.galz>destgalz then
foundship.dir = "northwest and down"
end
if foundship.galz<destgalz then
foundship.dir = "northwest and up"
end
if foundship.galz==destgalz then
foundship.dir = "northwest"
end
end
if foundship.galx==destgalx and foundship.galy<destgaly then
if foundship.galz<destgalz then
foundship.dir = "north and up"
end
if foundship.galz>destgalz then
foundship.dir = "north and down"
end
if foundship.galz==destgalz then
foundship.dir = "north"
end
end
if foundship.galx==destgalx and foundship.galy>destgaly then
if foundship.galz<destgalz then
foundship.dir = "south and up"
end
if foundship.galz>destgalz then
foundship.dir = "south and down"
end
if foundship.galz==destgalz then
foundship.dir = "south"
end
end
if foundship.galy==destgaly and foundship.galx<destgalx then
if foundship.galz<destgalz then
foundship.dir = "east and up"
end
if foundship.galz>destgalz then
foundship.dir = "east and down"
end
if foundship.galz==destgalz then
foundship.dir = "east"
end
end
if foundship.galx<destgalx and foundship.galy==destgaly then
if foundship.galz<destgalz then
foundship.dir = "west and up"
end
if foundship.galz>destgalz then
foundship.dir = "west and down"
end
if foundship.galz==destgalz then
foundship.dir = "west"
end
end
if luafunctions:getdistance(foundship.galx, foundship.galy, foundship.galz, destgalx, destgaly, destgalz)<=100 and foundship.desiredspeed>=1000000 then
foundship.desiredspeed = 900000
end
if luafunctions:getdistance(foundship.galx, foundship.galy, foundship.galz, destgalx, destgaly, destgalz)<10 and foundship.desiredspeed>41000 then
foundship.desiredspeed = 41000
end
if foundship.galx==destgalx and foundship.galy==destgaly and foundship.galz==destgalz and foundship.desiredspeed>4000 then
foundship.desiredspeed = 4000
end
if foundship.galx==destgalx and foundship.galy==destgaly and foundship.galz==destgalz then
shipx = luafunctions:toint(foundship.shipx)
shipy = luafunctions:toint(foundship.shipy)
shipz = luafunctions:toint(foundship.shipz)
if shipx<destx and shipy>desty then
if shipz<destz then
foundship.dir = "southeast and up"
else if shipz>destz then
foundship.dir = "southeast and down"
else
foundship.dir = "southeast"
end
end
end
if shipx<destx and shipy<desty then
if shipz<destz then
foundship.dir = "northeast and up"
else if shipz>destz then
foundship.dir = "northeast and down"
else
foundship.dir = "northeast"
end
end
end
if shipx>destx and shipy<desty then
if shipz<destz then
foundship.dir = "northwest and up"
else if shipz>destz then
foundship.dir = "northwest and down"
else
foundship.dir = "northwest"
end
end
end
if shipx>destx and shipy>desty then
if shipz<destz then
foundship.dir = "southwest and up"
else if shipz>destz then
foundship.dir = "southwest and down"
else
foundship.dir = "southwest"
end
end
end
if shipy==desty and shipx>destx then
if shipz<destz then
foundship.dir = "west and up"
else if shipz>destz then
foundship.dir = "west and down"
else
foundship.dir = "west"
end
end
end
if shipy==desty and shipx<destx then
if shipz<destz then
foundship.dir = "east and up"
else if shipz>destz then
foundship.dir = "east and down"
else
foundship.dir = "east"
end
end
end
if shipx==destx and shipy<desty then
if shipz<destz then
foundship.dir = "north and up"
else if shipz>destz then
foundship.dir = "north and down"
else
foundship.dir = "north"
end
end
end
if shipx==destx and shipy>desty then
if shipz<destz then
foundship.dir = "south and up"
else if shipz>destz then
foundship.dir = "south and down"
else
foundship.dir = "south"
end
end
end
if shipx==destx and shipy==desty then
if shipz>destz then
foundship.dir = "down"
else if shipz<destz then
foundship.dir = "up"
end
end
end
if luafunctions:getdistance(shipx, shipy, shipz, destx, desty, destz)<=20 and foundship.desiredspeed>4000 then
foundship.desiredspeed = 4000
end
if foundship.desiredspeed>0 and luafunctions:getdistance(shipx, shipy, shipz, destx, desty, destz)<1 then
foundship.desiredspeed = 0
end
end
end
end
end
