---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 16:01]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

isAMenuActive, serverUpdating, canInteractWithMarkers = false, false, true
currentState = nil
personnalData = {}

Narcos.newThread(function()
    currentState = NarcosEnums.GameStates.LOADING
    while true do
        Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            NarcosClient.toServer("playerJoined")
            Narcos.toInternal("sideLoaded")
            break
        end
    end
end)

-- Base
Narcos.netRegisterAndHandle("updateLocalData", function(data)
    local beforeMoney
    if personnalData.player ~= nil then
        beforeMoney = personnalData.player.cash
    end
    personnalData = data
    local afterMoney = personnalData.player.cash
    NarcosClient_Hud.showVariation(beforeMoney, afterMoney)
end)

Narcos.netRegisterAndHandle("serverReturnedCb", function()
    serverUpdating = false
end)

-- Boucle principale 0 ms
Narcos.newThread(function()
    while true do
        Wait(0)
        local playerId = PlayerId()
        if GetPlayerWantedLevel(playerId) ~= 0 then
            SetPlayerWantedLevel(playerId, 0, false)
            SetPlayerWantedLevelNow(playerId, false)
        end
        DisablePlayerVehicleRewards(playerId)
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(13)
    end
end)

Narcos.newThread(function()
    while currentState ~= NarcosEnums.GameStates.PLAYING do
        Wait(100)
    end
    while true do
        for i = 1, 15 do
            EnableDispatchService(i, false)
        end
        ResetPlayerStamina(PlayerPedId())
        RestorePlayerStamina(PlayerPedId(), true)
        DisablePlayerVehicleRewards(PlayerPedId())
        -- Lockdown is handling that
        --[[
        SetGarbageTrucks(false)
        SetRandomBoats(false)
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
        --]]
        Wait(350)
        if not NarcosClient_Hud.isSpeedoActive() then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                    NarcosClient_Hud.activeSpeedo()
                end
             end
        end
    end
end)