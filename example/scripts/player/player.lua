lightaction = manager:addinputaction()
lightaction:AddBinding("<Keyboard>/"..manager:getsetting("key_light"))
lightaction:AddBinding("<Gamepad>/Dpad/Down")
lightaction:Enable()
jumpaction = manager:addinputaction()
jumpaction:AddBinding("<Keyboard>/"..manager:getsetting("key_jump"))
jumpaction:AddBinding("<Gamepad>/buttonSouth")
jumpaction:Enable()
runaction = manager:addinputaction()
runaction:AddBinding("<Keyboard>/"..manager:getsetting("key_run"))
runaction:AddBinding("<Gamepad>/buttonNorth")
runaction:Enable()
exitbutton = manager:addinputaction()
exitbutton:AddBinding("<Keyboard>/Escape")
exitbutton:AddBinding("<Gamepad>/start")
exitbutton:Enable()
if manager:findmap(player.location)==null then
newmap = manager:loadmap(manager:replacestring(player.location, ".lua", ".map"))
nship = null
ship = mapfunctions:checkstatetext(newmap, "object")
if ship~="" then
nship = manager:getshipscript(manager:findship(ship))
manager:addmaptoship(newmap, nship)
if newmap.location=="follow" then
if nship.location=="" then
newmap.location = nship.shipname
else
newmap.location = manager:findmap(nship.location).location
end
end
end
end
manager:runscript("scripts/setsettings.lua", player.location)
foundmap = manager:findmap(player.location)
runscript = mapfunctions:checkstatetext(foundmap, "runscript")
if runscript=="" then
manager:runscript(player.location, player.location)
else
manager:runscript(runscript, player.location)
end
foundmap.loaded = 1
for a=0, foundmap.states.Count -1 do
if foundmap.states[a]=="loadmap" and manager:findmap(manager:replacestring(foundmap.states[a +1], ".map", ".lua"))==null then
newmap = manager:loadmap(foundmap.states[a +1])
if nship~=null then
nship = manager:getshipscript(manager:findship(ship))
manager:addmaptoship(newmap, nship)
if newmap.location=="follow" then
if nship.location=="" then
newmap.location = nship.shipname
else
newmap.location = manager:findmap(nship.location).location
end
end
end
end
end
player:updatecoords()
player:setpos(player.x, player.y, player.z)
manager:movecamera(player.x, player.y, player.z +0.5)
manager:orientcamera(player.ztheta, player.theta, 0)
foundship = manager:findshipbymap(foundmap.name)
if foundship~=null then
player:matchship(foundship.shipname)
end
if player:checkstate("vacuum")==1 then
player:vacuum()
end
menumove = sound:load(0, 0, 0, "sounds/menumove.ogg", 0, 1, 1, 1)
menuselect = sound:load(0, 0, 0, "sounds/menuselect.ogg", 0, 1, 1, 1)
menuescape = sound:load(0, 0, 0, "sounds/menuescape.ogg", 0, 1, 1, 1)
menuspring = sound:load(0, 0, 0, "sounds/menuspring.ogg", 0, 1, 1, 1)
player:removestate("menumove")
player:removestate("menuselect")
player:removestate("menuescape")
player:removestate("menuspring")
player:setuproom(manager:findmap(manager:replacestring(player.location, ".lua", ".map")))
manager:hidecursor()
manager:addfunction("scripts/player/hud.lua", "update", player.location)
function update() do
if player:checkstate("menumove")==1 then
sound:play(menumove)
player:removestate("menumove")
end
if player:checkstate("menuselect")==1 then
sound:play(menuselect)
player:removestate("menuselect")
end
if player:checkstate("menuescape")==1 then
sound:play(menuescape)
player:removestate("menuescape")
end
if player:checkstate("menuspring")==1 then
sound:play(menuspring)
player:removestate("menuspring")
end
if player:checkstate("switchplayer")==1 then
player:removestate("switchplayer")
player:removestate("menumove")
player:removestate("menuselect")
player:removestate("menuescape")
player:removestate("menuspring")
sound:freesound(menumove)
sound:freesound(menuselect)
sound:freesound(menuescape)
sound:freesound(menuspring)
if manager.foundship~=null then
manager:getshipscript(manager.foundship).source:Stop()
end
manager.foundship = null
manager:runscript("scripts/map/unloadmaps.lua", player.location)
player:removestate("cantmove")
pnum = luafunctions:tointstr(manager:checkstatetext("char"))
manager:setplayernum(pnum)
manager:removestate("char "..manager:checkstatetext("char"))
manager:reloadfunctions()
return
end
if manager.foundship~=null then
foundship = manager:getshipscript(manager.foundship)
if foundship:checkstatetext("type")~="engage point" and foundship.location=="" then
manager:setvector3(manager:getskybox(), "_WindSpeed", 0.0001 *foundship.speed, 0, 0)
end
if player:checkstate("vacuum")==1 and foundship.source.isPlaying==true or foundship:checkstate("enginesoff")==1 and foundship.source.isPlaying==true then
foundship.source:Stop()
end
if player:checkstate("vacuum")==0 and foundship:checkstate("enginesoff")==0 and foundship.source.isPlaying==false then
foundship.source:Play()
end
end
if player:checkstate("cantmove")==0 then
player:updatecoords()
manager:movecamera(player.x, player.y, player.z +0.5)
manager:orientcamera(player.ztheta, player.theta, 0)
if lightaction.triggered then
if player:checkstate("lighton")==0 then
player:addstate("lighton")
else
player:removestate("lighton")
end
end
if runaction.triggered then
if player:checkstate("running")==0 then
player:addstate("running")
else
player:removestate("running")
end
end
if jumpaction.triggered then
if player:checkstate("landing")==1 or player:checkstate("jumping")==1 then
return
end
player:addstate("landz "..luafunctions:tostrfloat(player.orgz))
player:addstate("jumping")
end
if exitbutton.triggered then
manager:addstate("char 0")
player:addstate("switchplayer")
return
end
end
end
end
