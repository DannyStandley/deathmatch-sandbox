gametypes = manager:splitstr(manager:checkstatetext("gametypes"), "|")
selectsong = 0
checktimer = 0.1
checktimer2 = 0
menutimer = 1
menutimer2 = 0
manager:setcamerafov(60)
songstr = manager:buildfilelist("maps/galaxy/music", "music")
songs = manager:buildstringlist(songstr)
manager:changeskybox(manager:loadmaterial("materials/spacemat/material.mat"))
song = luafunctions:random(0, songs.Count)
function gametypemenu() do
clearstate()
manager:removestate("gametype "..manager:checkstatetext("gametype"))
player:addstate("posx -0.5")
player:addstate("posz 0.5")
player:addstate("menuspring")
player:addstate("backout")
player:addstate("menu gametypemenu")
player:addstate("introtext Select game type.")
itemstr = ""
for a=0, gametypes.Length -1 do
itemstr = itemstr..gametypes[a].."|"
end
player:addstate("items "..itemstr)
manager:addfunction("scripts/menu2.lua", "update", player.location)
end
end
function mapmenu() do
clearstate()
player:addstate("posx -0.5")
player:addstate("posz 0.5")
player:addstate("menuspring")
player:addstate("menu mapmenu")
player:addstate("introtext Select a map.")
player:addstate("backout")
rank = luafunctions:tointstr(manager:checkstatetext("rank"))
maps = ""
states = manager:getstates()
for a=0, states.Count -1 do
cs = manager:splitstr(states[a], "|")
if cs[0]=="map" then
mapstr = manager:splitstr(cs[1], ":")
mrank = luafunctions:tointstr(mapstr[1])
if mrank<=rank then
maps = maps..mapstr[0]..": "..mapstr[3].."|"
end
end
end
player:addstate("items "..maps)
manager:addfunction("scripts/menu2.lua", "update", player.location)
end
end
function entergame() do
manager:removefunction(updatefunction)
if selectsong~=0 then
sound:freesound(selectsong)
selectsong = 0
end
playername = manager:checkstatetext("charname")
clearstate()
newplayer = 0
players = manager:getplayerlist()
for a=0, players.Count -1 do
if players[a].playername==playername then
newplayer = a
end
end
manager:runscript("scripts/setsettings.lua", mapname)
manager:addstate("char "..luafunctions:str(newplayer))
player:addstate("switchplayer")
end
end
function playsong() do
if song>=songs.Count then
song = 0
end
selectsong = sound:load(0, 0, 0, "maps/galaxy/music/"..songs[song], 0, 1, 1, true)
selectsong.name = "music"
sound:play(selectsong)
song = song +1
end
end
function hudmenu() do
clearstate()
player:addstate("menu hudmenu")
player:addstate("introtext Hud customization.")
player:addstate("menuspring")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("items Display hud: "..manager:getsetting("hud").."|Display coordinates in hud: "..manager:getsetting("hudcoords").."|Display rank in hud: "..manager:getsetting("hudrank").."|Display upgrade components in hud: "..manager:getsetting("hudcomponents").."|Display FPS counter in hud: "..manager:getsetting("hudfps"))
player:addstate("backout")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function gamemenu() do
clearstate()
player:addstate("menu gamemenu")
player:addstate("menuspring")
player:addstate("backout")
player:addstate("items Hud|Save game on exit: "..manager:getsetting("save on exit"))
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("introtext Gameplay customization.")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function camtype() do
clearstate()
player:addstate("menu camtype")
player:addstate("introtext Select a camera control skeme.")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("backout")
player:addstate("menuspring")
itemstr = "items "
camstr = manager:buildfilelist("scripts/camera", "camera")
cameras = manager:buildstringlist(camstr)
for a=0, cameras.Count -1 do
cstr = manager:splitstr(cameras[a], ".")[0]
if a~=cameras.Count -1 then
itemstr = itemstr..cstr.."|"
else
itemstr = itemstr..cstr
end
end
player:addstate(itemstr)
manager:addfunction("scripts/menu2.lua", "update", player.location)
end
end
function controlsmenu() do
clearstate()
player:addstate("menu controlsmenu")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("introtext Controls menu.")
player:addstate("items Camera setup")
player:addstate("backout")
player:addstate("menuspring")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function contentmenu() do
clearstate()
player:addstate("menuspring")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("introtext Content manager")
player:addstate("menu contentmenu")
player:addstate("backout")
player:addstate("items Download and install new content|Update installed content|Content repository management|Reload currently active content")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function accessibilitymenu() do
clearstate()
player:addstate("introtext Accessibility menu")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("menuspring")
player:addstate("menu accessibilitymenu")
player:addstate("backout")
player:addstate("items TTS: "..manager:getsetting("tts").."|Graphics: "..manager:getsetting("graphics"))
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function fullscreenmenu() do
clearstate()
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("menuspring")
player:addstate("introtext How should the game be displayed?")
player:addstate("items Windowed|Fullscreen")
player:addstate("menu fullscreenmenu")
player:addstate("backout")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function resmenu() do
clearstate()
player:addstate("introtext Select a resolution.")
player:addstate("items 400x400|640x480|800x600|1024x768|1440x900|1920x1080|3840x2160")
player:addstate("menuspring")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("backout")
player:addstate("menu resmenu")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function displaymenu() do
clearstate()
player:addstate("introtext Display menu")
player:addstate("menu displaymenu")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("items Resolution|Fullscreen mode|Vertical sync: "..manager:getsetting("vsync"))
player:addstate("backout")
player:addstate("menuspring")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function deletechar() do
clearstate()
player:addstate("menu deletechar")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("introtext Which character would you like to delete?")
player:addstate("backout")
player:addstate("menuspring")
itemstr = "items "
players = manager:getplayerlist()
for a=1, players.Count -1 do
if players[a]:checkstate("delete")==0 and players[a]:checkstate("notpick")==0 then
itemstr = itemstr..players[a].playername
if a<players.Count -1 then
itemstr = itemstr.."|"
end
end
end
player:addstate(itemstr)
manager:addfunction("scripts/menu2.lua", "update", player.location)
end
end
function framemenu() do
clearstate()
player:addstate("menu framemenu")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("introtext Choose a framerate.")
player:addstate("backout")
player:addstate("items 30|60|120|180|Uncapt")
player:addstate("menuspring")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function fovmenu() do
clearstate()
player:addstate("menu fovmenu")
player:addstate("backout")
player:addstate("items 30|40|50|60|70|80|90|100")
player:addstate("posx -0.5")
player:addstate("posz 0.9")
player:addstate("introtext Select field of view (lower values may induce motion sickness).")
player:addstate("menuspring")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function graphicsmenu() do
clearstate()
player:addstate("items normal|Colonial Marines|playstation|playstation 2|xbox360|picturebook")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("menuspring")
player:addstate("menu graphicsmenu")
player:addstate("backout")
player:addstate("introtext Select graphics mode.")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function videomenu() do
clearstate()
player:addstate("backout")
player:addstate("menu videomenu")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("items Graphics mode|Graphics mode effects|Field of view|Framerate|Resolution and display")
player:addstate("introtext Video settings.")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function extrasmenu() do
clearstate()
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("introtext Extras menu.")
player:addstate("backout")
player:addstate("menu extrasmenu")
player:addstate("items Logs")
player:addstate("menuspring")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function settingsmenu() do
clearstate()
player:addstate("backout")
player:addstate("menu settingsmenu")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("items Gameplay|Controls|Video|Audio|Network|Content manager|Accessibility")
player:addstate("introtext Settings.")
player:addstate("menuspring")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function charmenu() do
manager:removestate("charname "..manager:checkstatetext("charname"))
clearstate()
player:addstate("menu charmenu")
player:addstate("backout")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
itemstr = "items "
players = manager:getplayerlist()
for a=1, players.Count -1 do
if players[a]:checkstate("delete")==0 and players[a]:checkstate("notpick")==0 then
itemstr = itemstr..players[a].playername.."|"
end
end
itemstr = itemstr.."Create new character|Delete character"
player:addstate("introtext Select a character.")
player:addstate(itemstr)
player:addstate("menuspring")
manager:addfunction("scripts/menu2.lua", "update", player.location)
end
end
function modemenu() do
manager:removestate("mode "..manager:checkstatetext("mode"))
clearstate()
player:addstate("menu modemenu")
player:addstate("introtext Select a mode.")
player:addstate("items Universe|Combat|Tutorial")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("backout")
player:addstate("menuspring")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function mainmenu() do
manager:removestate("combattype "..manager:checkstatetext("combattype"))
manager:removestate("charname "..manager:checkstatetext("charname"))
manager:removestate("mode "..manager:checkstatetext("mode"))
clearstate()
player:addstate("menu mainmenu")
player:addstate("introtext Main Menu.")
player:addstate("items Enter|Settings|Upgrades|Extras|Save Game|Quit")
player:addstate("posx -0.5")
player:addstate("posz 0.7")
player:addstate("menuspring")
manager:addfunction("scripts/menu.lua", "update", player.location)
end
end
function clearstate() do
player:removestate("introtext "..player:checkstatetext("introtext"))
player:removestate("backout")
player:removestate("goback")
player:removestate("menu "..player:checkstatetext("menu"))
player:removestate("items "..player:checkstatetext("items"))
player:removestate("posx "..player:checkstatetext("posx"))
player:removestate("posz "..player:checkstatetext("posz"))
player:removestate("itemselect "..player:checkstatetext("itemselect"))
end
end
remplayers = ""
players = manager:getplayerlist()
for a=1, players.Count -1 do
if players[a]:checkstate("getridofme")==1 then
remplayers = remplayers..players[a].playername.."|"
players[a]:addstate("delete")
end
end
delplayers = manager:splitstr(remplayers, "|")
for a=0, delplayers.Length -1 do
if delplayers[a]~="" then
manager:removeplayer(delplayers[a])
end
end
manager:removestate("combattype "..manager:checkstatetext("combattype"))
manager:removestate("charname "..manager:checkstatetext("charname"))
manager:removestate("mode "..manager:checkstatetext("mode"))
mainmenu()
function update() do
checktimer2 = checktimer2 +manager:getdeltatime()
if checktimer2>checktimer then
checktimer2 = 0
if manager:getsetting("graphics")=="off" then
manager:disablecamera()
end
end
foundmap = manager:findmap("maps/galaxy/galaxy.lua")
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
manager:removefunction(updatefunction)
return
end
if player:checkstate("cantmove")==0 then
player:addstate("cantmove")
end
manager:movecamera(player.x, player.y, player.z +0.5)
manager:orientcamera(player.ztheta, player.theta, 0)
if selectsong==0 or sound:checkplaying(selectsong)==0 then
if selectsong~=0 then
sound:freesound(selectsong)
end
playsong()
end
if player:checkstatetext("menu")=="gametypemenu" then
if player:checkstate("goback")==1 then
charmenu()
return
end
if player:checkstatetext("itemselect")~="" then
manager:addstate("combattype "..player:checkstatetext("itemselect"))
mapmenu()
return
end
end
if player:checkstatetext("menu")=="mapmenu" then
if player:checkstate("goback")==1 then
gametypemenu()
return
end
if player:checkstatetext("itemselect")~="" then
map = manager:splitstr(player:checkstatetext("itemselect"), ":")[0]
setplayer = manager:findplayer(manager:checkstatetext("charname"))
states = manager:getstates()
for a=0, states.Count -1 do
cs = manager:splitstr(states[a], "|")
if cs[0]=="map" then
mapstr = manager:splitstr(cs[1], ":")
if mapstr[0]==map then
nplayer = manager:createplayer()
nplayer.playername = "combat char"
nplayer:addstate("dontpick")
nplayer:addstate("dontsave")
nplayer:addstate("getridofme")
for m=0, setplayer.states.Count -1 do
nplayer:addstate(setplayer.states[m])
end
nplayer:removestate("running")
nplayer:removestate("cantmove")
nplayer.location = mapstr[2]
speed = luafunctions:tofloatstr(nplayer:checkstatetext("speed"))
nplayer.orgx = 0 +0.001 *speed
nplayer.orgy = 0 +0.001 *speed
nplayer.orgz = 0
manager:removestate("charname "..setplayer.playername)
manager:addstate("charname "..nplayer.playername)
manager:addfunction("scripts/player/actions.lua", "update", nplayer.playername)
end
end
end
entergame()
return
end
end
if player:checkstatetext("menu")=="contentmenu" then
if player:checkstate("goback")==1 then
settingsmenu()
return
end
if player:checkstatetext("itemselect")=="Reload currently active content" then
manager:removefunction(updatefunction)
if selectsong~=0 then
sound:freesound(selectsong)
selectsong = 0
end
manager:runscript("scripts/setsettings.lua", mapname)
manager:addstate("char 0")
player:addstate("switchplayer")
manager:unloadmap(mapname)
return
end
end
if player:checkstatetext("menu")=="fullscreenmenu" then
if player:checkstate("goback")==1 then
displaymenu()
return
end
if player:checkstatetext("itemselect")~="" then
fstr = player:checkstatetext("itemselect")
if fstr=="Fullscreen" then
manager:setsetting("fullscreenmode", "1")
end
if fstr=="Windowed" then
manager:setsetting("fullscreenmode", "0")
end
manager:changeres(luafunctions:tointstr(manager:getsetting("resx")), luafunctions:tointstr(manager:getsetting("resy")), luafunctions:tointstr(manager:getsetting("fullscreenmode")))
displaymenu()
return
end
end
if player:checkstatetext("menu")=="deletechar" then
if player:checkstate("goback")==1 then
charmenu()
return
end
if player:checkstatetext("itemselect")~="" then
manager:findplayer(player:checkstatetext("itemselect")):addstate("delete")
charmenu()
return
end
end
if player:checkstatetext("menu")=="fovmenu" then
if player:checkstate("goback")==1 then
videomenu()
return
end
if player:checkstatetext("itemselect")~="" then
manager:setsetting("fov", player:checkstatetext("itemselect"))
manager:setcamerafov(60)
videomenu()
return
end
end
if player:checkstatetext("menu")=="extrasmenu" then
if player:checkstate("goback")==1 then
mainmenu()
return
end
end
if player:checkstatetext("menu")=="graphicsmenu" then
if player:checkstate("goback")==1 then
videomenu()
return
end
if player:checkstatetext("itemselect")~="" then
manager:setsetting("graphicstype", player:checkstatetext("itemselect"))
videomenu()
return
end
end
if player:checkstatetext("menu")=="framemenu" then
if player:checkstate("goback")==1 then
videomenu()
return
end
if player:checkstatetext("itemselect")~="" then
fps = 0
if player:checkstatetext("itemselect")~="Uncapt" then
fps = luafunctions:tointstr(player:checkstatetext("itemselect"))
end
manager:setframerate(fps)
manager:setsetting("framerate", luafunctions:str(fps))
videomenu()
return
end
end
if player:checkstatetext("menu")=="resmenu" then
if player:checkstate("goback")==1 then
displaymenu()
return
end
if player:checkstatetext("itemselect")~="" then
restr = manager:splitstr(player:checkstatetext("itemselect"), "x")
manager:setsetting("resx", restr[0])
manager:setsetting("resy", restr[1])
manager:changeres(luafunctions:tointstr(manager:getsetting("resx")), luafunctions:tointstr(manager:getsetting("resy")), luafunctions:tointstr(manager:getsetting("fullscreenmode")))
displaymenu()
return
end
end
if player:checkstatetext("menu")=="displaymenu" then
if player:checkstate("goback")==1 then
videomenu()
return
end
if player:checkstatetext("itemselect")=="Vertical sync: on" then
manager:setsetting("vsync", "off")
manager:setvsync(0)
displaymenu()
return
end
if player:checkstatetext("itemselect")=="Vertical sync: off" then
manager:setsetting("vsync", "on")
manager:setvsync(1)
displaymenu()
return
end
if player:checkstatetext("itemselect")=="Fullscreen mode" then
fullscreenmenu()
return
end
if player:checkstatetext("itemselect")=="Resolution" then
resmenu()
return
end
end
if player:checkstatetext("menu")=="videomenu" then
if player:checkstate("goback")==1 then
settingsmenu()
return
end
if player:checkstatetext("itemselect")=="Resolution and display" then
displaymenu()
return
end
if player:checkstatetext("itemselect")=="Framerate" then
framemenu()
return
end
if player:checkstatetext("itemselect")=="Field of view" then
fovmenu()
return
end
if player:checkstatetext("itemselect")=="Graphics mode" then
graphicsmenu()
return
end
end
if player:checkstatetext("menu")=="accessibilitymenu" then
if player:checkstatetext("itemselect")=="TTS: on" then
manager:setsetting("tts", "off")
accessibilitymenu()
return
end
if player:checkstatetext("itemselect")=="TTS: off" then
manager:setsetting("tts", "on")
manager:addfunction("scripts/tts.lua", "update", "")
accessibilitymenu()
return
end
if player:checkstatetext("itemselect")=="Graphics: on" then
manager:setsetting("graphics", "off")
manager:changeskybox(null)
accessibilitymenu()
manager:hidegame()
checktimer2 = 0
return
end
if player:checkstatetext("itemselect")=="Graphics: off" then
manager:setsetting("graphics", "on")
manager:enablecamera()
manager:showgame()
manager:changeskybox(manager:loadmaterial("materials/spacemat/material.mat"))
accessibilitymenu()
return
end
if player:checkstate("goback")==1 then
settingsmenu()
return
end
end
if player:checkstatetext("menu")=="camtype" then
if player:checkstate("goback")==1 then
controlsmenu()
return
end
if player:checkstatetext("itemselect")~="" then
manager:removefunction(manager:findluafunction("scripts/camera/"..manager:getsetting("camcontrol")..".lua", "update", ""))
manager:setsetting("camcontrol", player:checkstatetext("itemselect"))
manager:addfunction("scripts/camera/"..manager:getsetting("camcontrol")..".lua", "update", "")
controlsmenu()
return
end
end
if player:checkstatetext("menu")=="controlsmenu" then
if player:checkstate("goback")==1 then
settingsmenu()
return
end
if player:checkstatetext("itemselect")=="Camera setup" then
camtype()
return
end
end
if player:checkstatetext("menu")=="hudmenu" then
if player:checkstatetext("itemselect")=="Display coordinates in hud: on" then
manager:setsetting("hudcoords", "off")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display coordinates in hud: off" then
manager:setsetting("hudcoords", "on")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display FPS counter in hud: on" then
manager:setsetting("hudfps", "off")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display FPS counter in hud: off" then
manager:setsetting("hudfps", "on")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display rank in hud: on" then
manager:setsetting("hudrank", "off")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display rank in hud: off" then
manager:setsetting("hudrank", "on")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display upgrade components in hud: off" then
manager:setsetting("hudcomponents", "on")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display upgrade components in hud: on" then
manager:setsetting("hudcomponents", "off")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display hud: on" then
manager:setsetting("hud", "off")
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Display hud: off" then
manager:setsetting("hud", "on")
hudmenu()
return
end
if player:checkstate("goback")==1 then
gamemenu()
return
end
end
if player:checkstatetext("menu")=="gamemenu" then
if player:checkstatetext("itemselect")=="Hud" then
hudmenu()
return
end
if player:checkstatetext("itemselect")=="Save game on exit: on" then
manager:setsetting("save on exit", "off")
gamemenu()
return
end
if player:checkstatetext("itemselect")=="Save game on exit: off" then
manager:setsetting("save on exit", "on")
gamemenu()
return
end

