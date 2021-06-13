---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 18:37]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_KeysManager = {}

NarcosClient_KeysManager.addKey = function(command, defaultKey, desc)
    RegisterKeyMapping(command, desc, "keyboard", defaultKey)
end