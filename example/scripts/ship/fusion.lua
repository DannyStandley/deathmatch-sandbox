foundship = manager:findshipbymap(mapname)
manager:changeskybox(manager:loadmaterial("materials/fusion space/material.mat"))
foundship.location = ""
for a=0, foundship.maps.Count -1 do
foundship.maps[a].location = foundship.shipname
end
mapfunctions:addstate(foundship.maps[0], "skybox materials/fusion space/material.mat")
