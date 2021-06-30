---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [20/06/2021 23:43]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("showIdCard", function(playerId)
    local _src = source
    ---@type Player
    local targetPlayer = NarcosServer_PlayersManager.get(_src)
    NarcosServer.toClient("idCardShown", playerId, _src, {targetPlayer.identity.firstname, targetPlayer.identity.lastname:upper(), targetPlayer.identity.age})
    NarcosServer.toClient("serverReturnedCb", _src)
end)