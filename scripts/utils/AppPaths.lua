local AppPaths = {}

local sep = package.config:sub(1, 1) == "\\" and "\\" or "/"

function AppPaths.resolve(...)
    return table.concat({...}, sep)
end

return AppPaths