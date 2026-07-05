-- DataManager.lua

local DataManager = {}

DataManager.parts = {}
DataManager.foods = {}
DataManager.imagesData = {}


function DataManager.getPart(id)
    for _, part in pairs(DataManager.parts) do
        if part.id == id then
            return part
        end
    end
end

function DataManager.getFood(id)
    for _, food in pairs(DataManager.foods) do
        if food.id == id then
            return food
        end
    end
end

function DataManager.getImageData(id)
    for _, data in pairs(DataManager.imagesData) do
        if data.id == id then
            return data
        end
    end
end

function DataManager.clear()
    DataManager.parts = {}
    DataManager.foods = {}
    DataManager.imagesData = {}
end

return DataManager
