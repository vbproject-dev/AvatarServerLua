--- handler/DefaultHandler.lua

local Cmd             = require("network.Cmd")
local MySQL           = require("lib.MysqlHelper")
local Utils           = require("utils.Utils")
local Account         = require("models.Account")
local NetworkService  = require("service.NetworkService")
local ResourceType    = require("utils.ResourceType")
local ResourceQuality = require("utils.ResourceQuality")
local ResourceHelper  = require("utils.ResourceHelper")
local Player          = require("models.Player")

local DefaultHandler  = {}

local function onSetProvider(session, msg)
    local provider = msg:readByte()
    local memory = msg:readInt()
    local platform = msg:readUTF()
    local rmsSize = msg:readInt()
    local width = msg:readInt()
    local height = msg:readInt()
    local aaaaa = msg:readBoolean()
    local resource = msg:readByte()
    local version = msg:readUTF()

    session:setResQuality(resource)
end

function DefaultHandler.onMessage(session, msg)
    local cmd = msg.command
    if cmd == Cmd.LOGIN then
        local username = msg:readUTF()
        local password = msg:readUTF()
        print(string.format("[DefaultHandler] Login attempt: %s ", username))

        local db = MySQL.instance()
        local user, err = db:from("account"):where("username", username):getFirst()

        if not user then
            print("[DefaultHandler] User not found: " .. username)
            NetworkService.sendMessageBox(session, "Wrong username or password!")
            return
        end

        if not Utils.verifyMD5(password, user.password) then
            print("[DefaultHandler] Wrong password for: " .. username)
            NetworkService.sendMessageBox(session, "Wrong username or password!")
            return
        end

        local account = Account.fromRow(user)

        local player, err = db:from("player"):where("account_id", account.id):class(Player):getFirst()
        if err then
            print("[DefaultHandler] Player not found for account: " .. account.id)
            NetworkService.sendMessageBox(session, "Player data not found!")
            return
        end

        session:setAccount(account)
        session:setPlayer(player)
        player:bindSession(session)
        NetworkService.sendLoginResponse(session)
    elseif cmd == Cmd.SET_PROVIDER then
        onSetProvider(session, msg)
    elseif cmd == Cmd.SET_BIG then
        local quality = ResourceQuality.MEDIUM
        if session:getResQuality() == 1 then
            quality = ResourceQuality.HD
        end

        local resources = ResourceHelper.getResourcesByType(quality, ResourceType.BIG)
        if resources then
            NetworkService.sendSetBigResponse(session, resources)
        end
    elseif cmd == Cmd.GET_BIG then
        local id = msg:readShort()

        local quality = (session:getResQuality() == 0)
            and ResourceQuality.MEDIUM
            or ResourceQuality.HD

        local res = ResourceHelper.getResource(quality, ResourceType.BIG, id)
        if res then
            NetworkService.sendGetBigResponse(session, res)
        end
    elseif cmd == Cmd.GET_IMAGE then
        NetworkService.sendGetImageResponse(session)
    elseif cmd == Cmd.GET_AVATAR_PART then
        NetworkService.sendGetAvatarPartResponse(session)
    elseif cmd == Cmd.REQUEST_EXPICE_PET then
        local id = msg:readShort()
        NetworkService.sendRequestExpicePetResponse(session, id)
    elseif cmd == Cmd.GET_IMG_ICON then
        local quality = (session:getResQuality() == 0)
            and ResourceQuality.MEDIUM
            or ResourceQuality.HD
        local res = ResourceHelper.getResource(quality, ResourceType.PART_OBJECT, msg:readShort())
        if res then
            NetworkService.sendGetImgIconResponse(session, res)
        end
    elseif cmd == Cmd.MAP_ITEM_TYPE then
        local data, err = Utils.readBytes("assets/raw/map_item_type.dat")
        if (err) then
            print(err)
            return
        end
        NetworkService.sendMapItemTypeResponse(session, data)
    elseif cmd == Cmd.MAP_ITEM then
        local data, err = Utils.readBytes("assets/raw/map_item.dat")
        if (err) then
            print(err)
            return
        end
        NetworkService.sendMapItemResponse(session, data)
    elseif cmd == Cmd.GET_ITEM_INFO then
        NetworkService.sendGetItemInfoResponse(session)
    else
        print(string.format("[DefaultHandler] Unknown cmd=%d ", cmd))
    end
end

return DefaultHandler
