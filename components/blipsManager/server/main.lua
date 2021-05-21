---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.

  File [main] created at [21/05/2021 16:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_BlipsManager = {}
NarcosServer_BlipsManager.list = {}

NarcosServer_BlipsManager.createPublic = function(position, sprite, color, scale, text, shortRange)
    local blip = Blip(position, sprite, color, scale, text, shortRange, false)
    NarcosServer.toAll("newBlip", blip)
    return blip.blipId
end

NarcosServer_BlipsManager.createPrivate = function(position, sprite, color, scale, text, shortRange, baseAllowed)
    local blip = Blip(position, sprite, color, scale, text, shortRange, true, baseAllowed)
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if blip:isAllowed(v) then
            NarcosServer.toClient("newBlip", v, blip)
        end
    end
    return blip.blipId
end

NarcosServer_BlipsManager.addAllowed = function(blipID, playerId)
    if not NarcosServer_BlipsManager.list[blipID] then
        return
    end
    ---@type Blip
    local blip = NarcosServer_BlipsManager.list[blipID]
    if blip:isAllowed(playerId) then
        return
    end
    blip:addAllowed(playerId)
    NarcosServer.toClient("newBlip", playerId, blip)
    NarcosServer_BlipsManager.list[blipID] = blip
end

NarcosServer_BlipsManager.removeAllowed = function(blipID, playerId)
    if not NarcosServer_BlipsManager.list[blipID] then
        return
    end
    ---@type Blip
    local blip = NarcosServer_BlipsManager.list[blipID]
    if not blip:isAllowed(playerId) then
        return
    end
    blip:removeAllowed(playerId)
    NarcosServer.toClient("delBlip", playerId, blipID)
    NarcosServer_BlipsManager.list[blipID] = blip
end

NarcosServer_BlipsManager.updateOne = function(source)
    local blips = {}
    ---@param blip Blip
    for blipID, blip in pairs(NarcosServer_BlipsManager.list) do
        if blip:isRestricted() then
            if blip:isAllowed(source) then
                blips[blipID] = blip
            end
        else
            blips[blipID] = blip
        end
    end
    NarcosServer.toClient("cbBlips", source, blips)
end

NarcosServer_BlipsManager.delete = function(blipID)
    if not NarcosServer_BlipsManager.list[blipID] then
        return
    end
    ---@type Zone
    local blip = NarcosServer_BlipsManager.list[blipID]
    if blip:isRestricted() then
        local players = ESX.GetPlayers()
        for k, playerId in pairs(players) do
            if blip:isAllowed(playerId) then
                NarcosServer.toClient("delBlip", playerId, blipID)
            end
        end
    else
        NarcosServer.toAll("delBlip", blipID)
    end
end

Narcos.netRegisterAndHandle("requestPredefinedBlips", function()
    local source = source
    NarcosServer_BlipsManager.updateOne(source)
end)