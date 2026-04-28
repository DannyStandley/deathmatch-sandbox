manager:addfunction("scripts/tts.lua", "update", "")
players = manager:getplayerlist()
for a=0, players.Count -1 do
manager:addfunction("scripts/player/actions.lua", "update", players[a].playername)
end
manager:runscript("scripts/setsettings.lua", "")
manager:setplayernum(0)
manager:addfunction("scripts/settings.lua", "update", mapname)
manager:addfunction("scripts/map/mapmanager.lua", "update", "")
manager:addfunction("scripts/startup.lua", "update", "")
manager:addfunction("scripts/camera/"..manager:getsetting("camcontrol")..".lua", "update", "")
