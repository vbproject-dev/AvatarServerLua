--- lib/Config.lua

local JSON = require("lib.JSON")

local Config = {}

local _data = nil

function Config.load(path)
    path = path or "config.json"
    local f, err = io.open(path, "r")
    assert(f, "[Config] Cannot open config file: " .. tostring(err))
    local raw = f:read("*a")
    f:close()
    _data = JSON:decode(raw)
    assert(_data, "[Config] Failed to parse config.json")
    print("[Config] Loaded from: " .. path)
    return _data
end

function Config.get()
    assert(_data, "[Config] Config not loaded yet, call Config.load() first")
    return _data
end

return Config
