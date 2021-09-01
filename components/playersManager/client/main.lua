---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 19:31]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netHandle("playerOk", function()
    SetPedMinGroundTimeForStungun(PlayerPedId(), 10000)
    NarcosClient.toServer("playerOkServ")
end)

Narcos.netRegisterAndHandle("playerSpawnBase", function(position, body, outfit, ld, fastFade)
    if not fastFade then
        NarcosClient.PlayerHeler.spawnPlayer({x = position.pos.x, y = position.pos.y, z = position.pos.z, heading = position.heading}, not fastFade, function()

        end, function()
            if body["sex"] == 0 then
                local model = GetHashKey("mp_f_freemode_01")
                RequestModel(model)
                while not HasModelLoaded(model) do Wait(1) end
                SetPlayerModel(PlayerId(), model)
                ClearAllPedProps(PlayerPedId())
                Wait(1800)
                ClearAllPedProps(PlayerPedId())
            end
            Narcos.toInternal("setSaver", true)
            currentState = NarcosEnums.GameStates.PLAYING
            NarcosClient_SkinManager.loadSkin(body)
            NarcosClient.trace("Corps chargé")
            Wait(100)
            NarcosClient_SkinManager.loadSkin(outfit)
            NarcosClient.trace("Tenue chargée")
            Narcos.toInternal("receiveLoadouts", ld)
            DoScreenFadeIn(1000)
            Wait(1000)
            Narcos.toInternal("playerOk")
        end)
    else
        Narcos.toInternal("setSaver", true)
        currentState = NarcosEnums.GameStates.PLAYING
        NarcosClient_SkinManager.loadSkin(body)
        NarcosClient.trace("Corps chargé")
        Wait(100)
        NarcosClient_SkinManager.loadSkin(outfit)
        NarcosClient.trace("Tenue chargée")
        Narcos.toInternal("receiveLoadouts", ld)
        Wait(1000)
        Narcos.toInternal("playerOk")
    end
end)