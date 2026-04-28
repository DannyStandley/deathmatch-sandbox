turned = 0
moveaction = manager:addinputaction()
moveaction:AddCompositeBinding("Dpad"):With("Up", "<Keyboard>/"..manager:getsetting("key_forward")):With("Down", "<Keyboard>/"..manager:getsetting("key_backward")):With("Right", "<Keyboard>/"..manager:getsetting("key_sideright")):With("Left", "<Keyboard>/"..manager:getsetting("key_sideleft"))
moveaction:AddCompositeBinding("2DVector"):With("Up", "<Gamepad>/leftStick/Up"):With("Down", "<Gamepad>/leftStick/Down"):With("Right", "<Gamepad>/leftStick/Right"):With("Left", "<Gamepad>/leftStick/Left")
moveaction:Enable()
turntimer = 0.15
turntimer2 = 0
turnaction = manager:addinputaction()
turnaction:AddCompositeBinding("2DVector"):With("Left", "<Gamepad>/rightStick/Left"):With("Right", "<Gamepad>/rightStick/Right"):With("Up", "<Gamepad>/rightStick/Up"):With("Down", "<Gamepad>/rightStick/Down")
turnaction:AddCompositeBinding("Dpad"):With("Left", "<Keyboard>/"..manager:getsetting("key_turnleft")):With("Right", "<Keyboard>/"..manager:getsetting("key_turnright")):With("Up", "<Keyboard>/"..manager:getsetting("key_lookup")):With("Down", "<Keyboard>/"..manager:getsetting("key_lookdown"))
turnaction:Enable()
targettheta = player.theta
function update() do
if player.playername~="The Watcher" then
if turned==1 then
turntimer2 = turntimer2 +manager:getdeltatime()
if turntimer2>turntimer then
turntimer2 = 0
turned = 0
end
end
if player:checkstate("cantmove")==0 then
movevector = manager:checkinputmovement(moveaction)
player:removestate("walkforward")
player:removestate("walkright")
player:removestate("walkleft")
player:removestate("walkbackward")
if movevector.y>0 then
player:addstate("walkforward")
end
if movevector.y<0 then
player:addstate("walkbackward")
end
if movevector.x>0 then
player:addstate("walkright")
end
if movevector.x<0 then
player:addstate("walkleft")
end
end
if turned==0 then
hturn = luafunctions:tointstr(player:checkstatetext("hturn"))
turnvector = manager:checkinputmovement(turnaction)
if turnvector.x>0 and turnvector.y>0 then
targettheta = 45 +0.01 *hturn
turned = 1
turntimer2 = 0
return
end
if turnvector.x<0 and turnvector.y<0 then
targettheta = 225 +0.01 *hturn
turned = 1
turntimer2 = 0
return
end
if turnvector.x<0 and turnvector.y>0 then
targettheta = 315 +0.01 *hturn
turned = 1
turntimer2 = 0
return
end
if turnvector.x>0 and turnvector.y<0 then
targettheta = 135 +0.01 *hturn
turned = 1
turntimer2 = 0
return
end
if turnvector.x==0 and turnvector.y>0 then
targettheta = 0 +0.01 *hturn
turned = 1
turntimer2 = 0
return
end
if turnvector.x==0 and turnvector.y<0 then
targettheta = 180 +0.01 *hturn
turned = 1
turntimer2 = 0
return
end
if turnvector.x>0 and turnvector.y==0 then
targettheta = 90 +0.01 *hturn
turned = 1
turntimer2 = 0
return
end
if turnvector.x<0 and turnvector.y==0 then
targettheta = 270 +0.01 *hturn
turned = 1
turntimer2 = 0
return
end
end
if targettheta~=player.theta and player:checkstate("turnleft")==0 and player:checkstate("turnright")==0 then
if player.theta<targettheta then
player:addstate("turnright")
else
player:addstate("turnleft")
end
end
if luafunctions:getdistance(targettheta, 0, 0, player.theta, 0, 0)<=0.01 *hturn then
if player:checkstate("turnleft")==1 or player:checkstate("turnright")==1 then
player.theta = targettheta
player:removestate("turnleft")
player:removestate("turnright")
end
end
end
end
end
