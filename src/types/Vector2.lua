local Vector2 = {}

local function _add(a, b)
    return Vector2.new(a.X + b.X, a.Y + b.Y)
end

local function _sub(a, b)
    return Vector2.new(a.X - b.X, a.Y - b.Y)
end

local function _mul(a, b)
    return Vector2.new(a.X * b.X, a.Y * b.Y)
end

local function _div(a, b)
    return Vector2.new(a.X / b.X, a.Y / b.Y)
end

function Vector2.new(x, y)
    local obj = {
        X = x or 0,
        Y = y or 0
    }

    setmetatable(obj, {
        __index = Vector2,
        __add = _add,
        __sub = _sub,
        __mul = _mul,
        __div = _div,
    })
    return obj
end

function Vector2:unpack()
    return self.X, self.Y
end

return Vector2