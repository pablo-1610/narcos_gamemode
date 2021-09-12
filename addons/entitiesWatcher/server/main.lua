---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [30/06/2021 14:09]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local function clearDeadVehicles()
    for _, vehicle in ipairs(GetAllVehicles()) do
        if GetVehicleEngineHealth(vehicle) <= 0 then
            DeleteEntity(vehicle)
        end
    end
end

local function deleteNewVehicles()
    local playersVehicles = {}
    ---@param player Player
    for k, player in pairs(NarcosServer_PlayersManager.list) do
        if player.ingame then
            playersVehicles[k] = GetVehiclePedIsIn(GetPlayerPed(k), false)
        end
    end
    local mountedCount = 0
    for _, vehicle in ipairs(GetAllVehicles()) do
        -- Check veh and delete
        if DoesEntityExist(vehicle) then
            local isMounted = false
            for source, ownedVehicle in pairs(playersVehicles) do
                if(ownedVehicle == vehicle) then
                    isMounted = true
                    mountedCount = mountedCount + 1
                end
            end
            -- TODO -> Change to location
            --[[
            if not isMounted and GetEntityModel(vehicle) == GetHashKey(NarcosConfig_Server.yatchVehicle) then
                DeleteEntity(vehicle)
            end
            --]]
        end
    end
end

Narcos.netHandle("sideLoaded", function()
    Narcos.newRepeatingTask(function()
        clearDeadVehicles()
    end, function()
    end, 1, (Narcos.second(60)*5))

    Narcos.newRepeatingTask(function()
        deleteNewVehicles()
    end, function()

    end, 1, (Narcos.second(60*3)))
end)
