local module = {}

local Enums = require("src/types/Enums/EnumBuilder").Enums

module.ControlKeys = {
    "escape", "return", "backspace", "tab", "space", "up", "down", "left", "right",
    "home", "end", "pageup", "pagedown", "insert", "delete", "f1", "f2", "f3", "f4",
    "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12", "lshift", "rshift", "lctrl",
    "rctrl", "lalt", "ralt", "lgui", "rgui", "capslock", "numlock", "scrolllock", "space",
    "tab"
}

module.KeyTable = {
    ["space"] = " ",
    ["tab"] = "    ",
    ["return"] = "\n"
}

module.KeyPressedConns = {}

function module:DetermineKeyType(key)
    local _type = Enums.KeyType.Key

    if key == "return" then
        key = "\n"
        _type = Enums.KeyType.Return
    elseif key == "space" then
        _type = Enums.KeyType.Key
    elseif key == "tab" then
        _type = Enums.KeyType.Key
    elseif key == "backspace" then
        _type = Enums.KeyType.Backspace
    elseif key == "lshift" or key == "rshift" then
        _type = Enums.KeyType.Shift
    elseif key == "lctrl" or key == "rctrl" then
        _type = Enums.KeyType.Ctrl
    elseif key == "capslock" then
        _type = Enums.KeyType.CapsLock
    elseif key == "lalt" then
        _type = Enums.KeyType.LAlt
    elseif key == "ralt" then
        _type = Enums.KeyType.RAlt
    end

    return _type
end

function module:KeyPressed(f) -- f(key: string)
    table.insert(self.KeyPressedConns, f)
end

function love.keypressed(key, scancode, isrepeat)
    local found = false
    for i,v in ipairs(module.ControlKeys) do
        if v == key then
            found = true
        end
    end
    if not found then return end

    local Keytype = module:DetermineKeyType(key)

    if module.KeyTable[key] then
        key = module.KeyTable[key]
    end

    for _,v in ipairs(module.KeyPressedConns) do
        v(key, Keytype)
    end
end

function love.textinput(t)
    if t == " " then
        return
    end

    for _,v in ipairs(module.KeyPressedConns) do
        v(t, Enums.KeyType.Key)
    end
end

return module