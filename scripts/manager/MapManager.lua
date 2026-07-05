local Map = require("world.Map")

local MapManager = {}

MapManager.maps = {}

function MapManager.createMap(id, name)
    local map = Map.new(id, name)
    MapManager.maps[id] = map
    return map
end

function MapManager.enterMap(player, mapId)
    local map = MapManager.getMap(mapId)
    if not map then
        return false, "Map not found."
    end

    return map:enter(player)
end

function MapManager.changeMap(player, mapId)
    if player.map then
        player.map:leave(player)
    end

    return MapManager.enterMap(player, mapId)
end

function MapManager.getMap(id)
    return MapManager.maps[id]
end

function MapManager.getMaps()
    return MapManager.maps
end

function MapManager.clear()
    MapManager.maps = {}
end

return MapManager
