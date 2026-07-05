-- Item.lua

local DataManager = require("manager.DataManager")

local Item = {}
Item.__index = Item

function Item.new(data)
    local self = setmetatable(data or {}, Item)
    return self
end

function Item:getId()
    return self.id
end

function Item:setId(id)
    self.id = id
    self.part = nil
end

function Item:getExpired()
    return self.expired
end

function Item:setExpired(expired)
    self.expired = expired
end

function Item:getQuantity()
    return self.quantity
end

function Item:setQuantity(quantity)
    self.quantity = quantity
end

function Item:getPart()
    if not self.part then
        self.part = DataManager.getPart(self.id)
    end
    return self.part
end

function Item:setPart(part)
    self.part = part
end

function Item:expiredString()
    if self.expired == -1 then
        return ""
    end

    return "Expired: " .. os.date("%d-%m-%Y", math.floor(self.expired / 1000))
end

return Item
