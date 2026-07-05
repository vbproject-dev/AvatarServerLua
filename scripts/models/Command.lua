-- Command.lua


local Command = {}
Command.__index = Command

function Command.new(data)
    local self = setmetatable(data or {}, Command)
    return self
end

function Command:getIcon()
    return self.icon
end

function Command:setIcon(icon)
    self.icon = icon
end

function Command:getName()
    return self.name
end

function Command:setName(name)
    self.name = name
end

function Command:getAnthor()
    return self.anthor
end

function Command:setAnthor(anthor)
    self.anthor = anthor
end

function Command:getType()
    return self.type
end

function Command:setType(type)
    self.type = type
end

function Command:getCommandType()
    return self.cmdType
end

function Command:setCommandType(cmdType)
    self.cmdType = cmdType
end

return Command
