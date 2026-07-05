local ResourceType = {}
ResourceType.__index = ResourceType -- <-- add this

local sep = package.config:sub(1, 1) == "\\" and "\\" or "/"

local definitions = {
    BIG         = { root = "res", folder = "big" },
    BIG_FARM    = { root = "res", folder = "big_farm" },
    EFFECT      = { root = "res", folder = "effect" },
    FARM        = { root = "res", folder = "farm" },
    HOUSE       = { root = "res", folder = "house" },
    TILEMAP     = { root = "res", folder = "tilemap" },

    PART_OBJECT = { root = "part", folder = "object" },
    PART_ITEM   = { root = "part", folder = "item" },
}

for name, def in pairs(definitions) do
    ResourceType[name] = setmetatable(
        { name = name, root = def.root, folder = def.folder },
        ResourceType -- <-- and set it here, on each instance
    )
end

function ResourceType.buildDirPath(self, quality)
    if self.root == "res" then
        return table.concat({ "assets", self.root, quality, self.folder }, sep)
    elseif self.root == "part" then
        return table.concat({ base or "assets", self.root, self.folder, quality }, sep)
    else
        error("Unknown root: " .. tostring(self.root))
    end
end

function ResourceType.buildFilePath(self, quality, id)
    local dir = ResourceType.buildDirPath(self, quality)
    return dir .. sep .. id .. ".png"
end

return ResourceType
