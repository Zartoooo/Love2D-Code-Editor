local Constants = require("src/Constants")

local module = {}


function module:CreateFont(name, filepath)
    local font = love.graphics.newFont("assets/fonts/" .. filepath, Constants.FontSize)
    return font
end

return module