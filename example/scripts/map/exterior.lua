skybox = mapfunctions:checkstatetext(manager:findmap(mapname), "skybox")
if skybox~="" then
manager:changeskybox(manager:loadmaterial(skybox))
end
manager:addfunction("scripts/map/spacezone.lua", "update", mapname)
