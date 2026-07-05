local LoadingCache = {}
LoadingCache.__index = LoadingCache

-- opts: { maxSize = number, expireSeconds = number, loader = function(key) -> value }
function LoadingCache.new(opts)
    return setmetatable({
        maxSize = opts.maxSize,
        expireSeconds = opts.expireSeconds,
        loader = opts.loader,
        entries = {},       -- key -> { value, lastAccess }
        order = {},         -- array of keys, most-recently-used at the end
    }, LoadingCache)
end

local function touch(self, key)
    for i, k in ipairs(self.order) do
        if k == key then
            table.remove(self.order, i)
            break
        end
    end
    table.insert(self.order, key)
end

local function evictExpired(self)
    if not self.expireSeconds then return end
    local now = os.time()
    for key, entry in pairs(self.entries) do
        if now - entry.lastAccess > self.expireSeconds then
            self.entries[key] = nil
            for i, k in ipairs(self.order) do
                if k == key then
                    table.remove(self.order, i)
                    break
                end
            end
        end
    end
end

local function evictOverflow(self)
    while self.maxSize and #self.order > self.maxSize do
        local oldest = table.remove(self.order, 1)
        self.entries[oldest] = nil
    end
end

function LoadingCache:get(key)
    evictExpired(self)

    local entry = self.entries[key]
    if entry then
        entry.lastAccess = os.time()
        touch(self, key)
        return entry.value
    end

    local value = self.loader(key)
    self.entries[key] = { value = value, lastAccess = os.time() }
    touch(self, key)
    evictOverflow(self)
    return value
end

return LoadingCache