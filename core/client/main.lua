---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 16:01]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

isAMenuActive, serverUpdating = false, false
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
    personnalData = data
end)

-- Boucle principale 0 ms
Narcos.newThread(function()
    while true do
        Wait(0)
        SetTextChatEnabled(false)
        ClearPlayerWantedLevel(PlayerPedId())
        ResetPlayerStamina(PlayerPedId())
        RestorePlayerStamina(PlayerPedId(), true)
        DisablePlayerVehicleRewards(PlayerPedId())
        SetGarbageTrucks(false)
        SetRandomBoats(false)
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
        for i = 1, 15 do
            EnableDispatchService(i, false)
            Citizen.Wait(1)
        end
    end
end)