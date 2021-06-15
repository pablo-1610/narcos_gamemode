---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [15/06/2021 17:11]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local saverEnabled = false

Narcos.netHandle("setSaver", function(state)
    saverEnabled = state
end)

Narcos.netRegisterAndHandle("positionSave", function()
    if saverEnabled then
        local pos = {pos = GetEntityCoords(PlayerPedId()), heading = GetEntityHeading(PlayerPedId())}
        NarcosClient.trace("Position sauvegardée")
        NarcosClient.toServer("positionCb", pos)
    end
end)