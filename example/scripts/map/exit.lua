curship = manager:findshipbymap(mapname)
if curship~=null and curship~=manager:getshipscript(manager.foundship) and curship~=manager:findshipbymap(curship.location) then
return
end
oldfoundmap = manager:findmap(mapname)
foundship = null
findmapname = manager:getshipscript(manager.foundship).location
if findmapname=="" then
findmapname = manager:getshipscript(manager.foundship).maps[0].name
end
foundship = manager:findshipbymap(findmapname)
if player:checkforlocation()==0 and player.location==mapname then
player.location = findmapname
if foundship~=null then
player:matchship(foundship.shipname)
end
foundmap = manager:findmap(findmapname)
player.orgx = luafunctions:toint(manager:movedistance(foundmap.x, luafunctions:toint(oldfoundmap.x +player.orgx), 0))
player.orgy = luafunctions:toint(manager:movedistance(foundmap.y, luafunctions:toint(oldfoundmap.y +player.orgy), 0))
player.orgz = luafunctions:toint(manager:movedistance(foundmap.z, luafunctions:toint(oldfoundmap.z +player.orgz), 0))
player:setuproom(foundmap)
end
