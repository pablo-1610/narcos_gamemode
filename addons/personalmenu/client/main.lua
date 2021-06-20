---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [20/06/2021 23:43]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_KeysManager.addKey("F5", "Menu personnel", function()
    if currentState ~= NarcosEnums.GameStates.PLAYING then
        return
    end
    Narcos.toInternal("f5menu")
end)