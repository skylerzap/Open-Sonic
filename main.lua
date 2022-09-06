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
    p.groundangle=4
    --standing radius
    p.widthradius=9
    p.heightradius=19
    --jumping radius
    --width radius = 9
    --height radius = 14
    debug=false
    p.pushradius=10
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
    p.sensorexpos=0
    p.sensoreypos=0
    p.sensorfxpos=0
    p.sensorfypos=0
    p.slopefactor=0.125*p.multiplyer
    p.slopefactorup=0.78125*p.multiplyer
    p.slopefactordown=0.3125*p.multiplyer
    p.controllocktimer=0
    p.grounded=true
    p.gravityforce=0.21875
    p.airaccelerationspeed=0.09375
    p.mode=1
    p.mostdirection="none"
    --p.physicsengine=
end

function sensor(sensorx,sensory,direction)
    if direction=="down" then
        local tile1, tile2 = testlevel:convertPixelToTile(sensorx, sensory)
        local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
        local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
        local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+2))
        local tilexpos = math.floor(sensorx)-math.floor(tile1)*16
        local arraynumber = tostring(tilexpos)
        local sensorlength=0
        local sensorgroundangle=0
            if tileprops["solid"] then
--                print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((sensory)-math.floor(tile2+1)*16)))
                sensorlength=(tileprops[arraynumber]+math.floor(sensory)-math.floor(tile2+1)*16)*-1-1
                sensorgroundangle=tileprops["angle"]
            elseif tileprops[arraynumber] == 0 and tilepropsextension[arraynumber] >= 0 then
--                    print("B Extension")
                    sensorlength=math.floor((math.floor(sensory)-math.floor(tile2)*16)-16)*-1-1+16-tilepropsextension[arraynumber]
                    sensorgroundangle=tilepropsextension["angle"]
--                    print(sensorgroundangle)
            elseif tileprops["full"] and tilepropsregression["solid"] == true and tilepropsregression[arraynumber]>=0 then
--                print("Regression")
--                print("Distance From Surface: ".. (math.floor(sensory)+tilepropsregression[arraynumber]+math.floor(tile2)*16*-1))
                sensorlength=(math.floor(sensory)+tilepropsregression[arraynumber]+math.floor(tile2)*16)*-1
                sensorgroundangle=tilepropsregression["angle"]
            end
            return sensorlength, sensorgroundangle
        elseif direction=="right" then
            local tile1, tile2 = testlevel:convertPixelToTile(sensorx, sensory)
            local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2+1))
            local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1), math.floor(tile2+1))
            local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1+2), math.floor(tile2+1))
            local tilexpos = -(math.floor(sensory)-math.floor(tile2)*16-16)-1
            print(tilexpos)
            local arraynumber = "w"..tostring(tilexpos)
            local sensorlength=0
            if tileprops[arraynumber]>0 and tileprops[arraynumber]<16  then
        --        print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.x+p.heightradius)-math.floor(tile1)*16)))
--                print("Normal B")
                sensorlength=(-sensorx+math.floor(tile1)*16-tileprops[arraynumber])+16
                sensorgroundangle=tileprops["angle"]
--                print("B ground angle: ".. sensorbgroundangle)
            elseif tileprops[arraynumber] == 0 and tilepropsextension["solid"] then
--                    print("B Extension")
                sensorlength=((sensorx-math.floor(tile1)*16))*-1-1-tilepropsextension[arraynumber]+32
                sensorgroundangle=tilepropsextension["angle"]
--                    print("B Length (Extension): ".. sensorblength)
--                    print("B ground angle: ".. sensorbgroundangle)
            elseif tileprops[arraynumber] == 16 and tilepropsregression[arraynumber]>0 then
--                print("Regression")
--                print("Distance From Surface: ".. (math.floor(sensory)+tilepropsregression[arraynumber]+math.floor(tile1)*16*-1))
                sensorlength=(sensorx-math.floor(tile1)*16+tilepropsregression[arraynumber])
                sensorgroundangle=tilepropsregression["angle"]
            end
            return sensorlength, sensorgroundangle
        end
end

