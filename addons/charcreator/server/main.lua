---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("creatorDone", function(identity, character, baseFilter)
    local _src = source
    Wait(1500)
    NarcosServer_PlayersManager.register(_src, {identity, character, baseFilter}, function()
        NarcosServer.toClient("creatorValid", _src)
        NarcosServer.toClient("creatorExit", _src, NarcosConfig_Server.startingPosition)
    end)
end)