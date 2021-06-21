---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [16/06/2021 12:10]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_InventoriesManager = {}
NarcosServer_InventoriesManager.list = {}

NarcosServer_InventoriesManager.exists = function(inventoryIdentifier)
    return NarcosServer_InventoriesManager.list[inventoryIdentifier] ~= nil
end

NarcosServer_InventoriesManager.get = function(inventoryIdentifier)
    if not NarcosServer_InventoriesManager.exists(inventoryIdentifier) then
        return
    end
    return NarcosServer_InventoriesManager.list[inventoryIdentifier]
end

NarcosServer_InventoriesManager.getOrCreate = function(inventoryIdentifier, label, capacity, type)
    if NarcosServer_InventoriesManager.exists(inventoryIdentifier) then
        return NarcosServer_InventoriesManager.get(inventoryIdentifier)
    end
    MySQL.Async.fetchAll("SELECT * FROM inventories WHERE identifier = @a", {['a'] = inventoryIdentifier}, function(result)
        if result[1] then
            return Inventory(result[1].identifier, result[1].label, result[1].capacity, result[1].type, json.decode(result[1].content))
        else
            MySQL.Async.insert("INSERT INTO inventories (identifier, label, capacity, type, content) VALUES (@a,@b,@c,@d,@e)", {
                ['a'] = inventoryIdentifier,
                ['b'] = label,
                ['c'] = capacity,
                ['d'] = type,
                ['e'] = json.encode({})
            })
            return Inventory(inventoryIdentifier, label, capacity, type, {})
        end
    end)
end

NarcosServer_InventoriesManager.removeFromCache = function(inventoryIdentifier)
    NarcosServer.trace(("Inventaire supprimé du cache: ^1%s"):format(inventoryIdentifier), Narcos.prefixes.dev)
    NarcosServer_InventoriesManager.list[inventoryIdentifier] = nil
end

Narcos.netRegisterAndHandle("inventoryUseItem", function(item)
    local _src = source
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    ---@type Inventory
    local inventory = NarcosServer_InventoriesManager.get(player:getLicense())
    inventory:removeItem(item, function()
        player:sendData(function()
            NarcosServer.toClient("serverReturnedCb", _src)
        end)
    end)
end)

Narcos.netRegisterAndHandle("inventoryGiveItem", function(item, qty, targetId)
    qty = tonumber(qty)
    local _src = source
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    ---@type Player
    local target = NarcosServer_PlayersManager.get(targetId)
    if not target then
        NarcosServer_ErrorsManager.die(NarcosEnums.Errors.TARGET_INVALID, ("inventoryGive entre %s et %s"):format(_src, targetId))
    end
    ---@type Inventory
    local playerInventory = NarcosServer_InventoriesManager.get(player:getLicense())
    ---@type Inventory
    local targetInventory = NarcosServer_InventoriesManager.get(target:getLicense())

    playerInventory:removeItem(item, function()
        targetInventory:addItem(item, function()
            player:sendData()
            target:sendData()
            player:showAdvancedNotification("Inventaire","~g~Objet(s) donné",("Vous avez donné ~o~%sx %s ~s~!"):format(qty, NarcosServer_ItemsManager.getItemLabel(item)),"CHAR_ARTHUR",1)
            target:showAdvancedNotification("Inventaire","~g~Objet(s) reçu",("Vous avez reçu ~o~%sx %s ~s~!"):format(qty, NarcosServer_ItemsManager.getItemLabel(item)),"CHAR_ARTHUR",1)
            NarcosServer.toClient("serverReturnedCb", _src)
            NarcosServer.toClient("serverReturnedCb", targetId)
        end, qty)
    end, qty)

    --[[
    if targetInventory:canAddItem(item, qty) then
        playerInventory:removeItem(item, function()
            targetInventory:addItem(item, function()
                player:sendData()
                target:sendData()
                player:showAdvancedNotification("Inventaire","~g~Objet(s) donné",("Vous avez donné ~o~%sx %s ~s~!"):format(qty, NarcosServer_ItemsManager.getItemLabel(item)),"CHAR_ARTHUR",1)
                target:showAdvancedNotification("Inventaire","~g~Objet(s) reçu",("Vous avez reçu ~o~%sx %s ~s~!"):format(qty, NarcosServer_ItemsManager.getItemLabel(item)),"CHAR_ARTHUR",1)
                NarcosServer.toClient("serverReturnedCb", _src)
                NarcosServer.toClient("serverReturnedCb", targetId)
            end, qty)
        end, qty)
    else
        player:showAdvancedNotification("Inventaire","~r~Action impossible","La personne n'a pas assez de place dans son inventaire","CHAR_ARTHUR",1)
    end
    --]]
end)

Narcos.netHandle("sideLoaded", function()
    MySQL.Async.fetchAll("SELECT * FROM inventories WHERE type != 1", {}, function(result)
        for k,v in pairs(result) do
            Inventory(v.identifier, v.label, v.capacity, v.type, json.decode(v.content))
        end
    end)
end)