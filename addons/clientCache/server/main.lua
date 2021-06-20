---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 01:05]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netHandle("sendCaches", function(_src)
    local items = {}
    for k,v in pairs(NarcosServer_ItemsManager.list) do
        items[k] = v.label
    end
    NarcosServer.toClient("clientCacheSetCache", _src, "itemsLabel", items)
end)