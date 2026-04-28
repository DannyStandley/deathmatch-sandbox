cleantimer = 180
cleantimer2 = 0
function update() do
cleantimer2 = cleantimer2 +manager:getdeltatime()
if cleantimer2>cleantimer then
cleantimer2 = 0
manager:cleanup()
end
vol = luafunctions:tofloatstr(manager:getsetting("musicvolume"))
sounds = sound:getsounds()
for a=0, sounds.Count -1 do
if sounds[a].name=="music" then
sound:setvolume(sounds[a], 1.0 /100 *vol)
end
end
end
end
