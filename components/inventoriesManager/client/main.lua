---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [16/06/2021 12:11]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_InventoriesManager = {}
NarcosClient_InventoriesManager.usable = {}

NarcosClient_InventoriesManager.isUsable = function(item)
    return NarcosClient_InventoriesManager.usable[item] ~= nil
end

NarcosClient_InventoriesManager.registerUsable = function(item, onUse)
    NarcosClient_InventoriesManager.usable[item] = onUse
end

NarcosClient_InventoriesManager.give = function(item, qty, serverId)
    NarcosClient.toServer("inventoryGiveItem", item, qty, serverId)
end

NarcosClient_InventoriesManager.use = function(item)
    if not NarcosClient_InventoriesManager.isUsable(item) then
        return
    end
    NarcosClient.toServer("inventoryUseItem", item)
    NarcosClient_InventoriesManager.usable[item]()
end