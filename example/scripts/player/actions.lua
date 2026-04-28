function setupscripts() do
for a=0, player.states.Count -1 do
statestr = manager:splitstr(player.states[a], "|")
if statestr[0]=="script" then
manager:addfunction(statestr[1], "update", player.playername)
end
end
end
end
function setupitems() do
for a=0, player.states.Count -1 do
splitstr = manager:splitstr(player.states[a], "|")
if splitstr[0]=="item" then
manager:addfunction(manager:splitstr(splitstr[1], ":")[0], "update", player.playername..":"..splitstr[1])
end
end
end
end
needsetup = 1
if mapname=="The Watcher" then
manager:removefunction(updatefunction)
return
end
player = manager:findplayer(mapname)
if player==null then
manager:removefunction(updatefunction)
return
end
mapname = player.location
if player:checkstatetext("maxhealth")=="" then
player:addstate("maxhealth 10.0")
player:addstate("health 10.0")
end
health = luafunctions:tofloatstr(player:checkstatetext("health"))
maxhealth = luafunctions:tofloatstr(player:checkstatetext("maxhealth"))
jumptimer = 0.1
jumptimer2 = 0
resetsteps = 0.1
resetsteps2 = 0
oldx = player.orgx
oldy = player.orgy
oldz = player.orgz
steps = 0
speed = 0
walktimer = 0.1
walktimer2 = 0
turntimer = 0.01
turntimer2 = 0
hturn = 150
function turnleft() do
if player.theta<0 then
player.theta = 359 +0.01 *hturn
end
player.theta = player.theta -0.01 *hturn
end
end
function turnright() do
if player.theta>359 then
player.theta = 0 +0.001 *hturn
end
player.theta = player.theta +0.01 *hturn
end
end
function update() do
if player==null or player:checkstate("delete")==1 then
manager:removefunction(updatefunction)
return
end
foundmap = manager:findmap(player.location)
if foundmap~=null then
if needsetup==1 then
needsetup = 0
setupitems()
setupscripts()
end
player.area = foundmap.location
end
if player:checkstate("running")==0 then
speed = luafunctions:tointstr(player:checkstatetext("speed"))
end
if player:checkstate("running")==1 then
speed = luafunctions:tointstr(player:checkstatetext("runspeed"))
end
if player:checkstate("swimming")==1 then
speed = luafunctions:tointstr(player:checkstatetext("swimspeed"))
end
hturn = luafunctions:tointstr(player:checkstatetext("hturn"))
resetsteps2 = resetsteps2 +manager:getdeltatime()
if resetsteps2>resetsteps then
resetsteps2 = 0
if player:checkstate("walkforward")==0 and player:checkstate("walkbackward")==0 and player:checkstate("walkleft")==0 and player:checkstate("walkright")==0 then
steps = 0.3
end
end
jumptimer2 = jumptimer2 +manager:getdeltatime()
if jumptimer2>jumptimer then
jumptimer2 = 0
jumpheight = luafunctions:tointstr(player:checkstatetext("jumpheight"))
jumpspeed = luafunctions:tointstr(player:checkstatetext("jumpspeed"))
if player:checkstatetext("fallspeed")~="" then
jumpspeed = luafunctions:tointstr(player:checkstatetext("fallspeed"))
end
if player:checkstatetext("landz")~="" then
landz = luafunctions:tointstr(player:checkstatetext("landz"))
end
if player:checkstate("jumping")==1 then
player:walk("up", jumpspeed)
if player.orgz>landz +0.01 *jumpheight or manager:checkmove(jumpspeed, player.x, player.y, player.z +0.001 *jumpspeed)~=null then
player:removestate("jumping")
player:addstate("landing")
end
end
if player:checkstate("landing")==1 then
player:walk("down", jumpspeed)
if player.orgz<=landz +0.01 *jumpspeed then
player:removestate("landing")
player.orgz = landz
player:updatemove(jumpspeed)
player:playstepsounds()
player:removestate("landz "..player:checkstatetext("landz"))
player:removestate("fallspeed "..player:checkstatetext("fallspeed"))
end
end
end
walktimer2 = walktimer2 +manager:getdeltatime()
if walktimer2>walktimer then
walktimer2 = 0
if player:checkstate("jumping")==1 or player:checkstate("landing")==1 then
steps = 0
end
if oldx~=player.orgx or oldy~=player.orgy or oldz~=player.orgz then
if player:checkstate("walkforward")==1 or player:checkstate("walkbackward")==1 or player:checkstate("walkleft")==1 or player:checkstate("walkright")==1 then
oldx = player.orgx
oldy = player.orgy
oldz = player.orgz
steps = steps +0.001 *speed
if steps>=0.35 then
steps = 0
player:playstepsounds()
end
end
end
player:setpos(player.x, player.y, player.z)
if player:checkstate("walkforward")==1 then
player:walk("forward", speed)
end
if player:checkstate("walkbackward")==1 then
player:walk("backward", speed)
end
if player:checkstate("walkright")==1 then
player:walk("right", speed)
end
if player:checkstate("walkleft")==1 then
player:walk("left", speed)
end
end
turntimer2 = turntimer2 +manager:getdeltatime()
if turntimer2>turntimer then
turntimer2 = 0
if player:checkstate("turnleft")==1 then
turnleft()
end
if player:checkstate("turnright")==1 then
turnright()
end
end
end
end
