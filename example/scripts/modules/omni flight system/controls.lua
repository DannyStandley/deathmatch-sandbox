epower = 0
if manager:getsetting("tts")=="on" then
luafunctions:say("Now piloting.")
manager:addstate("tts pilot")
end
turntimer = 0.23
turntimer2 = 0
foundship = manager:getshipscript(manager.foundship)
maxspeed = foundship.maxspeed
power = 0
if foundship:checkstatetext("power")~="" then
power = luafunctions:tointstr(foundship:checkstatetext("power"))
end
function clearpowersetting() do
foundship:removestate("power "..foundship:checkstatetext("power"))
power = 0
end
end
function setpowersetting() do
if epower==0 then
maxspeed = foundship.maxspeed
else
maxspeed = foundship.maxspeed /100 *epower
end
if power==0 and foundship.desiredspeed>0 then
power = 5
foundship.desiredspeed = maxspeed
if foundship:checkstatetext("power")=="" then
foundship:removestate("power "..foundship:checkstatetext("power"))
foundship:addstate("power 5")
end
end
end
end
setpowersetting()
retroaction = manager:addinputaction()
retroaction:AddBinding("<Keyboard>/R")
retroaction:AddBinding("<Gamepad>/buttonEast")
retroaction:Enable()
fusjump = manager:addinputaction()
fusjump:AddBinding("<Keyboard>/F")
fusjump:AddBinding("<Gamepad>/buttonNorth")
fusjump:Enable()
function setpower() do
if foundship:checkstate("enginesoff")==1 then
power = 0
return
end
if power==0 then
luafunctions:say("Full Stop.")
foundship.desiredspeed = 0
end
if power==1 then
luafunctions:say("Ahead dock speed.")
foundship.desiredspeed = maxspeed /100 *1
end
if power==2 then
luafunctions:say("Ahead one quarters.")
foundship.desiredspeed = maxspeed /100 *10
end
if power==3 then
luafunctions:say("Ahead three quarters.")
foundship.desiredspeed = maxspeed /100 *25
end
if power==4 then
luafunctions:say("Ahead half speed.")
foundship.desiredspeed = maxspeed /100 *50
end
if power==5 then
luafunctions:say("Ahead full.")
foundship.desiredspeed = maxspeed
end
foundship:removestate("power "..foundship:checkstatetext("power"))
foundship:addstate("power "..luafunctions:str(power))
end
end
fullpower = manager:addinputaction()
fullpower:AddBinding("<Keyboard>/F4")
fullpower:Enable()
allstop = manager:addinputaction()
allstop:AddBinding("<Keyboard>/F1")
allstop:Enable()
powerincrease = manager:addinputaction()
powerincrease:AddBinding("<Keyboard>/F3")
powerincrease:AddBinding("<Gamepad>/buttonSouth")
powerincrease:Enable()
powerdecrease = manager:addinputaction()
powerdecrease:AddBinding("<Keyboard>/F2")
powerdecrease:AddBinding("<Gamepad>/buttonWest")
powerdecrease:Enable()
climbup = manager:addinputaction()
climbup:AddBinding("<Keyboard>/PageUp")
climbup:AddBinding("<Gamepad>/Dpad/Up")
climbup:Enable()
climbdown = manager:addinputaction()
climbdown:AddBinding("<Keyboard>/PageDown")
climbdown:AddBinding("<Gamepad>/Dpad/Down")
climbdown:Enable()
moveaction = manager:addinputaction()
moveaction:AddCompositeBinding("DPad"):With("Up", "<Keyboard>/upArrow"):With("Down", "<Keyboard>/downArrow"):With("Left", "<Keyboard>/leftArrow"):With("Right", "<Keyboard>/rightArrow")
moveaction:AddCompositeBinding("2DVector"):With("Up", "<Gamepad>/leftStick/Up"):With("Down", "<Gamepad>/leftStick/Down"):With("Left", "<Gamepad>/leftStick/Left"):With("Right", "<Gamepad>/leftStick/Right")
moveaction:Enable()
exitaction = manager:addinputaction()
exitaction:AddBinding("<Keyboard>/Escape")
exitaction:AddBinding("<Gamepad>/Start")
exitaction:Enable()
function update() do
if retroaction.triggered then
if foundship:checkstate("moveform 0.0001")==1 then
if manager:getsetting("tts")=="on" then
luafunctions:say("Retro rockets on.")
end
foundship:removestate("moveform 0.0001")
foundship:addstate("moveform 0.001")
return
end
if foundship:checkstate("moveform 0.001")==1 then
if manager:getsetting("tts")=="on" then
luafunctions:say("Retro rockets off.")
end
foundship:removestate("moveform 0.001")
foundship:addstate("moveform 0.0001")
return
end
end
if fusjump.triggered then
if foundship.location~="" then
manager:runscript("scripts/ship/fusion.lua", mapname)
else
manager:runscript("scripts/ship/defusion.lua", mapname)
end
end
if climbup.triggered then
foundship.dir = "up"
return
end
if climbdown.triggered then
foundship.dir = "down"
return
end
turntimer2 = turntimer2 +manager:getdeltatime()
if turntimer2>turntimer then
turntimer2 = 0
movevector = manager:checkinputmovement(moveaction)
if movevector.x>0 and movevector.y>0 then
foundship.dir = "northeast"
return
end
if movevector.x<0 and movevector.y>0 then
foundship.dir = "northwest"
return
end
if movevector.x<0 and movevector.y<0 then
foundship.dir = "southwest"
return
end
if movevector.x>0 and movevector.y<0 then
foundship.dir = "southeast"
return
end
if movevector.x==0 and movevector.y>0 then
foundship.dir = "north"
return
end
if movevector.x==0 and movevector.y<0 then
foundship.dir = "south"
return
end
if movevector.x>0 and movevector.y==0 then
foundship.dir = "east"
return
end
if movevector.x<0 and movevector.y==0 then
foundship.dir = "west"
return
end
end
if fullpower.triggered and power~=5 then
power = 5
setpower()
end
if allstop.triggered and power~=0 then
power = 0
setpower()
end
if powerincrease.triggered and power<5 then
power = power +1
setpower()
end
if powerdecrease.triggered and power>0 then
power = power -1
setpower()
end
if exitaction.triggered then
if manager:getsetting("tts")=="on" then
luafunctions:say("No longer piloting.")
manager:removestate("tts pilot")
end
player:removestate("cantmove")
manager:removefunction(updatefunction)
return
end
end
end
