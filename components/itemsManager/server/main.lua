---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [16/06/2021 11:55]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_ItemsManager = {}
NarcosServer_ItemsManager.list = {}

NarcosServer_ItemsManager.exists = function(itemName)
    return NarcosServer_ItemsManager.list[itemName] ~= nil
end

NarcosServer_ItemsManager.get = function(itemName)
    if not NarcosServer_ItemsManager.exists(itemName) then
        return
    end
    return NarcosServer_ItemsManager.list[itemName]
end

NarcosServer_ItemsManager.getItemWeight = function(itemName)
    if not NarcosServer_ItemsManager.exists(itemName) then
        return
    end
    ---@type Item
    local item = NarcosServer_ItemsManager.get(itemName)
    return item.weight
end

Narcos.netHandle("sideLoaded", function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        local tot = 0
        for k,v in pairs(result) do
            tot = (tot + 1)
            Item(v.name, v.label, v.weight)
        end
        NarcosServer.trace(("Enregistrement de ^3%s ^7items"):format(tot), Narcos.prefixes.dev)
    end)
end)