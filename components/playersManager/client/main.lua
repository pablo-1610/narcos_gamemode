---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 19:31]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("playerSpawnBase", function(position, body, outfit)
    NarcosClient.PlayerHeler.spawnPlayer({x = position.pos.x, y = position.pos.y, z = position.pos.z, heading = position.heading}, true, function()

    end, function()
        Narcos.toInternal("setSaver", true)
        NarcosClient_SkinManager.loadSkin(body)
        NarcosClient.trace("Corps chargé")
        Wait(100)
        NarcosClient_SkinManager.loadSkin(outfit)
        NarcosClient.trace("Tenue chargée")
        DoScreenFadeIn(1000)
    end)
end)