-- ░█████╗░██████╗░███████╗███╗░░██╗  ░██████╗░█████╗░███╗░░██╗██╗░█████╗░
-- ██╔══██╗██╔══██╗██╔════╝████╗░██║  ██╔════╝██╔══██╗████╗░██║██║██╔══██╗
-- ██║░░██║██████╔╝█████╗░░██╔██╗██║  ╚█████╗░██║░░██║██╔██╗██║██║██║░░╚═╝
-- ██║░░██║██╔═══╝░██╔══╝░░██║╚████║  ░╚═══██╗██║░░██║██║╚████║██║██║░░██╗
-- ╚█████╔╝██║░░░░░███████╗██║░╚███║  ██████╔╝╚█████╔╝██║░╚███║██║╚█████╔╝
-- ░╚════╝░╚═╝░░░░░╚══════╝╚═╝░░╚══╝  ╚═════╝░░╚════╝░╚═╝░░╚══╝╚═╝░╚════╝░
-- If you're looking for the code, look in the objects folder.
-- Made by Evanzap
function love.load()
    local sti = require "lib/sti"
    local sensorlib = require "lib/sensor"
    local testlevel = sti("maps/testlevel.lua")
    local p = require "objects.player"
end

function love.update(dt)
    if dt < 1 / 30 then
        love.timer.sleep(1 / 30 - dt)
    end
    p.update()
end

function love.draw()
    p.draw()
end
