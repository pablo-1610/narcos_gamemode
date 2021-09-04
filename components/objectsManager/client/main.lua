---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [04/09/2021 03:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local genDist = 150.0
local objects = {}
objects.list = {}
spObjs = {}

Narcos.netHandle("playerOk", function()
    NarcosClient.toServer("requestPredefinedObjects")
    Narcos.newThread(function()
        Wait(1500)
        while true do
            local pos = GetEntityCoords(PlayerPedId())
            ---@param object Object
            for objectId, object in pairs(objects.list) do
                local objectPos = object.position.coords
                if not objects.list[objectId].objectHandle then
                    if #(pos - objectPos) <= genDist then
                        local model = GetHashKey(object.model)
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                            Wait(1)
                        end
                        local objectHandle = CreateObject(model, object.position.coords.x, object.position.coords.y, object.position.coords.z, false, false)
                        table.insert(spObjs, objectHandle)
                        PlaceObjectOnGroundProperly(objectHandle)
                        if object.frozen then
                            FreezeEntityPosition(objectHandle, true)
                        end
                        SetEntityHeading(objectHandle, object.position.heading)
                        SetEntityAsMissionEntity(objectHandle, 0, 0)
                        objects.list[objectId].objectHandle = objectHandle
                        if object.invincible then
                            SetEntityInvincible(objectHandle, true)
                        end
                    end
                end
            end
            Wait(1100)
        end
    end)
end)

---@param object Object
Narcos.netRegisterAndHandle("newOject", function(object)
    objects.list[object.id] = object
end)

Narcos.netRegisterAndHandle("delObject", function(npcId)
    if objects.list[npcId] == nil then
        return
    end
    if objects.list[npcId].objectHandle ~= nil and DoesEntityExist(objects.list[npcId].objectHandle) then
        DeleteEntity(objects.list[npcId].objectHandle)
    end
    objects.list[npcId] = nil
end)

Narcos.netRegisterAndHandle("cbObjects", function(incomingObjects)
    objects.list = incomingObjects
end)