---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [16/06/2021 11:55]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_ItemsManager = {}
NarcosClient_ItemsManager.onUse = {}

NarcosClient_ItemsManager.setUsable = function(name, action)
    NarcosClient_ItemsManager.onUse[name] = action
end