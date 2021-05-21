---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.

  File [main] created at [21/05/2021 16:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_ZonesManager = {}
NarcosServer_ZonesManager.list = {}

NarcosServer_ZonesManager.createPublic = function(location, type, color, onInteract, helpText, drawDist, itrDist)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, false)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    NarcosServer.toAll("newMarker", marker)
    return zone.zoneID
end

NarcosServer_ZonesManager.createPrivate = function(location, type, color, onInteract, helpText, drawDist, itrDist, baseAllowed)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, true, baseAllowed)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if zone:isAllowed(v) then
            NarcosServer.toClient("newMarker", v, marker)
        end
    end
    return zone.zoneID
end

NarcosServer_ZonesManager.addAllowed = function(zoneID, playerId)
    if not NarcosServer_ZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = NarcosServer_ZonesManager.list[zoneID]
    if zone:isAllowed(playerId) then
        return
    end
    zone:addAllowed(playerId)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    NarcosServer.toClient("newMarker", playerId, marker)
    NarcosServer_ZonesManager.list[zoneID] = zone
end

NarcosServer_ZonesManager.removeAllowed = function(zoneID, playerId)
    if not NarcosServer_ZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = NarcosServer_ZonesManager.list[zoneID]
    if not zone:isAllowed(playerId) then
        return
    end
    zone:removeAllowed(playerId)
    NarcosServer.toClient("delMarker", playerId, zoneID)
    NarcosServer_ZonesManager.list[zoneID] = zone
end

NarcosServer_ZonesManager.updatePrivacy = function(zoneID, newPrivacy)
    if not NarcosServer_ZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = NarcosServer_ZonesManager.list[zoneID]
    local wereAllowed = {}
    local wasRestricted = zone:isRestricted()
    if zone:isRestricted() then
        wereAllowed = zone.allowed
    end
    zone.allowed = {}
    zone:setRestriction(newPrivacy)
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        if not wasRestricted then
            for _, playerId in pairs(players) do
                local isAllowedtoSee = false
                for _, allowed in pairs(wereAllowed) do
                    if allowed == playerId then
                        isAllowedtoSee = true
                    end
                end
                if not isAllowedtoSee then
                    NarcosServer.toClient("delMarker", playerId, zone.zoneID)
                end
            end
        end
    else
        if wasRestricted then
            for _, playerId in pairs(players) do
                local isAllowedtoSee = false
                for _, allowed in pairs(wereAllowed) do
                    if allowed == playerId then
                        isAllowedtoSee = true
                    end
                end
                if isAllowedtoSee then
                    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
                    NarcosServer.toClient("newMarker", playerId, marker)
                end
            end
        end
    end
    NarcosServer_ZonesManager.list[zoneID] = zone
end

NarcosServer_ZonesManager.delete = function(zoneID)
    if not NarcosServer_ZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = NarcosServer_ZonesManager.list[zoneID]
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        for k, playerId in pairs(players) do
            if zone:isAllowed(playerId) then
                NarcosServer.toClient("delMarker", playerId, zoneID)
            end
        end
    else
        NarcosServer.toAll("delMarker", zoneID)
    end
end

NarcosServer_ZonesManager.updateOne = function(source)
    local markers = {}
    ---@param zone Zone
    for zoneID, zone in pairs(NarcosServer_ZonesManager.list) do
        if zone:isRestricted() then
            if zone:isAllowed(source) then
                markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
            end
        else
            markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
        end
    end
    NarcosServer.toClient("cbZones", source, markers)
end

Narcos.netRegisterAndHandle("requestPredefinedZones", function()
    local source = source
    NarcosServer_ZonesManager.updateOne(source)
end)

Narcos.netRegisterAndHandle("interactWithZone", function(zoneID)
    local source = source
    if not NarcosServer_ZonesManager.list[zoneID] then
        NarcosServer.kick(source, "Tentative d'intéragir avec une zone inéxistante.")
        return
    end
    ---@type Zone
    local zone = NarcosServer_ZonesManager.list[zoneID]
    zone:interact(source)
end)