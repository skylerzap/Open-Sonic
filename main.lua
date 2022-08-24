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
    sonic = love.graphics.newImage("somic.png")
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
    debug=false
    p.pushradius=0
    p.slopefactor=0
    p.multiplyer=1
    p.jumpforce=6.5*p.multiplyer
    p.accelerationspeed= 0.046875*p.multiplyer
    p.decelerationspeed= 0.5*p.multiplyer
    p.frictionspeed= 0.046875*p.multiplyer
    p.topspeed= 6*p.multiplyer
    p.sensoraxpos=0
    p.sensoraypos=0
    p.sensorbxpos=0
    p.sensorbypos=0
    p.slopefactor=0.125*p.multiplyer
    p.slopefactorup=0.78125*p.multiplyer
    p.slopefactordown=0.3125*p.multiplyer
    p.controllocktimer=0
    p.grounded=true
    p.gravityforce=0.21875
    p.airaccelerationspeed=0.09375
    p.mode=1
end


function sign(number)
    return number > 0 and 1 or (number == 0 and 0 or -1)
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
    if dt < 1/60 then
        love.timer.sleep(1/60 - dt)
     end
    local up    = love.keyboard.isScancodeDown('up')
	local down  = love.keyboard.isScancodeDown('down')
	local left  = love.keyboard.isScancodeDown('left')
	local right = love.keyboard.isScancodeDown('right')
    local b = love.keyboard.isScancodeDown('b')
    local n = love.keyboard.isScancodeDown('n')
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
        print("Test Thing: ".. math.floor((math.floor(p.y+p.heightradius)-math.floor(tile2)*16)-16)*-1)
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
            if not debug then
        --Control Lock Attempt
        if p.grounded then
            if p.controllocktimer==0 then
                if math.abs( p.groundangle ) < 2.5 and p.groundangle>45 and p.groundangle<316 then
                    p.grounded=false
                    p.groundspeed=0
                    p.controllocktimer=30
                end
            else
                p.controllocktimer=p.controllocktimer-1
            end
        end
        --Movement System
        if p.grounded then
                p.groundspeed = p.groundspeed - (p.slopefactor * math.sin(p.groundangle*0.0174533))

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
                    if p.groundangle==0 then
                    p.xspeed= p.groundspeed * math.cos(p.groundangle*0.0174533)
                    p.yspeed= p.groundspeed * -math.sin(p.groundangle*0.0174533)
                    else
                        p.xspeed = p.groundspeed * math.cos(p.groundangle*0.0174533)
                        p.yspeed = p.groundspeed * -math.sin(p.groundangle*0.0174533)
                    end
        
            if not left and not right then
                p.groundspeed = p.groundspeed-math.min(math.abs(p.groundspeed), p.frictionspeed) * sign(p.groundspeed)
            end
        else
            p.yspeed=p.yspeed+p.gravityforce
            if p.yspeed>16 then p.yspeed=16 end
            if p.yspeed<0 and p.yspeed>-4 then
                p.xspeed=p.xspeed-((p.xspeed/0.125)/256)
            end
        end

                --Attempt at implementation stuff
        p.x = p.x + p.xspeed
        p.y = p.y + p.yspeed
    if p.mode==1 then --Mode 1 is Floor Mode
    --SENSOR B
    local tile1, tile2 = testlevel:convertPixelToTile(p.x+p.widthradius, p.y+p.heightradius)
    local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
    local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
    local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+2))
    local tilexpos = math.floor(p.x+p.widthradius)-math.floor(tile1)*16
    local arraynumber = tostring(tilexpos)
    sensorblength=0
        if tileprops["solid"] then
            print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.y+p.heightradius)-math.floor(tile2+1)*16)))
            sensorblength=(tileprops[arraynumber]+math.floor(p.y+p.heightradius)-math.floor(tile2+1)*16)*-1-1
            sensorbgroundangle=tileprops["angle"]
        elseif tileprops[arraynumber] == 0 and tilepropsextension[arraynumber] >= 0 then
                print("B Extension")
                sensorblength=math.floor((math.floor(p.y+p.heightradius)-math.floor(tile2)*16)-16)*-1-1+16-tilepropsextension[arraynumber]
                sensorbgroundangle=tilepropsextension["angle"]
                print(sensorblength)
        elseif tileprops["full"] and tilepropsregression["solid"] == true and tilepropsregression[arraynumber]>=0 then
            print("Regression")
            print("Distance From Surface: ".. (math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]+math.floor(tile2)*16*-1))
            sensorblength=(math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]+math.floor(tile2)*16)*-1
            sensorbgroundangle=tilepropsregression["angle"]

        end
        --SENSOR A
        local tile1, tile2 = testlevel:convertPixelToTile(p.x-p.widthradius, p.y+p.heightradius)
        local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
        local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
        local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+2))
        local tilexpos = math.floor(p.x-p.widthradius)-math.floor(tile1)*16
        local arraynumber = tostring(tilexpos)
        sensoralength=0
            if tileprops["solid"] then
                print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.y+p.heightradius)-math.floor(tile2+1)*16)))
                sensoralength=(tileprops[arraynumber]+math.floor(p.y+p.heightradius)-math.floor(tile2+1)*16)*-1-1
                sensoragroundangle=tileprops["angle"]
            elseif tileprops[arraynumber] == 0 and tilepropsextension[arraynumber] >= 0 then
                    print("A Extension")
                    sensoralength=math.floor((math.floor(p.y+p.heightradius)-math.floor(tile2)*16)-16)*-1-1+16-tilepropsextension[arraynumber]
                    sensoragroundangle=tilepropsextension["angle"]
                    print(p.groundangle)
                    print(sensoralength)
            elseif tileprops["full"] and tilepropsregression["solid"] == true and tilepropsregression[arraynumber]>=0 then
                print("Regression")
                print("Distance From Surface: ".. (math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]+math.floor(tile2)*16*-1))
                sensoralength=(math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]+math.floor(tile2)*16)*-1
                sensoragroundangle=tilepropsregression["angle"]
            end

            if sensoralength<sensorblength then
                p.y=p.y+sensoralength
                p.groundangle=sensoragroundangle
                print(sensoragroundangle)
                print("A WON")
            elseif sensorblength<sensoralength then
                p.y=p.y+sensorblength
                p.groundangle=sensorbgroundangle
                print(sensorbgroundangle)
                print("B WON")
            elseif sensoralength==sensorblength then
                p.y=p.y+sensoralength
                p.groundangle=0
                print("BOTH WERE EQUAL")
            end
        elseif p.mode==2 then --Mode 2 is Right Wall
    --SENSOR B RIGHT WALL
    p.sensorbxpos=p.x+p.heightradius
    p.sensorbypos=p.y-p.widthradius
    local tile1, tile2 = testlevel:convertPixelToTile(p.x+p.widthradius, p.y+p.heightradius)
    local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
    local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
    local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+2))
    local tilexpos = math.floor(p.x+p.widthradius)-math.floor(tile1)*16
    local arraynumber = tostring(tilexpos)
    sensorblength=0
        if tileprops["solid"] then
            print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.y+p.heightradius)-math.floor(tile2+1)*16)))
            sensorblength=(tileprops[arraynumber]+math.floor(p.y+p.heightradius)-math.floor(tile2+1)*16)*-1-1
            sensorbgroundangle=tileprops["angle"]
        elseif tileprops[arraynumber] == 0 and tilepropsextension[arraynumber] >= 0 then
                print("B Extension")
                sensorblength=math.floor((math.floor(p.y+p.heightradius)-math.floor(tile2)*16)-16)*-1-1+16-tilepropsextension[arraynumber]
                sensorbgroundangle=tilepropsextension["angle"]
                print(sensorblength)
        elseif tileprops["full"] and tilepropsregression["solid"] == true and tilepropsregression[arraynumber]>=0 then
            print("Regression")
            print("Distance From Surface: ".. (math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]+math.floor(tile2)*16*-1))
            sensorblength=(math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]+math.floor(tile2)*16)*-1
            sensorbgroundangle=tilepropsregression["angle"]

        end
        --SENSOR A RIGHT WALL
        p.sensoraxpos=p.x+p.heightradius
        p.sensoraypos=p.y+p.widthradius
        local tile1, tile2 = testlevel:convertPixelToTile(p.x-p.widthradius, p.y+p.heightradius)
        local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
        local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
        local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+2))
        local tilexpos = math.floor(p.x-p.widthradius)-math.floor(tile1)*16
        local arraynumber = tostring(tilexpos)
        sensoralength=0
            if tileprops["solid"] then
                print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.y+p.heightradius)-math.floor(tile2+1)*16)))
                sensoralength=(tileprops[arraynumber]+math.floor(p.y+p.heightradius)-math.floor(tile2+1)*16)*-1-1
                sensoragroundangle=tileprops["angle"]
            elseif tileprops[arraynumber] == 0 and tilepropsextension[arraynumber] >= 0 then
                    print("A Extension")
                    sensoralength=math.floor((math.floor(p.y+p.heightradius)-math.floor(tile2)*16)-16)*-1-1+16-tilepropsextension[arraynumber]
                    sensoragroundangle=tilepropsextension["angle"]
                    print(p.groundangle)
                    print(sensoralength)
            elseif tileprops["full"] and tilepropsregression["solid"] == true and tilepropsregression[arraynumber]>=0 then
                print("Regression")
                print("Distance From Surface: ".. (math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]+math.floor(tile2)*16*-1))
                sensoralength=(math.floor(p.y+p.heightradius)+tilepropsregression[arraynumber]+math.floor(tile2)*16)*-1
                sensoragroundangle=tilepropsregression["angle"]
            end

            if sensoralength<sensorblength then
                p.y=p.y+sensoralength
                p.groundangle=sensoragroundangle
                print(sensoragroundangle)
                print("A WON")
            elseif sensorblength<sensoralength then
                p.y=p.y+sensorblength
                p.groundangle=sensorbgroundangle
                print(sensorbgroundangle)
                print("B WON")
            elseif sensoralength==sensorblength then
                p.y=p.y+sensoralength
                p.groundangle=0
                print("BOTH WERE EQUAL")
            end
        elseif mode=="ceiling" then

        elseif mode=="leftwall" then

        end

            else
                if right then p.x=p.x+0.5 end
                if left then p.x=p.x-1 end
                if down then p.y=p.y+0.5 end
                if up then p.y=p.y-1 end
            end
