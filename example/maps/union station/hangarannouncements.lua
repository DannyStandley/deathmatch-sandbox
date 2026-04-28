foundmap = manager:findmap(mapname)
if foundmap==null then
manager:removefunction(updatefunction)
return
end
function randomtimer() do
announcetimer = luafunctions:random(10, 60)
end
end
announcetimer = 30
announcetimer2 = 0
oldannounce = 1
announce = 0
randomtimer()
function update() do
foundmap = manager:findmap(mapname)
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
if announce~=0 then
sound:freesound(announce)
end
manager:removefunction(updatefunction)
return
end
if announce~=0 and sound:checkplaying(announce)==0 then
sound:freesound(announce)
announce = 0
end
announcetimer2 = announcetimer2 +manager:getdeltatime()
if announcetimer2>announcetimer and announce==0 then
announcetimer2 = 0
randomtimer()
newannounce = oldannounce
while newannounce==oldannounce do
newannounce = luafunctions:random(1, 4)
end
oldannounce = newannounce
announce = sound:load(foundmap.x +5, foundmap.y +5, foundmap.z +20, "maps/union station/sounds/announce"..luafunctions:str(oldannounce)..".ogg", 0, 0, 1, true)
sound:mufflesound(announce, 0)
sound:radiosound(announce, 0)
sound:play(announce)
end
end
end
