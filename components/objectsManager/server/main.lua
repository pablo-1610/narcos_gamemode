---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [04/09/2021 03:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_ObjectsManager = {}
NarcosServer_ObjectsManager.list = {}

NarcosServer_ObjectsManager.createPublic = function(model, frozen, position)
    local object = Object(model, frozen, position, false)
    NarcosServer.toAll("newObject", object)
    return object
end

NarcosServer_ObjectsManager.createPrivate = function(model, frozen, position, baseAllowed)
    local object = Object(model, frozen, position, true, baseAllowed)
    local players = NarcosServer_PlayersManager.list
    for k, v in pairs(players) do
        if object:isAllowed(k) then
            NarcosServer.toClient("newObject", k, object)
        end
    end
    return npc
end

NarcosServer_ObjectsManager.addAllowed = function(objectId, playerId)
    if not NarcosServer_ObjectsManager.list[objectId] then
        return
    end
    ---@type Object
    local pbject = NarcosServer_ObjectsManager.list[objectId]
    if pbject:isAllowed(playerId) then
        return
    end
    pbject:addAllowed(playerId)
    NarcosServer.toClient("newObject", playerId, pbject)
    NarcosServer_ObjectsManager.list[objectId] = pbject
end

NarcosServer_ObjectsManager.removeAllowed = function(objectId, playerId)
    if not NarcosServer_ObjectsManager.list[objectId] then
        return
    end
    ---@type Object
    local object = NarcosServer_ObjectsManager.list[objectId]
    if not object:isAllowed(playerId) then
        return
    end
    object:removeAllowed(playerId)
    NarcosServer.toClient("delObject", playerId, objectId)
    NarcosServer_ObjectsManager.list[objectId] = object
end

NarcosServer_ObjectsManager.updateOne = function(source)
    local objects = {}
    ---@param object Object
    for objectId, object in pairs(NarcosServer_ObjectsManager.list) do
        if object:isRestricted() then
            if object:isAllowed(source) then
                objects[objectId] = object
            end
        else
            objects[objectId] = object
        end
    end
    NarcosServer.toClient("cbObjects", source, objects)
end

Narcos.netRegisterAndHandle("requestPredefinedObjects", function()
    local source = source
    NarcosServer_ObjectsManager.updateOne(source)
end)