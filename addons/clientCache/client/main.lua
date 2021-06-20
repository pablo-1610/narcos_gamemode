---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 01:05]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

clientCache = {}

Narcos.netRegisterAndHandle("clientCacheSetCache", function(index, value)
    clientCache[index] = value
end)

