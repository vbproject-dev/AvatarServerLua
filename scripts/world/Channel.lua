local Channel = {}
Channel.__index = Channel

function Channel.new(id)
    return setmetatable({
        id = id,
        players = {},
        npcs = {},
        maxPlayers = 10,
        playerCount = 0,
    }, Channel)
end

function Channel:isFull()
    return self.playerCount >= self.maxPlayers
end

function Channel:addPlayer(player)
    if self:isFull() then
        return false
    end

    self.players[player:getId()] = player
    self.playerCount = self.playerCount + 1

    return true
end

function Channel:removePlayer(player)
    if self.players[player:getId()] then
        self.players[player:getId()] = nil
        self.playerCount = self.playerCount - 1
    end
end

function Channel:addNpc(npc)
    self.npcs[npc:getId()] = npc
end

function Channel:removeNpc(npc)
    self.npcs[npc:getId()] = nil
end

return Channel