if player:checkstate("goback")==1 then
settingsmenu()
return
end
end
if player:checkstatetext("menu")=="settingsmenu" then
if player:checkstate("goback")==1 then
manager:savesettings()
mainmenu()
return
end
if player:checkstatetext("itemselect")=="Gameplay" then
gamemenu()
return
end
if player:checkstatetext("itemselect")=="Controls" then
controlsmenu()
return
end
if player:checkstatetext("itemselect")=="Content manager" then
contentmenu()
return
end
if player:checkstatetext("itemselect")=="Accessibility" then
accessibilitymenu()
return
end
if player:checkstatetext("itemselect")=="Video" then
videomenu()
return
end
end
if player:checkstatetext("menu")=="charmenu" then
if player:checkstate("goback")==1 then
modemenu()
return
end
if player:checkstatetext("itemselect")=="Delete character" then
deletechar()
return
end
if player:checkstatetext("itemselect")~="" then
manager:addstate("charname "..player:checkstatetext("itemselect"))
if manager:checkstatetext("mode")=="Universe" then
entergame()
else
gametypemenu()
end
return
end
end
if player:checkstatetext("menu")=="modemenu" then
if player:checkstatetext("itemselect")~="" then
manager:addstate("mode "..player:checkstatetext("itemselect"))
charmenu()
return
end
if player:checkstate("goback")==1 then
mainmenu()
return
end
end
if player:checkstatetext("menu")=="mainmenu" then
if player:checkstatetext("itemselect")=="Extras" then
extrasmenu()
return
end
if player:checkstatetext("itemselect")=="Settings" then
settingsmenu()
return
end
if player:checkstatetext("itemselect")=="Enter" then
modemenu()
return
end
if player:checkstatetext("itemselect")=="Save Game" then
manager:runscript("scripts/savegame.lua", "")
mainmenu()
end
if player:checkstatetext("itemselect")=="Quit" then
clearstate()
manager:removefunction(updatefunction)
player:removestate("itemselect Quit")
if manager:getsetting("save on exit")=="on" then
manager:runscript("scripts/savegame.lua", "")
end
manager:exit()
return
end
end
end
end
