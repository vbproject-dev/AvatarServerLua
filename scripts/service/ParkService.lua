local Cmd = require("network.Cmd")
local Message = require("network.Message")

local ParkService = {}


function ParkService.sendAvatarJoinParkResponse(session)
    local player = session:getPlayer();

    local m = Message.new(Cmd.AVATAR_JOIN_PARK);
    m:writeByte(player.map:getId());
    m:writeByte(player.channel.id);
    m:writeShort(-1);
    m:writeShort(-1);

    print(string.format(
        "mapId %d channel %d",
        player.map:getId(),
        player.channel.id
    ))
end

return ParkService
