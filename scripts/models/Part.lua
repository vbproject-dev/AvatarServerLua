------------------------------------------------------------------

local Part = {}
Part.__index = Part

function Part.new(data)
    local self = setmetatable(data or {}, Part)
    return self
end

-- Getters

function Part:getId()
    return self.id
end

function Part:getName()
    return self.name
end

function Part:getCoin()
    return self.coin
end

function Part:getGold()
    return self.gold
end

function Part:getType()
    return self.type
end

function Part:getIcon()
    return self.icon
end

function Part:getSell()
    return self.sell
end

function Part:getExpiredDay()
    return self.expired_day
end

function Part:getZorder()
    return self.zorder
end

function Part:getLevel()
    return self.level
end

function Part:getGender()
    return self.gender
end

function Part:getAnimations()
    return self.animations
end

return Part
