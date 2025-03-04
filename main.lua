local Constants = require("src/Constants")
local FontController = require("src/FontController")
local Enums = require("src/types/Enums/EnumBuilder")
local Vector2 = require("src/types/Vector2")
local Textbox = require("src/Textbox")
local flux = require("src/flux")

local Globals = {
    FileString = "-- Love2D IDE",
    CurrentFont = love.graphics.getFont(),
    CurrentLine = 1,
}

local Textbox = Textbox.new(Vector2.new(10, 10), Vector2.new(love.graphics.getWidth() - 20, love.graphics.getHeight() - 20), Globals.FileString)

function love.load()
    love.window.setTitle("Love2D IDE - Made By @zart0_")
    local mainFont = love.graphics.newFont("JetBrainsMono.ttf", 12)
    love.graphics.setFont(mainFont)
    Globals.CurrentFont = love.graphics.getFont()
end

function love.update(dt)
    flux.update(dt)
end

function love.draw()
    local r, g, b = love.math.colorFromBytes(238, 193, 238)
    love.graphics.setBackgroundColor(r, g, b)
    Textbox:Draw()
end