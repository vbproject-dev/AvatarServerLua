--- handler/HandlerType.lua

local HandlerType = {}

local DefaultHandler = require("handler.DefaultHandler")
-- local LobbyHandler = require("handler.LobbyHandler")
-- local GameHandler  = require("handler.GameHandler")

local registry = {
    [0x00] = { name = "DEFAULT", create = DefaultHandler.new },
    -- [0x01] = { name = "LOBBY",   create = LobbyHandler.new  },
    -- [0x02] = { name = "GAME",    create = GameHandler.new   },
}

function HandlerType.fromCode(code)
    local entry = registry[code & 0xFF]
    if not entry then
        print("[HandlerType] Unknown code: " .. code .. ", fallback DEFAULT")
        return registry[0x00]
    end
    return entry
end

return HandlerType