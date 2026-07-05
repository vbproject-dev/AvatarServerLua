local Message = {}
Message.__index = Message

function Message.new(cmd)
    local self   = setmetatable({}, Message)
    self.command = cmd & 0xFF
    self._buf    = {}
    self._read   = nil
    self._pos    = 1
    return self
end

function Message.fromData(cmd, data)
    local self   = setmetatable({}, Message)
    self.command = cmd
    self._buf    = nil
    self._read   = data or ""
    self._pos    = 1
    return self
end

-- ── write ──────────────────────────────────────────────────────
-- function Message:writeByte(v)
--     if type(v) ~= "number" then
--         error(("writeByte expected number, got %s (%s)\n%s")
--             :format(type(v), tostring(v), debug.traceback()))
--     end

--     self._buf[#self._buf + 1] = string.pack("B", v & 0xFF)
-- end

function Message:writeByte(v)
    self._buf[#self._buf + 1] = string.pack("B", v & 0xFF)
end

function Message:writeSignedByte(v)
    self._buf[#self._buf + 1] = string.pack("b", v)
end

function Message:writeShort(v)
    self._buf[#self._buf + 1] = string.pack(">i2", v)
end

function Message:writeInt(v)
    self._buf[#self._buf + 1] = string.pack(">i4", v)
end

function Message:writeLong(v)
    self._buf[#self._buf + 1] = string.pack(">i8", v)
end

function Message:writeFloat(v)
    self._buf[#self._buf + 1] = string.pack(">f", v)
end

function Message:writeDouble(v)
    self._buf[#self._buf + 1] = string.pack(">d", v)
end

function Message:writeBoolean(v)
    self._buf[#self._buf + 1] = string.pack("B", v and 1 or 0)
end

function Message:writeUTF(s)
    s = s or ""
    self._buf[#self._buf + 1] = string.pack(">I2", #s) .. s
end

function Message:writeBytes(s)
    self._buf[#self._buf + 1] = s
end

-- READ

local function unpack(self, fmt, size)
    local val = string.unpack(fmt, self._read, self._pos)
    self._pos = self._pos + size
    return val
end

function Message:readByte()
    return unpack(self, "b", 1)
end

function Message:readUnsignedByte()
    return unpack(self, "B", 1)
end

function Message:readShort()
    return unpack(self, ">i2", 2)
end

function Message:readUnsignedShort()
    return unpack(self, ">I2", 2)
end

function Message:readInt()
    return unpack(self, ">i4", 4)
end

function Message:readLong()
    return unpack(self, ">i8", 8)
end

function Message:readFloat()
    return unpack(self, ">f", 4)
end

function Message:readDouble()
    return unpack(self, ">d", 8)
end

function Message:readBoolean()
    return unpack(self, "B", 1) ~= 0
end

function Message:readUTF()
    local len = unpack(self, ">I2", 2)
    local s   = self._read:sub(self._pos, self._pos + len - 1)
    self._pos = self._pos + len
    return s
end

function Message:readBytes(n)
    local s   = self._read:sub(self._pos, self._pos + n - 1)
    self._pos = self._pos + n
    return s
end

function Message:remaining()
    if not self._read then return 0 end
    return #self._read - self._pos + 1
end

-- MISC

function Message:getData()
    return table.concat(self._buf)
end

function Message:cleanup()
    self._buf  = nil
    self._read = nil
    self._pos  = 1
end

function Message:size()
    if self._buf then
        return #table.concat(self._buf)
    end

    if self._read then
        return #self._read
    end

    return 0
end

Message.close = Message.cleanup

return Message
