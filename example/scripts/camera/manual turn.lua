moveaction = manager:addinputaction()
moveaction:AddCompositeBinding("Dpad"):With("Up", "<Keyboard>/"..manager:getsetting("key_forward")):With("Down", "<Keyboard>/"..manager:getsetting("key_backward")):With("Right", "<Keyboard>/"..manager:getsetting("key_sideright")):With("Left", "<Keyboard>/"..manager:getsetting("key_sideleft"))
moveaction:AddCompositeBinding("2DVector"):With("Up", "<Gamepad>/leftStick/Up"):With("Down", "<Gamepad>/leftStick/Down"):With("Right", "<Gamepad>/leftStick/Right"):With("Left", "<Gamepad>/leftStick/Left")
moveaction:Enable()
turnaction = manager:addinputaction()
turnaction:AddCompositeBinding("2DVector"):With("Left", "<Gamepad>/rightStick/Left"):With("Right", "<Gamepad>/rightStick/Right"):With("Up", "<Gamepad>/rightStick/Up"):With("Down", "<Gamepad>/rightStick/Down")
turnaction:AddCompositeBinding("Dpad"):With("Left", "<Keyboard>/"..manager:getsetting("key_turnleft")):With("Right", "<Keyboard>/"..manager:getsetting("key_turnright")):With("Up", "<Keyboard>/"..manager:getsetting("key_lookup")):With("Down", "<Keyboard>/"..manager:getsetting("key_lookdown"))
turnaction:Enable()
function update() do
if player.playername~="The Watcher" then
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
turnvector = manager:checkinputmovement(turnaction)
player:removestate("turnleft")
player:removestate("turnright")
if turnvector.x>0 then
player:addstate("turnright")
end
if turnvector.x<0 then
player:addstate("turnleft")
end
end
end
end
