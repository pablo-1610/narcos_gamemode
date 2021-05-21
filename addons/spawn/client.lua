---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [client] created at [21/05/2021 16:29]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]


Narcos.netHandle("esxloaded", function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end
    NarcosClient.freezePlayer(PlayerId(), true)
    local selectedSpawn = {x = -9.96562, y = -1438.54, z = 31.1015, heading = 90.0}
    selectedSpawn.model = "a_m_m_socenlat_01"
    NarcosClient.requestModel(selectedSpawn.model)
    selectedSpawn.model = Narcos.hash(selectedSpawn.model)
    SetPlayerModel(PlayerId(), selectedSpawn.model)
    SetModelAsNoLongerNeeded(selectedSpawn.model)
    RequestCollisionAtCoord(selectedSpawn.x, selectedSpawn.y, selectedSpawn.z)
    local ped = PlayerId()
    SetEntityCoordsNoOffset(ped, selectedSpawn.x, selectedSpawn.y, selectedSpawn.z, false, false, false, true)
    NetworkResurrectLocalPlayer(selectedSpawn.x, selectedSpawn.y, selectedSpawn.z, selectedSpawn.heading, true, true, false)
    ClearPedTasksImmediately(ped)
    RemoveAllPedWeapons(ped)
    ClearPlayerWantedLevel(PlayerId())
    local time = GetGameTimer()
    while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end
    ShutdownLoadingScreen()
    NarcosClient.freezePlayer(PlayerId(), false)
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    DoScreenFadeIn(1500)
end)
