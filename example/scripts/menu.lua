texts = manager:spawnlist()
obj = mapfunctions:createobject()
items = manager:buildlistfromstring(player:checkstatetext("items"), "|")
posx = luafunctions:tofloatstr(player:checkstatetext("posx"))
posz = luafunctions:tofloatstr(player:checkstatetext("posz"))
introtext = null
orgx = player.orgx +luafunctions:toint(manager:round(manager:sin(player.theta *manager:getpi() /180)))
orgy = player.orgy +luafunctions:toint(manager:round(manager:cos(player.theta *manager:getpi() /180)))
orgz = player.orgz
if player:checkstatetext("introtext")~="" then
introtext = mapfunctions:spawnobject(orgx +posx, orgy +1, orgz +posz +0.1, player.ztheta, player.theta, 0, obj, 0, mapname)
mapfunctions:attachtext(introtext, player:checkstatetext("introtext"), 0.03)
end
for a=0, items.Count -1 do
if items[a]~="" then
text = mapfunctions:spawnobject(orgx +posx, orgy, orgz +posz, player.ztheta, player.theta, 0, obj, 0, mapname)
mapfunctions:attachtext(text, items[a], 0.03)
texts:Add(text)
posz = posz -0.1
end
end
mapfunctions:destroyobj(obj)
player:addstate("menuspring")
movetimer = 0.23
movetimer2 = 0
moveaction = manager:addinputaction()
moveaction:AddCompositeBinding("2DVector"):With("Up", "<Gamepad>/leftStick/Up"):With("Down", "<Gamepad>/leftStick/Down")
moveaction:AddCompositeBinding("DPad"):With("Up", "<Gamepad>/dpad/up"):With("Down", "<Gamepad>/dpad/down")
moveaction:AddCompositeBinding("DPad"):With("Up", "<Keyboard>/upArrow"):With("Down", "<Keyboard>/downArrow")
moveaction:Enable()
selectaction = manager:addinputaction()
selectaction:AddBinding("<Keyboard>/Enter")
selectaction:AddBinding("<Gamepad>/buttonSouth")
selectaction:Enable()
backaction = manager:addinputaction()
backaction:AddBinding("<Keyboard>/Escape")
backaction:AddBinding("<Gamepad>/buttonEast")
backaction:Enable()
choice = -1
function itemchoice() do
if choice==-1 then
choice = 0
end
if choice<-1 then
choice = texts.Count -1
end
if choice>=texts.Count then
choice = texts.Count -1
end
for a=0, texts.Count -1 do
mapfunctions:changeobjectcolor(texts[a], 1, 1, 1, 1)
end
mapfunctions:changeobjectcolor(texts[choice], 1, 0.5, 0, 1)
if manager:getsetting("tts")=="on" then
luafunctions:say(mapfunctions:gettext(texts[choice]))
end
end
end
if manager:getsetting("tts")=="on" and player:checkstatetext("introtext")~="" then
luafunctions:say(player:checkstatetext("introtext"))
end
function update() do
movetimer2 = movetimer2 +manager:getdeltatime()
mvector = manager:checkinputmovement(moveaction)
if movetimer2>movetimer and mvector.y<0 then
movetimer2 = 0
choice = choice +1
player:addstate("menumove")
itemchoice()
end
if movetimer2>movetimer and mvector.y>0 then
movetimer2 = 0
choice = choice -1
player:addstate("menumove")
itemchoice()
end
if backaction.triggered and player:checkstate("backout")==1 then
player:addstate("menuescape")
player:addstate("goback")
mapfunctions:clearalltext(mapname)
manager:removefunction(updatefunction)
return
end
if selectaction.triggered then
player:addstate("menuselect")
if choice>=0 then
player:addstate("itemselect "..mapfunctions:gettext(texts[choice]))
mapfunctions:clearalltext(mapname)
manager:removefunction(updatefunction)
return
end
end
end
end
