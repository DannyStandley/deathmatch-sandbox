foundship = null
galcheck = manager:addinputaction()
galcheck:AddBinding("<Keyboard>/G")
galcheck:AddBinding("<Gamepad>/rightTrigger")
galcheck:Enable()
checkdir = manager:addinputaction()
checkdir:AddBinding("<Keyboard>/Z")
checkdir:AddBinding("<Gamepad>/rightShoulder")
checkdir:Enable()
speedcheck = manager:addinputaction()
speedcheck:AddBinding("<Keyboard>/X")
speedcheck:AddBinding("<Gamepad>/leftTrigger")
speedcheck:Enable()
fpscheck = manager:addinputaction()
fpscheck:AddBinding("<Keyboard>/F")
fpscheck:AddBinding("<Gamepad>/rightShoulder")
fpscheck:Enable()
coordscheck = manager:addinputaction()
coordscheck:AddBinding("<Keyboard>/C")
coordscheck:AddBinding("<Gamepad>/leftShoulder")
coordscheck:Enable()
function update() do
if manager:getsetting("tts")=="off" then
manager:removefunction(updatefunction)
return
end
if manager:checkstatetext("tts")=="pilot" then
if foundship==null then
foundship = manager:findshipbymap(player.location)
end
maxspeed = foundship.maxspeed
if foundship:checkstate("enginesoff")==1 then
maxspeed = 0
end
if speedcheck.triggered then
luafunctions:say(luafunctions:str(foundship.speed).." out of a maximum obtainable of "..luafunctions:str(maxspeed).." galactic myles per hour.")
end
if coordscheck.triggered then
luafunctions:say(luafunctions:str(foundship.shipx)..", "..luafunctions:str(foundship.shipy)..", "..luafunctions:str(foundship.shipz))
end
if galcheck.triggered then
luafunctions:say(luafunctions:str(foundship.galx)..", "..luafunctions:str(foundship.galy)..", "..luafunctions:str(foundship.galz))
end
if checkdir.triggered then
luafunctions:say(foundship.dir)
end
end
if manager:checkstatetext("tts")=="" then
foundship = null
if fpscheck.triggered then
luafunctions:say(luafunctions:str(manager:getfps()).." frames per second.")
end
if coordscheck.triggered then
luafunctions:say(luafunctions:str(player.orgx)..", "..luafunctions:str(player.orgy)..", "..luafunctions:str(player.orgz))
end
end
end
end