function sensorwallfork(sensorx,sensory,direction)
        if direction=="right" then
            local tile1, tile2 = testlevel:convertPixelToTile(sensorx-15, sensory)
            local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
            local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1), math.floor(tile2))
            local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1+2), math.floor(tile2))
            local tilexpos = -(math.floor(sensory)-math.floor(tile2)*16-16)-1
            print(tilexpos)
            local arraynumber = "w"..tostring(tilexpos)
            local sensorlength=0
            if tileprops[arraynumber]>0 and tileprops[arraynumber]<16  then
        --        print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.x+p.heightradius)-math.floor(tile1)*16)))
--                print("Normal B")
                sensorlength=(-sensorx+math.floor(tile1)*16-tileprops[arraynumber])+16
                sensorgroundangle=tileprops["angle"]
--                print("B ground angle: ".. sensorbgroundangle)
            elseif tileprops[arraynumber] == 0 and tilepropsextension["solid"] then
--                    print("B Extension")
                sensorlength=((sensorx-math.floor(tile1)*16))*-1-1-tilepropsextension[arraynumber]+32
                sensorgroundangle=tilepropsextension["angle"]
--                    print("B Length (Extension): ".. sensorblength)
--                    print("B ground angle: ".. sensorbgroundangle)
            elseif tileprops[arraynumber] == 16 and tilepropsregression[arraynumber]>0 then
