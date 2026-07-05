local NetworkService = require("service.NetworkService")
local ParkService = require("service.ParkService")
local MapManager = require("manager.MapManager")

local Cmd = require("network.Cmd")
local ParkHandler = {}

local function onAvatarJoinPark(session, m)
    local mapId = m:readByte();
    local area = m:readByte();
    local x = m:readShort();
    local y = m:readShort();

    MapManager.enterMap(session:getPlayer(), mapId)
    ParkService.sendAvatarJoinParkResponse(session)
end

local handlers = {
    [Cmd.AVATAR_JOIN_PARK] = onAvatarJoinPark,
}

function ParkHandler.onMessage(session, msg)
    if session:getPlayer() == nil then
        NetworkService.sendMessageBox(session, "Please reopen your client")
        if (session:isConnected()) then
            session:close()
        end

        return
    end

    local handler = handlers[msg.command]
    if not handler then
        print("[ParkHandler] cmd: " .. msg.command .. ", from: " .. session:getIpAddress())
        return
    end

    handler(session, msg)
end

return ParkHandler
