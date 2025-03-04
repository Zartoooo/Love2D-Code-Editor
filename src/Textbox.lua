local Vector2 = require("src/types/Vector2")
local Keyboard = require("src/Keyboard")
local Enums = require("src/types/enums/EnumBuilder").Enums
local flux = require("src/flux")

local module = {}
module.__index = module

function module.new(Pos, Size, StartText)
    local obj = {
        Lines = {StartText or ""},
        CurrentLine = 1,
        Config = {
            Pos = Pos or Vector2.new(0, 0),
            Size = Size or Vector2.new(100, 100),
        },
        CaretPos = 0,
        CaretTransparency = 1,
    }

    setmetatable(obj, module)

    Keyboard:KeyPressed(function(key, keytype)
        if keytype == Enums.KeyType.Key or keytype == Enums.KeyType.Return then
            obj:Write(key)
        elseif keytype == Enums.KeyType.Backspace then
            obj:Backspace()
        end
    end)

    obj.CaretPos = love.graphics.getFont():getWidth(obj.Lines[obj.CurrentLine])

    local anim; anim = function()
        if obj.CaretTransparency == 0 then
            flux.to(obj, 0.3, { CaretTransparency = 1 }):oncomplete(anim)
        elseif obj.CaretTransparency == 1 then
            flux.to(obj, 0.3, { CaretTransparency = 0 }):oncomplete(anim)
        end
    end


    anim()

    return obj
end

function module:Draw()
    love.graphics.setScissor(self.Config.Pos.X, self.Config.Pos.Y, self.Config.Size.X, self.Config.Size.Y)
    for i, v in ipairs(self.Lines) do
        love.graphics.print(v, self.Config.Pos.X, self.Config.Pos.Y + (i - 1) * love.graphics.getFont():getHeight())
    end
    love.graphics.setScissor()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(255, 255, 255, self.CaretTransparency)
    love.graphics.rectangle("fill", self.Config.Pos.X + self.CaretPos, self.Config.Pos.Y + (self.CurrentLine - 1) * love.graphics.getFont():getHeight(), 3, love.graphics.getFont():getHeight())

    love.graphics.setColor(r,g,b,a)
end

function module:Write(text)
    for i = 1, #text do
        local v = text:sub(i, i)
        if v == "\n" then
            self.CurrentLine = self.CurrentLine + 1
            table.insert(self.Lines, "")
        else
            local line = self.Lines[self.CurrentLine]
            local pos = self.CaretPos
            self.Lines[self.CurrentLine] = line:sub(1, pos) .. v .. line:sub(pos + 1)
            self.CaretPos = self.CaretPos + 1
        end
    end
    self.CaretPos = love.graphics.getFont():getWidth(self.Lines[self.CurrentLine])
end

function module:Backspace()
    if self.Lines[self.CurrentLine] and #self.Lines[self.CurrentLine] > 0 then
        self.Lines[self.CurrentLine] = string.sub(self.Lines[self.CurrentLine], 1, -2)
    elseif self.CurrentLine > 1 then
        self.CurrentLine = self.CurrentLine - 1
        self.Lines[self.CurrentLine] = self.Lines[self.CurrentLine] .. table.remove(self.Lines)
    end

    self.CaretPos = love.graphics.getFont():getWidth(self.Lines[self.CurrentLine])
end

return module