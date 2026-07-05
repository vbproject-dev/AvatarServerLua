--- service/NetworkService.lua


local Message        = require("network.Message")
local Cmd            = require("network.Cmd")
local Utils          = require("utils.Utils")
local DataManager    = require("manager.DataManager")

local NetworkService = {}


function NetworkService.sendMessageBox(session, content)
    local msg = Message.new(Cmd.SERVER_MESSAGE)
    msg:writeUTF(content)
    NetworkService.send(session, msg)
end

function NetworkService.sendHandler(session, code)
    local msg = Message.new(Cmd.GET_HANDLER)
    msg:writeByte(code)
    NetworkService.send(session, msg)
end

function NetworkService.sendGetBigResponse(session, resData)
    local m = Message.new(Cmd.GET_BIG);
    m:writeShort(resData:getId());
    m:writeShort(resData:getSize());
    m:writeShort(resData:getSize());
    m:writeBytes(resData:getData());
    NetworkService.send(session, m)
end

function NetworkService.sendSetBigResponse(session, tableData)
    local m = Message.new(Cmd.SET_BIG);
    m:writeByte(Utils.mapSize(tableData));
    for _, resData in pairs(tableData) do
        m:writeShort(resData:getId())
        m:writeShort(resData:getSize())
    end

    m:writeShort(30314);
    m:writeShort(15294);
    m:writeShort(17343);
    m:writeShort(2);
    m:writeShort(1);
    m:writeByte(0);
    m:writeInt(1);

    NetworkService.send(session, m)
end

function NetworkService.sendGetAvatarPartResponse(session)
    local filtered = {}

    for _, part in pairs(DataManager.parts) do
        if part:getId() > 702 then
            break
        end
        table.insert(filtered, part)
    end

    local m = Message.new(Cmd.GET_AVATAR_PART);
    m:writeShort(#filtered)
    for _, part in ipairs(filtered) do
        m:writeShort(part:getId())
        m:writeInt(part:getCoin())
        m:writeShort(part:getGold())
        m:writeShort(part:getType())
        if part:getType() == -2 then
            m:writeUTF(part:getName())
            m:writeByte(part:getSell())
            m:writeShort(part:getIcon())
        elseif part:getType() == -1 then
            m:writeUTF(part:getName())
            m:writeByte(part:getSell())
            m:writeByte(part:getZorder())
            m:writeByte(part:getGender())
            m:writeByte(part:getLevel())
            m:writeShort(part:getIcon())
            for _, animation in ipairs(part:getAnimations()) do
                m:writeShort(animation.img)
                m:writeByte(animation.dx)
                m:writeByte(animation.dy)
            end
        else
            m:writeShort(part:getIcon())
        end
    end
    NetworkService.send(session, m)
end

function NetworkService.sendGetImageResponse(session)
    local m = Message.new(Cmd.GET_IMAGE)
    m:writeShort(#DataManager.imagesData)
    for _, image in ipairs(DataManager.imagesData) do
        m:writeShort(image:getItemId())
        m:writeShort(image:getImageId())
        m:writeByte(image:getX())
        m:writeByte(image:getY())
        m:writeByte(image:getW())
        m:writeByte(image:getH())
    end
    NetworkService.send(session, m)
end

function NetworkService.sendLoginResponse(session)
    local player = session:getPlayer()

    local m = Message.new(Cmd.LOGIN_SUCCESS)
    m:writeInt(player:getId())
    m:writeByte(#player:getWearing())
    for _, item in ipairs(player:getWearing()) do
        m:writeShort(item:getId())
    end

    m:writeByte(player:getGender())
    m:writeByte(player:getLevel())
    m:writeByte(player:getExperience())
    m:writeInt(player:getMoney())

    m:writeByte(player:getFriendly())
    m:writeByte(player:getCrazy())
    m:writeByte(player:getStylish())
    m:writeByte(player:getHappy())
    m:writeByte(player:getHunger())

    m:writeInt(player:getGold())
    m:writeByte(player:getStar())

    for _, item in ipairs(player:getWearing()) do
        m:writeByte(1)
        m:writeUTF(item:expiredString())
    end


    m:writeShort(-1);

    local normalCommands = {}
    for _, command in ipairs(player:getCommands()) do
        if command:getType() == 0 then
            table.insert(normalCommands, command)
        end
    end


    m:writeByte(#normalCommands);
    for _, cmd in ipairs(normalCommands) do
        m:writeUTF(cmd:getName())
        m:writeShort(cmd:getIcon())
    end

    local rotateCommands = {}

    for _, command in ipairs(player:getCommands()) do
        if command:getType() == 1 then
            table.insert(rotateCommands, command)
        end
    end

    m:writeByte(#rotateCommands)
    for _, cmd in ipairs(rotateCommands) do
        m:writeShort(cmd:getAnthor())
        m:writeUTF(cmd:getName())
        m:writeShort(cmd:getIcon())
    end

    m:writeBoolean(true);
    for _, cmd in ipairs(rotateCommands) do
        m:writeByte(cmd:getType())
    end

    m:writeByte(1);
    m:writeShort(player:getLevel())

    m:writeShort(-1);

    m:writeBoolean(true);
    m:writeInt(0);


    local l = 4;
    m:writeByte(l);
    local IDAction = { 103, 102, 104, 107 };
    local actionName = { "Tặng Hoa Violet", "Hôn", "Tặng cánh hoa", "Tặng Hoa Tuyết" };
    local IDIcon = { 1124, 1188, 1187, 1173 };
    local money = { 20000, 2000, 10000, 5 };
    local typeMoney = { 0, 0, 0, 1 };
    for i2 = 1, l do
        m:writeShort(IDAction[i2]);
        m:writeUTF(actionName[i2]);
        m:writeShort(IDIcon[i2]);
        m:writeInt(money[i2]);
        m:writeByte(typeMoney[i2]);
    end

    m:writeInt(player:getGold())
    m:writeInt(player:getLockedGold())
    m:writeByte(1);
    m:writeUTF(player:getName())

    NetworkService.send(session, m)
end

function NetworkService.sendRequestExpicePetResponse(session, id)
    local m = Message.new(Cmd.REQUEST_EXPICE_PET);
    m:writeInt(id)
    m:writeByte(0)
    NetworkService.send(session, m)
end

function NetworkService.sendMapItemResponse(session, data)
    local m = Message.new(Cmd.MAP_ITEM);
    m:writeBytes(data)
    NetworkService.send(session, m)
end

function NetworkService.sendMapItemTypeResponse(session, data)
    local m = Message.new(Cmd.MAP_ITEM_TYPE);
    m:writeBytes(data)
    NetworkService.send(session, m)
end

function NetworkService.sendGetImgIconResponse(session, res)
    local m = Message.new(Cmd.GET_IMG_ICON);
    m:writeShort(res:getId())
    m:writeShort(res:getSize())
    m:writeBytes(res:getData())
    NetworkService.send(session, m)
end

function NetworkService.sendGetItemInfoResponse(session)
    local m = Message.new(Cmd.GET_ITEM_INFO);
    m:writeShort(#DataManager.foods);
    for _, food in pairs(DataManager.foods) do
        m:writeShort(food:getId())
        m:writeUTF(food:getName())
        m:writeUTF(food:getDescription())
        m:writeInt(food:getPrice())
        m:writeByte(food:getShop())
        m:writeShort(food:getIcon())
    end
    NetworkService.send(session, m)
end

function NetworkService.send(session, msg)
    session:send(msg.command, msg:getData(), msg:size())
end

return NetworkService
