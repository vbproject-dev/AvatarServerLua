local Channel = require("world.Channel")

local Map = {}
Map.__index = Map

function Map.new(id, name, channelCount)
    local self = setmetatable({}, Map)

    self.id = id
    self.name = name
    self.channels = {}

    channelCount = channelCount or 5

    for i = 1, channelCount do
        self.channels[i] = Channel.new(i)
    end

    return self
end

function Map:getAvailableChannel()
    for _, channel in ipairs(self.channels) do
        if not channel:isFull() then
            return channel
        end
    end

    return nil
end

function Map:enter(player)
    local channel = self:getAvailableChannel()

    if not channel then
        return false, "All channels are full."
    end

    channel:addPlayer(player)

    player.map = self
    player.channel = channel

    return true
end

function Map:leave(player)
    if player.channel then
        player.channel:removePlayer(player)
    end

    player.map = nil
    player.channel = nil
end

function Map:getId()
    return self.id
end

function Map:getName()
    return self.name
end

function Map:getChannel(id)
    return self.channels[id]
end

function Map:getChannels()
    return self.channels
end

return Map
