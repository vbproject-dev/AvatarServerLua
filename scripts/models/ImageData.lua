local ImageData = {}
ImageData.__index = ImageData

function ImageData.new(data)
    local self = setmetatable(data or {}, ImageData)
    return self
end

-- Getters

function ImageData:getId()
    return self.id
end

function ImageData:getItemId()
    return self.item_id
end

function ImageData:getImageId()
    return self.image_id
end

function ImageData:getX()
    return self.x
end

function ImageData:getY()
    return self.y
end

function ImageData:getW()
    return self.w
end

function ImageData:getH()
    return self.h
end

return ImageData