end

function love.draw()
    love.graphics.scale(2,2)
    love.graphics.draw(sonic, p.x-p.widthradius-7,p.y-p.heightradius)
    love.graphics.setColor(1, 1, 1)
    testlevel:draw(0,0,2,2)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line", p.sensoraxpos, p.sensoraypos , 0.5, 0.5 )
    love.graphics.rectangle("line", p.sensorbxpos, p.sensorbypos, 0.5, 0.5 )
    love.graphics.setColor(1, 1, 1)
    --love.graphics.rectangle("fill", math.floor(p.x+p.widthradius+p.heightradius/16)*8, math.floor(p.x-p.widthradius+p.heightradius+p.y/16)*8,8,8)
    local tile1, tile2 = testlevel:convertPixelToTile(p.x-p.widthradius, p.y+p.heightradius+16)
    --love.graphics.rectangle("fill", math.floor(tile1/1)*16, math.floor(tile2)*16, 16,16)
    local tile1, tile2 = testlevel:convertPixelToTile(p.x+p.widthradius, p.y+p.heightradius+16)
    --love.graphics.rectangle("fill", math.floor(tile1/1)*16, math.floor(tile2)*16, 16,16)
    --print(math.floor(p.x-p.widthradius/16))
    --print(p.x-p.widthradius/8)
end