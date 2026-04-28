player:devacuum()
if manager:findluafunction("maps/galaxy/galaxyupdate.lua", "update", player.location)==null then
manager:addfunction("maps/galaxy/galaxyupdate.lua", "update", mapname)
end
