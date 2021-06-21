---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 07:54]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_NpcsManager = {}
NarcosServer_NpcsManager.list = {}

NarcosServer_NpcsManager.createPublic = function(model, ai, frozen, position, animation, onCreate)
    local npc = Npc(model, ai, frozen, position, animation, false)
    npc:setOnCreate(onCreate or function() end)
    NarcosServer.toAll("newNpc", npc)
    return npc
end

NarcosServer_NpcsManager.createPrivate = function(model, ai, frozen, position, animation, baseAllowed, onCreate)
    local npc = Npc(model, ai, frozen, position, animation, true, baseAllowed)
    local players = NarcosServer_PlayersManager.list
    for k, v in pairs(players) do
        if npc:isAllowed(k) then
            NarcosServer.toClient("newNpc", k, npc)
        end
    end
    return npc
end

NarcosServer_NpcsManager.addAllowed = function(npcId, playerId)
    if not NarcosServer_NpcsManager.list[npcId] then
        return
    end
    ---@type Npc
    local npc = NarcosServer_NpcsManager.list[npcId]
    if npc:isAllowed(playerId) then
        return
    end
    npc:addAllowed(playerId)
    NarcosServer.toClient("newNpc", playerId, npc)
    NarcosServer_NpcsManager.list[npcId] = npc
end

NarcosServer_NpcsManager.removeAllowed = function(npcId, playerId)
    if not NarcosServer_NpcsManager.list[npcId] then
        return
    end
    ---@type Npc
    local npc = NarcosServer_NpcsManager.list[npcId]
    if not npc:isAllowed(playerId) then
        return
    end
    npc:removeAllowed(playerId)
    NarcosServer.toClient("delNpc", playerId, npcId)
    NarcosServer_NpcsManager.list[npcId] = npc
end

NarcosServer_NpcsManager.updateOne = function(source)
    local npcs = {}
    ---@param npc Npc
    for npcId, npc in pairs(NarcosServer_NpcsManager.list) do
        if npc:isRestricted() then
            if npc:isAllowed(source) then
                npcs[npcId] = npc
            end
        else
            npcs[npcId] = npc
        end
    end
    NarcosServer.toClient("cbNpcs", source, npcs)
end

Narcos.netRegisterAndHandle("requestPredefinedNpcs", function()
    local source = source
    NarcosServer_NpcsManager.updateOne(source)
end)