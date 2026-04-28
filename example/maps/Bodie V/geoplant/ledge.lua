foundmap = manager:findmap(mapname)
if foundmap==null then
manager:removefunction(updatefunction)
return
end
ledge = sound:load(foundmap.x +5, foundmap.y +10, foundmap.z, "maps/Bodie V/sounds/ledge.ogg", 1, 0, 1, true)
rivver = sound:load(foundmap.x +5, foundmap.y +10, foundmap.z, "maps/Bodie V/sounds/rivver.ogg", 1, 1, 1, true)
sound:play(rivver)
sound:play(ledge)
function update() do
foundmap = manager:findmap(mapname)
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
sound:freesound(rivver)
sound:freesound(ledge)
manager:removefunction(updatefunction)
return
end
sound:movesound(ledge, foundmap.x +5, foundmap.y +10, foundmap.z)
sound:movesound(rivver, foundmap.x +5, foundmap.y +10, foundmap.z)
if player:checkstate("swimming")==1 then
sound:spatialsound(rivver, 0)
else
sound:spatialsound(rivver, 1)
end
end
end
