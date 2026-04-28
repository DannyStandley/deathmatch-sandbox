foundmap = manager:findmap(mapname)
vacuum = 0
function update() do
if player:checkstate("switchplayer")==1 or foundmap.loaded==0 then
manager:removefunction(updatefunction)
return
end
if player.location==foundmap.name and vacuum==0 then
vacuum = 1
player:vacuum()
if player:checkstate("vacuum")==0 then
player:addstate("vacuum")
end
end
if player.location~=mapname and vacuum==1 then
vacuum = 0
player:devacuum()
player:removestate("vacuum")
end
end
end
