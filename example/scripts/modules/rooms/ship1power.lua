foundmap = manager:findmap(mapname)
light1 = mapfunctions:getobj(5, 5, 5, "plane", manager:findmap(mapname))
light2 = mapfunctions:getobj(0, 2, 5, "plane", manager:findmap(mapname))
light3 = mapfunctions:getobj(0, 8, 5, "plane", manager:findmap(mapname))
if manager:checkstate("powered "..mapname)==0 then
mapfunctions:disablelight(light1)
mapfunctions:disablelight(light2)
mapfunctions:disablelight(light3)
else
mapfunctions:enablelight(light1)
mapfunctions:enablelight(light2)
mapfunctions:enablelight(light3)
end
