---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [15/06/2021 17:12]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netHandle("sideLoaded", function()
    Narcos.newThread(function()
        while true do
            Wait(Narcos.second(15))
            NarcosServer.toAll("positionSave")
        end
    end)
end)

Narcos.netRegisterAndHandle("positionCb", function(position)
    local _src = source
    if not NarcosServer_PlayersManager.exists(_src) then
        return
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    player:savePosition(position)
end)