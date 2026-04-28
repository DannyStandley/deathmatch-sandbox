if player:checkstate("landing")==0 then
if player.orgy<11 then
player.orgy = 11 +0.001 *550
end
player:removestate("fallspeed "..player:checkstatetext("fallspeed"))
player:removestate("landz "..player:checkstatetext("landz"))
player:removestate("jumping")
player:addstate("fallspeed 570")
player:addstate("landz -10")
player:addstate("landing")
player:addstate("swimming")
end
