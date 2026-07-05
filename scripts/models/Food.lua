-- Food.lua

local Food = {}
Food.__index = Food

function Food.new(data)
    local self = setmetatable(data or {}, Food)
    return self
end

-- Getters

function Food:getId()
    return self.id
end

function Food:getName()
    return self.name
end

function Food:getDescription()
    return self.description
end

function Food:getPrice()
    return self.price
end

function Food:getHealthPercent()
    return self.health_percent
end

function Food:getIcon()
    return self.icon
end

function Food:getShop()
    return self.shop
end

return Food
