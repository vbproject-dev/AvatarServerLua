local Config         = require("Config")
local MySQL          = require("lib.MysqlHelper")
local Message        = require("network.Message")
local Cmd            = require("network.Cmd")
local Utils          = require("utils.Utils")
local NetworkService = require("service.NetworkService")
local SessionManager = require("manager.SessionManager")
local DataLoader     = require("manager.DataLoader")
local DefaultHandler = require("handler.DefaultHandler")
local ParkHandler    = require("handler.ParkHandler")
local Bootstrap      = {}
Bootstrap.__index    = Bootstrap

function Bootstrap.new()
    return setmetatable({}, Bootstrap)
end

local function handlePacket(session, cmd, data)
    Utils.try {
        main = function()
            local message = Message.fromData(cmd, data)

            if cmd == Cmd.GET_HANDLER then
                local code = message:readByte()
                NetworkService.sendHandler(session, code)
                session:setHandler(code)
                -- print(string.format("[DefaultHandler] SWITCH HANDLER code=%s", tostring(session:getHandler())))
            else
                if session:getHandler() == 9 then
                    ParkHandler.onMessage(session, message)
                else
                    DefaultHandler.onMessage(session, message)
                end
            end
        end,
        catch = function(err)
            print(string.format("[DefaultHandler] error on cmd %s: %s", tostring(cmd), tostring(err)))
        end,
    }
end


local function setupSession(session)
    SessionManager.register(session)

    session:onReceive(function(cmd, data)
        handlePacket(session, cmd, data)
    end)

    session:onClose(function()
        SessionManager.unregister(session)
    end)

    session:start()
end

local function connectDatabase(dbCfg)
    local db, err = MySQL.connect(dbCfg.host, dbCfg.user, dbCfg.password, dbCfg.name, dbCfg.port)
    if not db then
        print("MySQL unavailable: " .. tostring(err))
        return nil
    end
    return db
end

function Bootstrap:start()
    local cfg = Config.load("config.json")

    local db = connectDatabase(cfg.database)
    if not db then
        return
    end

    DataLoader.loadDatabase()

    local MapManager = require("manager.MapManager")
    for mapId = 1, 25 do
        MapManager.createMap(mapId, "NONE")
    end

    local server = Server.new()
    server:onConnect(setupSession)
    server:listen(cfg.server.port)

    print("Server started on port " .. cfg.server.port)

    server:start() -- blocks: runs the accept loop
end

return Bootstrap
