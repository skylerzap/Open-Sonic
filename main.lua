--░░░░░██╗░█████╗░███████╗  ███████╗███╗░░██╗░██████╗░██╗███╗░░██╗███████╗
--░░░░░██║██╔══██╗██╔════╝  ██╔════╝████╗░██║██╔════╝░██║████╗░██║██╔════╝
--░░░░░██║██║░░██║█████╗░░  █████╗░░██╔██╗██║██║░░██╗░██║██╔██╗██║█████╗░░
--██╗░░██║██║░░██║██╔══╝░░  ██╔══╝░░██║╚████║██║░░╚██╗██║██║╚████║██╔══╝░░
--╚█████╔╝╚█████╔╝███████╗  ███████╗██║░╚███║╚██████╔╝██║██║░╚███║███████╗
--░╚════╝░░╚════╝░╚══════╝  ╚══════╝╚═╝░░╚══╝░╚═════╝░╚═╝╚═╝░░╚══╝╚══════╝
--Prototype Release 1
--Made by Evanzap

function love.load()
    local sti = require "sti"
    testlevel = sti("maps/testlevel.lua")
    love.graphics.setDefaultFilter( 'nearest', 'nearest' )
    
    p = {}
    p.x=10*12+0.5
    p.y=12*16+0.5-4
    p.xspeed=0
    p.yspeed=0
    p.groundspeed=0
    p.groundangle=0
    --standing radius
    p.widthradius=9
    p.heightradius=19
    --jumping radius
    --width radius = 9
    --height radius = 14
    debug=true
    p.pushradius=0
    p.slopefactor=0
    p.multiplyer=1
    p.jumpforce=6.5*p.multiplyer
    p.accelerationspeed= 0.046875*p.multiplyer
    p.decelerationspeed= 0.5*p.multiplyer
    p.frictionspeed= 0.046875*p.multiplyer
    p.topspeed= 6*p.multiplyer
    p.sensoraxpos=0
    p.sensorbxpos=0
    p.yspeed=0
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function love.update(dt)
    if dt < 1/30 then
        love.timer.sleep(1/30 - dt)
     end
    local up    = love.keyboard.isScancodeDown('up')
	local down  = love.keyboard.isScancodeDown('down')
	local left  = love.keyboard.isScancodeDown('left')
	local right = love.keyboard.isScancodeDown('right')
    local b = love.keyboard.isScancodeDown('b')
    local n = love.keyboard.isScancodeDown('n')
    if not debug then
    if left then
        if p.groundspeed>0 then --if moving to the right
            p.groundspeed = p.groundspeed-p.decelerationspeed  --decelerate
            if p.groundspeed <= 0 then
                p.groundspeed = -0.5  --emulate deceleration quirk
            end
        elseif p.groundspeed > -p.topspeed then --if moving to the left
            p.groundspeed =  p.groundspeed- p.accelerationspeed  --accelerate
            if p.groundspeed <= -p.topspeed then
                p.groundspeed = -p.topspeed --impose top speed limit
            end
        end
    end

    if right then
        if p.groundspeed<0 then --if moving to the left
            p.groundspeed = p.groundspeed+p.decelerationspeed  --decelerate
            if p.groundspeed >= 0 then
                p.groundspeed = 0.5  --emulate deceleration quirk
            end
        elseif p.groundspeed < p.topspeed then --if moving to the right
            p.groundspeed =  p.groundspeed+ p.accelerationspeed  --accelerate
            if p.groundspeed >= p.topspeed then
                p.groundspeed = p.topspeed --impose top speed limit
            end
        end
    end
    else
        if right then p.x=p.x+0.5 end
        if left then p.x=p.x-1 end
        if down then p.y=p.y+0.5 end
        if up then p.y=p.y-1 end
    end
    --Sensor Information Hotkeys
    if b then
        local tile1, tile2 = testlevel:convertPixelToTile(p.x-p.widthradius, p.y+p.heightradius)
        local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
        local tilexpos = math.floor(p.x-p.widthradius)-math.floor(tile1)*16
        local arraynumber = tostring(tilexpos)
        print("Sensor A Info.")
        print("X Position within tile: ".. math.floor(p.x-p.widthradius)-math.floor(tile1)*16)
        print("Y Position within tile: ".. math.floor(p.y+p.heightradius)-math.floor(tile2)*16)
        if tileprops[arraynumber] == nil then
            print("Tile Height: nil")
        else
        print("Tile Height: ".. tileprops[arraynumber])
        end
        print("X (in tiles): ".. math.floor(tile1))
        print("Y (in tiles): ".. math.floor(tile2))
    end
    if n then
        local tile1, tile2 = testlevel:convertPixelToTile(p.x+p.widthradius, p.y+p.heightradius)
        local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
        local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
        local tilexpos = math.floor(p.x+p.widthradius)-math.floor(tile1)*16
        local arraynumber = tostring(tilexpos)
        print("Sensor B Info.")
        print("X Position within tile: ".. math.floor(p.x+p.widthradius)-math.floor(tile1)*16)
        print("Y Position within tile: ".. math.floor(p.y+p.heightradius)-math.floor(tile2)*16)
        print("Test Thing: ".. math.floor((p.y+p.heightradius)-math.floor(tile2)*16))
        if tileprops[arraynumber] == nil then
            print("Tile Height: nil")
            print("Distance From Surface: nil")
        else
        print("Tile Height: ".. tileprops[arraynumber])
        if tileprops["full"]==true and tilepropsregression["solid"] == true then
            print("Distance From Surface: ".. (math.floor((p.y+p.heightradius)+tilepropsregression[arraynumber]-math.floor(tile2)*16)))
        else
            print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.y+p.heightradius)-math.floor(tile2+1)*16)))
        end
        end
        print("X (in tiles): ".. math.floor(tile1))
        print("Y (in tiles): ".. math.floor(tile2))
    end
    --Attempt at implementation stuff
    debug=false
    local tile1, tile2 = testlevel:convertPixelToTile(p.x+p.widthradius, p.y+p.heightradius)
    local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
    local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
    local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2-1))
    local tilexpos = math.floor(p.x+p.widthradius)-math.floor(tile1)*16
    local arraynumber = tostring(tilexpos)
    p.yspeed=0
    if tileprops["full"] and tilepropsregression["solid"] == true and tilepropsregression[arraynumber]>=0 then
            print("Distance From Surface: ".. (math.floor((p.y+p.heightradius)+tilepropsregression[arraynumber]-math.floor(tile2)*16)))
            p.yspeed=math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]-math.floor(tile2)*16*-1
        elseif tileprops["solid"] ==false  and tilepropsextension[arraynumber]>0 then
            p.yspeed=(tileprops[arraynumber]+math.floor(p.y+p.heightradius)-math.floor(tile2+2)*16)
        elseif tileprops["solid"] then
        print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.y+p.heightradius)-math.floor(tile2+1)*16)))
        p.yspeed=(tileprops[arraynumber]+math.floor(p.y+p.heightradius)-math.floor(tile2+1)*16)*-1-1
    end
    p.x=p.x+p.groundspeed
    p.y=p.y+p.yspeed
end

function love.draw()
    love.graphics.scale(2,2)
    love.graphics.setColor(1, 1, 1)
    testlevel:draw(0,0,2,2)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line", p.x-p.widthradius, p.y+p.heightradius , 1, 1 )
    love.graphics.rectangle("line", p.x+p.widthradius, p.y+p.heightradius, 1, 1 )
    love.graphics.setColor(1, 1, 1)
    --love.graphics.rectangle("fill", math.floor(p.x+p.widthradius+p.heightradius/16)*8, math.floor(p.x-p.widthradius+p.heightradius+p.y/16)*8,8,8)
    local tile1, tile2 = testlevel:convertPixelToTile(p.x-p.widthradius, p.y+p.heightradius+16)
    --love.graphics.rectangle("fill", math.floor(tile1/1)*16, math.floor(tile2)*16, 16,16)
    local tile1, tile2 = testlevel:convertPixelToTile(p.x+p.widthradius, p.y+p.heightradius+16)
    --love.graphics.rectangle("fill", math.floor(tile1/1)*16, math.floor(tile2)*16, 16,16)
    --print(math.floor(p.x-p.widthradius/16))
    --print(p.x-p.widthradius/8)

end