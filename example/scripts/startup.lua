player:addstate("cantmove")
manager:hidecursor()
videostarted = 0
starttimer = 0.5
starttimer2 = 0
manager:setupzone(player, "livingroom")
blankmat = manager:addmaterial("Unlit/Texture")
manager:settexture(blankmat, "_MainTex", manager:loadtexture("scripts/blank.png"))
cube = mapfunctions:createcube()
obj = mapfunctions:spawnobject(0, 1, 0.5, 0, 0, 0, cube, 1, mapname, blankmat)
mapfunctions:changescale(obj, 0.7, 0.7, 0.7)
mapfunctions:destroyobj(cube)
mapfunctions:attachvideo(obj, "scripts/sfronteers.webm")
mapfunctions:playvideo(obj)
starttime = 0.1
starttime2 = 0
skipaction = manager:addinputaction()
skipaction:AddBinding("<Keyboard>/Escape")
skipaction:AddBinding("<Gamepad>/buttonSouth")
skipaction:Enable()
function update() do
manager:movecamera(0, 0, 0.5)
manager:orientcamera(0, 0, 0)
if videostarted==1 and skipaction.triggered then
mapfunctions:stopvideo(obj)
end
if videostarted==0 then
starttimer2 = starttimer2 +manager:getdeltatime()
if starttimer2>starttimer then
starttimer2 = 0
videostarted = 1
end
end
if videostarted==1 then
starttime2 = starttime2 +manager:getdeltatime()
if starttime2>starttime then
starttime2 = 0
if mapfunctions:isvideoplaying(obj)==false then
mapfunctions:destroyobj(obj)
manager:addfunction("scripts/player/player.lua", "update", manager:getplayerlist()[0].location)
manager:removefunction(updatefunction)
return
end
end
end
end
end
