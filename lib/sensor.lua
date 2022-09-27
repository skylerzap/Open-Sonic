--Made for Open Sonic by Evanzap
--Created to mimic the sensor system from the Sonic Genesis games.
--LICENSE: GNU/GPL v3

sti = require "lib/sti"
testlevel = sti("maps/testlevel.lua")
sensorlib= {}

function sensorlib.sensor(sensorx, sensory, direction)
    if direction == "down" then
        local tile1, tile2 = testlevel:convertPixelToTile(math.floor(sensorx), math.floor(sensory))
        local tileprops = testlevel:getTileProperties(1, math.floor(tile1 + 1), math.floor(tile2 + 1))
        local tilepropsregression = testlevel:getTileProperties(1, math.floor(tile1 + 1), math.floor(tile2))
        local tilepropsextension = testlevel:getTileProperties(1, math.floor(tile1 + 1), math.floor(tile2 + 2))
        local tilexpos = math.floor(sensorx) - math.floor(tile1) * 16
        local arraynumber = tostring(tilexpos)
        local sensorlength = 0
        local sensorgroundangle = 0
        if tileprops["solid"] then
            sensorlength = (tileprops[arraynumber] + math.floor(sensory) - math.floor(tile2 + 1) * 16) * -1 - 1
            sensorgroundangle = tileprops["angle"]
        elseif tileprops[arraynumber] == 0 and tilepropsextension["solid"] then
            sensorlength = math.floor((math.floor(sensory) - math.floor(tile2) * 16) - 16) * -1 - 1 + 16 -
                               tilepropsextension[arraynumber]
            sensorgroundangle = tilepropsextension["angle"]
        elseif tileprops["full"] and tilepropsregression["solid"] then
            sensorlength = (math.floor(sensory) + tilepropsregression[arraynumber] + math.floor(tile2) * 16) * -1
            sensorgroundangle = tilepropsregression["angle"]
        else
            sensorlength = 32
        end
        return sensorlength, sensorgroundangle
    elseif direction == "right" then
        local tile1, tile2 = testlevel:convertPixelToTile(math.floor(sensorx), math.floor(sensory))
        local tileprops = testlevel:getTileProperties(1, math.floor(tile1 + 1), math.floor(tile2 + 1))
        local tilepropsregression = testlevel:getTileProperties(1, math.floor(tile1 - 0), math.floor(tile2 + 1))
        local tilepropsextension = testlevel:getTileProperties(1, math.floor(tile1 + 2), math.floor(tile2 + 1))
        local tilexpos = -(math.floor(sensory) - math.floor(tile2) * 16 - 16) - 1
        print(tilexpos)
        local arraynumber = "w" .. tostring(tilexpos)
        local sensorlength = 0
        if tileprops["solid"] and not tileprops["full"] then
            sensorlength = (-math.floor(sensorx) + math.floor(tile1) * 16 - tileprops[arraynumber]) + 15
            sensorgroundangle = tileprops["angle"]
        elseif tileprops[arraynumber] == 0 and tilepropsextension["solid"] then
            --                    print("B Extension")
            sensorlength = ((math.floor(sensorx) - math.floor(tile1) * 16)) * -1 - 1 - tilepropsextension[arraynumber] +
                               32
            sensorgroundangle = tilepropsextension["angle"]
            print("extension")
        elseif tileprops[arraynumber] == 16 and tilepropsregression["solid"] then
            print("Regression")
            --                print("Distance From Surface: ".. (math.floor(sensory)+tilepropsregression[arraynumber]+math.floor(tile1)*16*-1))
            sensorlength = (math.floor(sensorx) - math.floor(tile1) * 16 + tilepropsregression[arraynumber]) - 32 + 16
            sensorgroundangle = tilepropsregression["angle"]
        else
            sensorlength = 32
        end
        if sensorgroundangle == nil then
            sensorgroundangle = 0
        end
        return sensorlength, sensorgroundangle
    elseif direction == "up" then
        local tile1, tile2 = testlevel:convertPixelToTile(math.floor(sensorx), math.floor(sensory))
        local tileprops = testlevel:getTileProperties(1, math.floor(tile1 + 1), math.floor(tile2 + 1))
        local tilepropsregression = testlevel:getTileProperties(1, math.floor(tile1 + 1), math.floor(tile2))
        local tilepropsextension = testlevel:getTileProperties(1, math.floor(tile1), math.floor(tile2 + 2))
        local tilexpos = math.floor(sensorx) - math.floor(tile1) * 16
        local arraynumber = tostring(tilexpos)
        local sensorlength = 0
        local sensorgroundangle = 0
        if tileprops["solid"] then
            sensorlength = (tileprops[arraynumber] - math.floor(sensory) + math.floor(tile2 + 1) * 16) * -1 +16
            sensorgroundangle = tileprops["angle"]
        elseif tileprops[arraynumber] == 0 and tilepropsextension["solid"] then
            sensorlength = math.floor((math.floor(sensory) - math.floor(tile2) * 16) - 16) * -1 - 1 + 16 -
                               tilepropsextension[arraynumber]
            sensorgroundangle = tilepropsextension["angle"]
        elseif tileprops["full"] and tilepropsregression["solid"] then
            sensorlength = (math.floor(sensory) + tilepropsregression[arraynumber] + math.floor(tile2) * 16) * -1
            sensorgroundangle = tilepropsregression["angle"]
        else
            sensorlength = 32
        end
        return sensorlength, sensorgroundangle
    end
