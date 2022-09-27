-- ░█████╗░██████╗░███████╗███╗░░██╗  ░██████╗░█████╗░███╗░░██╗██╗░█████╗░
-- ██╔══██╗██╔══██╗██╔════╝████╗░██║  ██╔════╝██╔══██╗████╗░██║██║██╔══██╗
-- ██║░░██║██████╔╝█████╗░░██╔██╗██║  ╚█████╗░██║░░██║██╔██╗██║██║██║░░╚═╝
-- ██║░░██║██╔═══╝░██╔══╝░░██║╚████║  ░╚═══██╗██║░░██║██║╚████║██║██║░░██╗
-- ╚█████╔╝██║░░░░░███████╗██║░╚███║  ██████╔╝╚█████╔╝██║░╚███║██║╚█████╔╝
-- ░╚════╝░╚═╝░░░░░╚══════╝╚═╝░░╚══╝  ╚═════╝░░╚════╝░╚═╝░░╚══╝╚═╝░╚════╝░
-- Made by Evanzap

function love.load()
    local sti = require "lib/sti"
    local sensorlib = require "lib/sensor"
    local testlevel = sti("maps/testlevel.lua")
    player = require "objects.player"
end

function love.update(dt)
    if dt < 1 / 30 then
        love.timer.sleep(1 / 30 - dt)
    end
    player.update()
end

function love.draw()
    player.draw()
end
