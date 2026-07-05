--- models/Account.lua

local Account = {}
Account.__index = Account

function Account.new(data)
    return setmetatable({
        id        = data.id        or 0,
        username  = data.username  or "",
        password  = data.password  or "",
        email     = data.email     or "",
        ipAddress = data.ipAddress or "",
    }, Account)
end

-- Build from a raw MySQL row
function Account.fromRow(row)
    return Account.new({
        id        = tonumber(row.id),
        username  = row.username,
        password  = row.password,
        email     = row.email     or "",
        ipAddress = row.ip_address or "",
    })
end

return Account