--                print("Regression")
--                print("Distance From Surface: ".. (math.floor(sensory)+tilepropsregression[arraynumber]+math.floor(tile1)*16*-1))
                sensorlength=(sensorx-math.floor(tile1)*16+tilepropsregression[arraynumber])
                sensorgroundangle=tilepropsregression["angle"]
            end
            return sensorlength, sensorgroundangle
        elseif direction=="left" then
            sensorx=sensorx+15
            local tile1, tile2 = testlevel:convertPixelToTile(sensorx, sensory)
            local tileprops = testlevel:getTileProperties(1,  math.floor(tile1+1), math.floor(tile2))
            local tilepropsregression = testlevel:getTileProperties(1,  math.floor(tile1+2), math.floor(tile2))
            local tilepropsextension = testlevel:getTileProperties(1,  math.floor(tile1), math.floor(tile2))
            local tilexpos = -(math.floor(sensory)-math.floor(tile2)*16-16)-1
            print(tilexpos)
            local arraynumber = "w"..tostring(tilexpos)
            local sensorlength=0
            if tileprops[arraynumber]>0 and tileprops[arraynumber]<16  then
                --        print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.x+p.heightradius)-math.floor(tile1)*16)))
        --                print("Normal B")
                        sensorlength=(-sensorx+math.floor(tile1)*16+tileprops[arraynumber])+16
                        sensorgroundangle=tileprops["angle"]
        --                print("B ground angle: ".. sensorbgroundangle)
                    elseif tileprops[arraynumber] == 0 and tilepropsextension["solid"] then
        --                    print("B Extension")
                        sensorlength=((sensorx-math.floor(tile1)*16))*-1-1-tilepropsextension[arraynumber]+32
                        sensorgroundangle=tilepropsextension["angle"]
        --                    print("B Length (Extension): ".. sensorblength)
        --                    print("B ground angle: ".. sensorbgroundangle)
                    elseif tileprops[arraynumber] == 16 and tilepropsregression[arraynumber]>0 then
        --                print("Regression")
        --                print("Distance From Surface: ".. (math.floor(sensory)+tilepropsregression[arraynumber]+math.floor(tile1)*16*-1))
                        sensorlength=(sensorx-math.floor(tile1)*16+tilepropsregression[arraynumber])
                        sensorgroundangle=tilepropsregression["angle"]
                    end
                    return sensorlength, sensorgroundangle
                end
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
    if dt < 1/30 then
        love.timer.sleep(1/30 - dt)
     end
    local up    = love.keyboard.isScancodeDown('up')
	local down  = love.keyboard.isScancodeDown('down')
	local left  = love.keyboard.isScancodeDown('left')
	local right = love.keyboard.isScancodeDown('right')
    local a = love.keyboard.isScancodeDown('a')
    local s = love.keyboard.isScancodeDown('s')
     if not debug then
        --Control Lock Attempt
        if p.grounded then
            if p.controllocktimer==0 then
                if math.abs( p.groundspeed ) < 2.5 and p.groundangle>45 and p.groundangle<316 then
                    --p.grounded=false
                    p.groundspeed=0
                    --p.groundangle=0
                    p.controllocktimer=30
                end
            else
                p.controllocktimer=p.controllocktimer-1
            end
        end
        --Movement System
        if p.mode==1 and p.groundangle>45 then
            p.mode=2
        elseif p.mode==2 and p.groundangle<46 then
            p.mode=1
        end
        if p.grounded then
                p.groundspeed = p.groundspeed - (p.slopefactor * math.sin(p.groundangle*0.0174533))
                if p.controllocktimer>0 then
                    left=false
                    right=false
                end
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
                    --JUMP TEST
        if a or s then
            p.xspeed = p.xspeed - p.jumpforce * math.sin(p.groundangle*0.0174533)
            p.yspeed = p.yspeed - p.jumpforce * math.cos(p.groundangle*0.0174533)
            p.grounded=false
        end
        else
            if p.yspeed>16 then p.yspeed=16 end
            if p.yspeed<0 and p.yspeed>-4 then
                p.xspeed=p.xspeed-((p.xspeed/0.125)/256)
            end
            p.yspeed=p.yspeed+p.gravityforce
        end
                --Attempt at implementation stuff
                if math.abs(p.xspeed) >= math.abs(p.yspeed) then
                    if p.xspeed>0 then
                        p.mostdirection="right"
                    elseif p.xspeed<0 then
                        p.mostdirection="left"
                    else
                        p.mostdirection="none"
                    end
                else
                    if p.yspeed>0 then
                        p.mostdirection="down"
                    elseif p.yspeed<0 then
                        p.mostdirection="up"
                    else
                        p.mostdirection="none"
                    end
                end
                
    --SENSORS E + F        
    if p.grounded then
        if p.xspeed>0 and p.mode==1 then
            p.sensorfxpos= p.x + p.pushradius + p.xspeed
            p.sensorfypos= p.y + p.yspeed
            if p.groundangle==0 then
                p.sensorfypos=p.y+p.yspeed+8
            end
            sensorflength, sensorfangle = sensorwallfork(p.sensorfxpos,p.sensorfypos,"right")
            if sensorflength<0 then
                p.xspeed=p.xspeed+sensorflength
                p.groundspeed=0
            end
        elseif p.xspeed<0 and p.mode==1 then
            p.sensorexpos= p.x - p.pushradius + p.xspeed
            p.sensoreypos= p.y + p.yspeed
            if p.groundangle==0 then
                p.sensoreypos=p.y+p.yspeed+8
            end
            sensorelength, sensoreangle = sensorwallfork(p.sensorexpos,p.sensoreypos,"left")
            if sensorelength>0 then
                p.xspeed=p.xspeed+sensorelength
                p.groundspeed=0
            end
        end
    else
        if p.mostdirection=="right" or p.mostdirection=="up" or p.mostdirection=="down" then
            p.sensorfxpos= p.x + p.pushradius + p.xspeed
            p.sensorfypos= p.y + p.yspeed
            if p.groundangle==0 then
                p.sensorfypos=p.y+p.yspeed+8
            end
            sensorflength, sensorfangle = sensorwallfork(p.sensorfxpos,p.sensorfypos,"right")
            if sensorflength<0 then
                p.xspeed=p.xspeed+sensorflength
                p.groundspeed=0
            end
        elseif p.mostdirection=="left" or p.mostdirection=="up" or p.mostdirection=="down"then
            p.sensorexpos= p.x - p.pushradius + p.xspeed
            p.sensoreypos= p.y + p.yspeed
            if p.groundangle==0 then
                p.sensoreypos=p.y+p.yspeed+8
            end
            sensorelength, sensoreangle = sensorwallfork(p.sensorexpos,p.sensoreypos,"left")
            if sensorelength>0 then
                p.xspeed=p.xspeed+sensorelength
                p.groundspeed=0
            end
        end
    end
    --MOVE PLAYER
        p.x = p.x + p.xspeed
        p.y = p.y + p.yspeed
    print(p.yspeed)
    print(p.mostdirection)
    if p.mode==1 then
        p.sensoraxpos=p.x-p.widthradius
        p.sensoraypos=p.y+p.heightradius
        p.sensorbxpos=p.x+p.widthradius
        p.sensorbypos=p.y+p.heightradius
    elseif p.mode==2 then
        p.sensorbxpos=p.x+p.heightradius
        p.sensorbypos=p.y+p.widthradius
        p.sensoraxpos=p.x+p.heightradius
        p.sensoraypos=p.y-p.widthradius
    else
        p.sensoraxpos=p.x-p.widthradius
        p.sensoraypos=p.y+p.heightradius
        p.sensorbxpos=p.x+p.widthradius
        p.sensorbypos=p.y+p.heightradius
    end
    --SENSORS A + B
    if p.grounded then
    if p.mode==1 then --Mode 1 is Floor Mode
    --SENSOR B
        sensorblength, sensorbgroundangle = sensor(p.sensorbxpos,p.sensorbypos,"down")
        --SENSOR A
       sensoralength, sensoragroundangle = sensor(p.sensoraxpos, p.sensoraypos, "down")

            if sensoralength<sensorblength then
                p.y=p.y+sensoralength
                if sensoragroundangle==366 then
                    p.groundangle=math.floor(p.groundangle/90+0.5)*90
                else
                    p.groundangle=sensoragroundangle
                end
                print(sensoragroundangle)
                print("A WON")
            elseif sensorblength<sensoralength then
                p.y=p.y+sensorblength
                if sensorbgroundangle==366 then
                    p.groundangle=math.floor(p.groundangle/90+0.5)*90
                else
                    p.groundangle=sensorbgroundangle
                end
                print(sensorbgroundangle)
                print("B WON")
            elseif sensoralength==sensorblength then
                p.y=p.y+sensoralength
                if sensoragroundangle==366 then
                    p.groundangle=math.floor(p.groundangle/90+0.5)*90
                else
                    p.groundangle=sensoragroundangle
                end
                print("BOTH WERE EQUAL")
            end
        elseif p.mode==2 then --Mode 2 is Right Wall
    --SENSOR B RIGHT WALL
    sensorblength, sensorbgroundangle = sensor(p.x+p.heightradius,p.y+p.widthradius, "right")
        --SENSOR A RIGHT WALL
        sensoralength, sensoragroundangle = sensor(p.x+p.heightradius,p.y-p.widthradius, "right")

            if sensoralength<sensorblength then
                p.x=p.x+sensoralength
                if sensoragroundangle==366 then
                    p.groundangle=math.floor(p.groundangle/90+0.5)*90
                else
                    p.groundangle=sensoragroundangle
                end
                print(sensoragroundangle)
                print("A WON")
            elseif sensorblength<sensoralength then
                p.x=p.x+sensorblength
                if sensorbgroundangle==366 then
                    p.groundangle=math.floor(p.groundangle/90+0.5)*90
                else
                    p.groundangle=sensorbgroundangle
                end
                print(sensorbgroundangle)
                print("B WON")
            elseif sensoralength==sensorblength then
                p.x=p.x+sensoralength
                if sensoragroundangle==366 then
                    p.groundangle=math.floor(p.groundangle/90+0.5)*90
                else
                    p.groundangle=sensoragroundangle
                end
                print(p.groundangle)
                print("BOTH WERE EQUAL")
            end
        elseif mode=="ceiling" then

        elseif mode=="leftwall" then

        end
    end

    if p.grounded==false and p.mostdirection=="right" or p.mostdirection=="left" or p.mostdirection=="down" then
        if p.mode==1 then --Mode 1 is Floor Mode
        --SENSOR B
            sensorblength, sensorbgroundangle = sensor(p.sensorbxpos,p.sensorbypos,"down")
            --SENSOR A
           sensoralength, sensoragroundangle = sensor(p.sensoraxpos, p.sensoraypos, "down")
            if sensoralength>=-(p.yspeed+8) or sensorblength>=-(p.yspeed+8) then
                if sensoralength<sensorblength then
                    if sensoralength<=0 then
                        p.y=p.y+sensoralength
                        p.grounded=true
                    end
                    if sensoragroundangle==366 then
                        p.groundangle=math.floor(p.groundangle/90+0.5)*90
                    else
                        p.groundangle=sensoragroundangle
                    end
                    print(sensoragroundangle)
                    print("A WON")
                elseif sensorblength<sensoralength then
                    if sensorblength<=0 then
                        p.y=p.y+sensorblength
                        p.grounded=true
                    end
                    if sensorbgroundangle==366 then
                        p.groundangle=math.floor(p.groundangle/90+0.5)*90
                    else
                        p.groundangle=sensorbgroundangle
                    end
                    print(sensorbgroundangle)
                    print("B WON")
                elseif sensoralength==sensorblength then
                    if sensoralength<=0 then
                        p.y=p.y+sensoralength
                        p.grounded=true
                    end
                    if sensoragroundangle==366 then
                        p.groundangle=math.floor(p.groundangle/90+0.5)*90
                    else
                        p.groundangle=sensoragroundangle
                    end
                    print("BOTH WERE EQUAL")
                end
            end
            elseif p.mode==2 then --Mode 2 is Right Wall
        --SENSOR B RIGHT WALL
        sensorblength, sensorbgroundangle = sensor(p.x+p.heightradius,p.y+p.widthradius, "right")
            --SENSOR A RIGHT WALL
            sensoralength, sensoragroundangle = sensor(p.x+p.heightradius,p.y-p.widthradius, "right")
            if sensoralength>=-(p.yspeed+8) or sensorblength>=-(p.yspeed+8) then
                if sensoralength<sensorblength then
                    if sensoralength<=0 then
                    p.x=p.x+sensoralength
                    p.grounded=true
                    end
                    if sensoragroundangle==366 then
                        p.groundangle=math.floor(p.groundangle/90+0.5)*90
                    else
                        p.groundangle=sensoragroundangle
                    end
                    print(sensoragroundangle)
                    print("A WON")
                elseif sensorblength<sensoralength then
                    if sensorblength<=0 then
                    p.x=p.x+sensorblength
                    p.grounded=true
                    end
                    if sensorbgroundangle==366 then
                        p.groundangle=math.floor(p.groundangle/90+0.5)*90
                    else
                        p.groundangle=sensorbgroundangle
                    end
                    print(sensorbgroundangle)
                    print("B WON")
                elseif sensoralength==sensorblength then
                    if sensoralength<=0 then
                    p.x=p.x+sensoralength
                    p.grounded=true
                    end
                    if sensoragroundangle==366 then
                        p.groundangle=math.floor(p.groundangle/90+0.5)*90
                    else
                        p.groundangle=sensoragroundangle
                    end
                    print(p.groundangle)
                    print("BOTH WERE EQUAL")
                end
            end

            else
                if right then p.x=p.x+0.5 end
                if left then p.x=p.x-1 end
                if down then p.y=p.y+0.5 end
                if up then p.y=p.y-1 end
            end
        end
end
end
function love.draw()
    love.graphics.scale(2,2)
    love.graphics.draw(sonic, p.x-p.widthradius-7-8*16,p.y-p.heightradius)
    love.graphics.setColor(1, 1, 1)
    testlevel:draw(-8*16,0,2,2)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line", p.sensoraxpos-8*16, p.sensoraypos , 0.5, 0.5 )
    love.graphics.rectangle("line", p.sensorbxpos-8*16, p.sensorbypos, 0.5, 0.5 )
    love.graphics.rectangle("line", p.sensorfxpos-8*16, p.sensorfypos, 0.5, 0.5 )
    love.graphics.setColor(1, 1, 1)
    --love.graphics.rectangle("fill", math.floor(p.x+p.widthradius+p.heightradius/16)*8, math.floor(p.x-p.widthradius+p.heightradius+p.y/16)*8,8,8)
    --print(math.floor(p.x-p.widthradius/16))
    --print(p.x-p.widthradius/8)
end