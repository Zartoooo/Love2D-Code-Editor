local module = {}

module.Enums = {}

function module.newEnum(name, values)
    module.Enums[name] = {} 
    for i, v in ipairs(values) do
        module.Enums[name][v] = i
    end

    setmetatable(module.Enums[name], {
        __newindex = function(_, key, value)
            error("Cannot add new values to an enum")
        end
    })
end

module.newEnum("KeyType", require("src/types/Enums/KeyType"))

return module