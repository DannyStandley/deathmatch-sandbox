if manager:findmap(mapname)==null then
manager:removefunction(updatefunction)
return
end
checkstuff = manager:addinputaction()
checkstuff:AddBinding("<Keyboard>/X")
checkstuff:Enable()
updatetime = 0.23
updatetime2 = 0
hudmat = manager:addmaterial("Unlit/Texture")
manager:settexture(hudmat, "_MainTex", manager:loadtexture("scripts/blank.png"))
cube = mapfunctions:createobject()
huddisplay = mapfunctions:spawnobject(player.orgx +manager:round(manager:sin(player.theta *manager:getpi() /180)), player.orgy +manager:round(manager:cos(player.theta *manager:getpi() /180)), player.orgz, player.ztheta, player.theta, 0, cube, 0, mapname, hudmat)
mapfunctions:changescale(huddisplay, 1, 2, 1)
mapfunctions:destroyobj(cube)
mapfunctions:attachtext(huddisplay, "", 0.019)
misc = mapfunctions:getmisc(huddisplay)
misc:addstate("dontclear")
function update() do
foundmap = manager:findmap(mapname)
if player:checkstate("switchplayer")==1 or foundmap==null or foundmap.loaded==0 then
mapfunctions:destroyobj(huddisplay)
manager:removefunction(updatefunction)
return
end
if player.location~=mapname then
newmap = manager:findmap(player.location)
foundmap.mapobjects:Remove(huddisplay)
newmap.mapobjects:Add(huddisplay)
mapname = player.location
foundmap = newmap
misc.mapname = mapname
misc.foundmap = foundmap
end
destorgx = manager:round(manager:sin(player.theta *manager:getpi() /180))
destorgy = manager:round(manager:cos(player.theta *manager:getpi() /180))
destorgz = 0
misc.orgx = player.orgx +destorgx
misc.orgy = player.orgy +destorgy
misc.orgz = player.orgz +destorgz
misc.orientx = player.ztheta
misc.orienty = player.theta
updatetime2 = updatetime2 +manager:getdeltatime()
if updatetime2>updatetime then
updatetime2 = 0
hudtext = ""
if manager:getsetting("hud")=="on" then
if manager:getsetting("hudcoords")=="on" then
hudtext = hudtext.."Coordinates: "..luafunctions:str(player.orgx)..", "..luafunctions:str(player.orgy)..", "..luafunctions:str(player.orgz)..". "
end
if manager:getsetting("hudrank")=="on" then
hudtext = hudtext.."Rank: "..manager:checkstatetext("rank")..". "
end
if manager:getsetting("hudcomponents")=="on" then
hudtext = hudtext.."Upgrade components: "..manager:checkstatetext("upgradecomponents")..". "
end
if manager:getsetting("hudfps")=="on" then
hudtext = hudtext.."Fps: "..luafunctions:str(manager:getfps())..". "
end
end
mapfunctions:changetext(huddisplay, hudtext, 0.015)
end
end
end
