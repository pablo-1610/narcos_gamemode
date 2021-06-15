---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("creatorDone", function(identity, character, filter)
    local _src = source
    Wait(1500)
    NarcosServer_PlayersManager.register(_src, {identity, character, filter}, function()
        NarcosServer.toClient("creatorValid", _src)
        NarcosServer.toClient("creatorExit", _src, NarcosConfig_Server.startingPosition, NarcosConfig_Server.startingHeading)
    end)
end)