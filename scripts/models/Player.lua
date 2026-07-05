local Item = require("models.Item")
local Player = {}
Player.__index = Player

function Player.new(data)
    local self = setmetatable(data or {}, Player)

    for i, item in ipairs(self.wearing) do
        self.wearing[i] = Item.new(item)
    end
    self.session = nil
    self.map = nil
    self.channel = nil
    return self
end

function Player:getId()
    return self.id
end

function Player:getAccountId()
    return self.accountId
end

function Player:getName()
    return self.name
end

function Player:getGender()
    return self.gender
end

function Player:getLevel()
    return self.level
end

function Player:getExperience()
    return self.experience
end

function Player:getStar()
    return self.star
end

function Player:getMoney()
    return self.money
end

function Player:getGold()
    return self.gold
end

function Player:getLockedGold()
    return self.locked_gold
end

function Player:getFriendly()
    return self.friendly
end

function Player:getCrazy()
    return self.crazy
end

function Player:getStylish()
    return self.stylish
end

function Player:getHappy()
    return self.happy
end

function Player:getHunger()
    return self.hunger
end

function Player:getWearing()
    return self.wearing
end

function Player:getCommands()
    return self.cmd
end

function Player:getFriends()
    return self.friends
end

function Player:getSession()
    return self.session
end

function Player:isOnline()
    return self.online
end

function Player:getMap()
    return self.map
end

--------------------------------------------------------------------
-- Setter
--------------------------------------------------------------------

function Player:setId(id)
    self.id = id
end

function Player:setAccountId(accountId)
    self.accountId = accountId
end

function Player:setName(name)
    self.name = name
end

function Player:setGender(gender)
    self.gender = gender
end

function Player:setLevel(level)
    self.level = level
end

function Player:setExperience(experience)
    self.experience = experience
end

function Player:setStar(star)
    self.star = star
end

function Player:setMoney(money)
    self.money = money
end

function Player:setGold(gold)
    self.gold = gold
end

function Player:setLockedGold(lockedGold)
    self.locked_gold = lockedGold
end

function Player:setFriendly(friendly)
    self.friendly = friendly
end

function Player:setCrazy(crazy)
    self.crazy = crazy
end

function Player:setStylish(stylish)
    self.stylish = stylish
end

function Player:setHappy(happy)
    self.happy = happy
end

function Player:setHunger(hunger)
    self.hunger = hunger
end

function Player:setWearing(wearing)
    self.wearing = wearing
end

function Player:setCommands(cmd)
    self.cmd = cmd
end

function Player:setFriends(friends)
    self.friends = friends
end

function Player:setSession(session)
    self.session = session
end

function Player:setOnline(online)
    self.online = online
end

function Player:bindSession(session)
    self.session = session
    self.online  = true
end

function Player:unbindSession()
    self.session = nil
    self.online  = false
end

function Player:setMap(map)
    self.map = map
end

function Player:send(msg)
    if self.session then
        self.session:send(msg.command, msg:getData(), msg:size())
    end
end

return Player
