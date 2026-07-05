local ResData = {}
ResData.__index = ResData

function ResData.new()
    return setmetatable({
        id = nil,
        size = nil,
        data = nil,
        path = nil,
    }, ResData)
end

function ResData:getId()
    return self.id
end

function ResData:getSize()
    return self.size
end

function ResData:getData()
    return self.data
end

function ResData:getPath()
    return self.path
end

return ResData
