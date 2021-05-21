---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local creatorInfos = {
    position = {
        {
            x = 683.75,
            y = 570.67,
            z = 129.40,
            heading = 162.34
        }
    }
}

Narcos.netRegisterAndHandle("creatorStarts", function()
    Wait(1500)
    NarcosClient.trace("Démarrage du créateur de personnage")
    DoScreenFadeOut(3500)
    while not IsScreenFadedOut() do Wait(1) end
    local initialPosition = {vec = vector3(683.75, 570.67, 129.40), heading = 162.34}
    SetEntityCoords(PlayerPedId(), initialPosition.vec, false, false, false, false)
    SetEntityHeading(PlayerPedId(), initialPosition.heading)
    DoScreenFadeIn(3500)
end)