graphics = manager:getsetting("graphics")
if graphics=="off" then
manager:disablecamera()
else
manager:enablecamera()
end
manager:setspeech(manager:getsetting("module"), manager:getsetting("voice"), manager:getsetting("rate"), manager:getsetting("pitch"), manager:getsetting("volume"))
manager:setcamerarange(luafunctions:tointstr(manager:getsetting("drawdist")))
if manager:getsetting("vsync")=="on" then
manager:setvsync(1)
else
manager:setvsync(0)
end
manager:setcamerafov(luafunctions:tointstr(manager:getsetting("fov")))
manager:setframerate(luafunctions:tointstr(manager:getsetting("framerate")))
manager:setquality(luafunctions:tointstr(manager:getsetting("quality")), true)
manager:changeres(luafunctions:tointstr(manager:getsetting("resx")), luafunctions:tointstr(manager:getsetting("resy")), luafunctions:tointstr(manager:getsetting("fullscreenmode")))
