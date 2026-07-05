local MySQL       = require("lib.MysqlHelper")
local Part        = require("models.Part")
local ImageData   = require("models.ImageData")
local Food        = require("models.Food")
local DataManager = require("manager.DataManager")
local DataLoader  = {}

local function loadTable(db, tableName, modelClass, targetField)
    local data, err = db:from(tableName):class(modelClass):getAll()

    if err then
        return false, err
    end

    DataManager[targetField] = data
    print(("DataLoader: Loaded %d %s."):format(#data, targetField))

    return true
end

function DataLoader.loadDatabase()
    local db = MySQL.instance()

    local datasets = {
        { table = "items",      class = Part,      field = "parts" },
        { table = "image_data", class = ImageData, field = "imagesData" },
        { table = "foods",      class = Food,      field = "foods" },
    }

    for _, dataset in ipairs(datasets) do
        local ok, err = loadTable(
            db,
            dataset.table,
            dataset.class,
            dataset.field
        )

        if not ok then
            print(("Failed to load %s: %s"):format(dataset.table, err))
            return false
        end
    end

    return true
end

return DataLoader
