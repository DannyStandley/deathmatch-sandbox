remplayers = ""
manager:savestates()
manager:saveships()
manager:savesettings()
manager:savemaps()
players = manager:getplayerlist()
for a=1, players.Count -1 do
if players[a]:checkstate("dontsave")==0 then
if players[a]:checkstate("delete")==1 then
remplayers = remplayers..players[a].playername..":"
else
players[a]:save()
end
end
end
delplayers = manager:splitstr(remplayers, ":")
for a=0, delplayers.Length -1 do
manager:removeplayer(delplayers[a])
end
