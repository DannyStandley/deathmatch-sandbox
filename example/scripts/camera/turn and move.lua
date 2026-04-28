moveaction = manager:addinputaction()
moveaction:AddCompositeBinding("Dpad"):With("Left", "<Keyboard>/"..manager:getsetting("key_sideleft")):With("Right", "<Keyboard>/"..manager:getsetting("key_sideright")):With("Down", "<Keyboard>/"..manager:getsetting("key_backward")):With("Up", "<Keyboard>/"..manager:getsetting("key_forward"))
moveaction:AddCompositeBinding("2DVector"):With("Up", "<Gamepad>/leftStick/Up"):With("Down", "<Gamepad>/leftStick/Down"):With("Right", "<Gamepad>/leftStick/Right"):With("Left", "<Gamepad>/leftStick/Left")
moveaction:Enable()
oldx = player.x
oldy = player.y
oldz = player.z
function update() do
if player.playername~="The Watcher" and player:checkstate("cantmove")==0 then
player:removestate("walkforward")
player:removestate("walkbackward")
player:removestate("walkleft")
player:removestate("walkright")
player:removestate("turnleft")
player:removestate("turnright")
movevector = manager:checkinputmovement(moveaction)
if movevector.y>0 then
player:addstate("walkforward")
oldx = player.x
oldy = player.y
oldz = player.z
end
if movevector.y<0 then
player:addstate("walkbackward")
oldx = player.x
oldy = player.y
oldz = player.z
end
if movevector.x<0 then
player:addstate("walkleft")
if player.x~=oldx or player.y~=oldy or player.z~=oldz then
player:addstate("turnleft")
end
oldx = player.x
oldy = player.y
oldz = player.z
end
if movevector.x>0 then
player:addstate("walkright")
if player.x~=oldx or player.y~=oldy or player.z~=oldz then
player:addstate("turnright")
end
oldx = player.x
oldy = player.y
oldz = player.z
end
end
end
end
