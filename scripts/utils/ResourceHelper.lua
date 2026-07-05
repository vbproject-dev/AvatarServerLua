local LoadingCache = require("utils.LoadingCache")
local ResData = require("models.ResData")
local ResourceQuality = require("utils.ResourceQuality")

local ResourceHelper = {}


local function makeKey(quality, resType, id)
    return quality .. "|" .. resType.name .. "|" .. id
end

local function fileExists(path)
    local f = io.open(path, "rb")
    if f then
        f:close()
        return true
    end
    return false
end

local function readAllBytes(path)
    local file, err = io.open(path, "rb")
    if not file then
        return nil, err
    end

    local data = file:read("*a")
    if not data then
        file:close()
        return nil, "Failed to read file: " .. path
    end

    file:close()
    return data, nil
end

local function loadFromDisk(rawKey, quality, resType, id)
    local ok, path = pcall(function()
        return resType:buildFilePath(quality, id)
    end)
    if not ok then
        print("[RESOURCE] Path build failed: " .. tostring(path))
        return nil
    end

    if not fileExists(path) then
        print("[RESOURCE] Missing: " .. path)
        return nil
    end

    local data = readAllBytes(path)
    if not data then
        print("[RESOURCE] Load failed: " .. path)
        return nil
    end

    local res = ResData.new()
    res.id = id
    res.size = #data
    res.data = data
    res.path = path

    --  print("[RESOURCE] Loaded: " .. path)
    return res
end

-- We need quality/type/id alongside the string key inside the loader,
-- so keep a side table mapping key -> {quality, type, id}.
local keyMeta = {}

local RESOURCE_CACHE = LoadingCache.new({
    maxSize = 5000,
    expireSeconds = 30 * 60, -- 30 minutes
    loader = function(rawKey)
        local meta = keyMeta[rawKey]
        return loadFromDisk(rawKey, meta.quality, meta.type, meta.id)
    end,
})

function ResourceHelper.getResource(quality, resType, id)
    local key = makeKey(quality, resType, id)
    keyMeta[key] = { quality = quality, type = resType, id = id }
    return RESOURCE_CACHE:get(key)
end

-- Directory listing via shell-out (no external deps; works on Win/Unix)
local function listFiles(dir)
    local files = {}
    local isWindows = package.config:sub(1, 1) == "\\"
    local cmd = isWindows
        and ('dir "' .. dir .. '" /b 2>nul')
        or ('ls "' .. dir .. '" 2>/dev/null')

    local p = io.popen(cmd)
    if not p then return files end
    for line in p:lines() do
        table.insert(files, line)
    end
    p:close()
    return files
end

local function dirExists(dir)
    local isWindows = package.config:sub(1, 1) == "\\"
    local cmd = isWindows
        and ('if exist "' .. dir .. '" echo yes')
        or ('[ -d "' .. dir .. '" ] && echo yes')
    local p = io.popen(cmd)
    local result = p:read("*l")
    p:close()
    return result == "yes"
end

local function fileNameWithoutExtension(fileName)
    local dotIndex = fileName:match(".*()%.")
    if not dotIndex then return fileName end
    return fileName:sub(1, dotIndex - 1)
end

ResourceHelper.getFileNameWithoutExtension = fileNameWithoutExtension

function ResourceHelper.getResourceIdByCategory(quality, resType)
    local dir = resType:buildDirPath(quality)

    if not dirExists(dir) then return {} end

    local ids = {}
    for _, fileName in ipairs(listFiles(dir)) do
        local nameNoExt = fileNameWithoutExtension(fileName)
        local id = tonumber(nameNoExt)
        if id then table.insert(ids, id) end
    end
    table.sort(ids)
    return ids
end

-- Returns resources for a given quality+type, keyed by id (a Lua table).
function ResourceHelper.getResourcesByType(quality, resType)
    local ids = ResourceHelper.getResourceIdByCategory(quality, resType)
    local result = {}

    for _, id in ipairs(ids) do
        local res = ResourceHelper.getResource(quality, resType, id)
        result[id] = res
    end

    return result
end

-- Returns resource ids grouped by quality for a given type.
function ResourceHelper.getAllByResourceType(resType)
    local result = {}
    for _, quality in pairs(ResourceQuality) do
        local ids = ResourceHelper.getResourceIdByCategory(quality, resType)
        if #ids > 0 then
            result[quality] = ids
        end
    end
    return result
end

return ResourceHelper