end

function sensorlib.sensorwallfork(sensorx, sensory, direction)
    if direction == "right" then
        sensorx = sensorx + 15
        local tile1, tile2 = testlevel:convertPixelToTile(sensorx - 15, sensory)
        local tileprops = testlevel:getTileProperties(1, math.floor(tile1), math.floor(tile2))
        local tilepropsregression = testlevel:getTileProperties(1, math.floor(tile1 - 1), math.floor(tile2))
        local tilepropsextension = testlevel:getTileProperties(1, math.floor(tile1 + 1), math.floor(tile2))
        local tilexpos = -(math.floor(sensory) - math.floor(tile2) * 16 - 16) - 1
        print(tilexpos)
        local arraynumber = "w" .. tostring(tilexpos)
        local sensorlength = 0
        if not tileprops[arraynumber] == 0 and not tileprops[arraynumber] == 16 then
            --        print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.x+p.heightradius)-math.floor(tile1)*16)))
            --                print("Normal B")
            sensorlength = (-sensorx + math.floor(tile1) * 16 - tileprops[arraynumber]) + 16
            sensorgroundangle = tileprops["angle"]
            --                print("B ground angle: ".. sensorbgroundangle)
        elseif tileprops[arraynumber] == 0 then
            --                    print("B Extension")
            sensorlength = ((sensorx - math.floor(tile1) * 16)) * -1 - 1 - tilepropsextension[arraynumber] + 32
            sensorgroundangle = tilepropsextension["angle"]
            --                    print("B Length (Extension): ".. sensorblength)
            --                    print("B ground angle: ".. sensorbgroundangle)
        elseif tileprops[arraynumber] == 16 then
            print("Regression")
            --                print("Distance From Surface: ".. (math.floor(sensory)+tilepropsregression[arraynumber]+math.floor(tile1)*16*-1))
            sensorlength = (sensorx - math.floor(tile1) * 16 + tilepropsregression[arraynumber]) - 15
            sensorgroundangle = tilepropsregression["angle"]
        end
        return sensorlength, sensorgroundangle
    elseif direction == "left" then
        sensorx = sensorx + 15
        local tile1, tile2 = testlevel:convertPixelToTile(sensorx, sensory)
        local tileprops = testlevel:getTileProperties(1, math.floor(tile1 + 1), math.floor(tile2))
        local tilepropsregression = testlevel:getTileProperties(1, math.floor(tile1 + 2), math.floor(tile2))
        local tilepropsextension = testlevel:getTileProperties(1, math.floor(tile1), math.floor(tile2))
        local tilexpos = -(math.floor(sensory) - math.floor(tile2) * 16 - 16) - 1
        print(tilexpos)
        local arraynumber = "w" .. tostring(tilexpos)
        local sensorlength = 0
        if tileprops[arraynumber] > 0 and tileprops[arraynumber] < 16 then
            --        print("Distance From Surface: ".. (tileprops[arraynumber]+math.floor((p.x+p.heightradius)-math.floor(tile1)*16)))
            --                print("Normal B")
            sensorlength = (-sensorx + math.floor(tile1) * 16 + tileprops[arraynumber]) + 16
            sensorgroundangle = tileprops["angle"]
            --                print("B ground angle: ".. sensorbgroundangle)
        elseif tileprops[arraynumber] == 0 and tilepropsextension["solid"] then
            --                    print("B Extension")
            sensorlength = ((sensorx - math.floor(tile1) * 16)) * -1 - 1 - tilepropsextension[arraynumber] + 32
            sensorgroundangle = tilepropsextension["angle"]
            --                    print("B Length (Extension): ".. sensorblength)
            --                    print("B ground angle: ".. sensorbgroundangle)
        elseif tileprops[arraynumber] == 16 and tilepropsregression[arraynumber] > 0 then
            --                print("Regression")
            --                print("Distance From Surface: ".. (math.floor(sensory)+tilepropsregression[arraynumber]+math.floor(tile1)*16*-1))
            sensorlength = (sensorx - math.floor(tile1) * 16 + tilepropsregression[arraynumber])
            sensorgroundangle = tilepropsregression["angle"]
        end
        return sensorlength, sensorgroundangle
    end
end

return sensorlib
