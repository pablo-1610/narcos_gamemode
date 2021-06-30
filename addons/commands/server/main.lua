---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:24]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

--[[
    Commandes console
--]]
---@param source number
---@param args table
NarcosServer.registerConsoleCommand("addJob", function(source, args)
    if #args ~= 2 then
        NarcosServer.trace("Utilisation: ^3addJob <name> <label>", Narcos.prefixes.err)
        return
    end
    local job, label = args[1], args[2]
    NarcosServer_JobsManager.createJob(job, label)
end)

NarcosServer.registerConsoleCommand("refreshPerms", function(source, args)
    if #args ~= 1 then
        NarcosServer.trace("Utilisation: ^3rankUpdatePerms <rang>", Narcos.prefixes.err)
        return
    end
    local rankId = args[1]
    if not NarcosServer_RanksManager.exists(rankId) then
        NarcosServer.trace("Ce rang n'existe pas !", Narcos.prefixes.err)
        return
    end
    ---@type Rank
    local rank = NarcosServer_RanksManager.get(rankId)
    rank:updatePermissions()
end)

--[[
    Commandes IG
--]]
---@param source number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("clearloadout", {"commands.clearloadout"}, function(source, player, args, isRcon)
    if #args ~= 1 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    ---@type Player
    local target = NarcosServer_PlayersManager.get(targetId)
    target:clearWeapons(function()
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, "Clear des armes effectué") end
        target:sendSystemMessage(NarcosEnums.Prefixes.INF, "Un membre du staff a supprimé vos armes")
    end)
end, "Utilisation: /clearloadout <id>")

---@param source number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("clearinventory", {"commands.clearinventory"}, function(source, player, args, isRcon)
    if #args ~= 1 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    ---@type Player
    local target = NarcosServer_PlayersManager.get(targetId)
    ---@type Inventory
    local inventory = NarcosServer_InventoriesManager.get(target:getLicense())
    inventory:clear(function()
        target:sendData(function()
            if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, "Clear de l'inventaire effectué") end
            target:sendSystemMessage(NarcosEnums.Prefixes.INF, "Un membre du staff a supprimé le contenu de votre inventaire")
        end)
    end)
end, "Utilisation: /clearloadout <id>")

---@param source number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("giveweapon", {"commands.giveweapon"}, function(source, player, args, isRcon)
    if #args ~= 3 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    ---@type Player
    local target = NarcosServer_PlayersManager.get(targetId)
    local weapon = args[2]:upper()
    local found = false
    for _,v in pairs(NarcosConfig_Server.availableWeapons) do
        if v == weapon then
            found = true
        end
    end
    if not found then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Cette arme n'existe pas !") end
        return
    end
    local ammount = (tonumber(args[3]) or 200)
    target:addWeapon(weapon, ammount, function()
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, "Don de l'arme effectuée") end
        target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Un membre du staff vous a fait don d'une arme (~o~%s~s~) avec ~o~%s ~s~balles"):format(weapon, ammount))
    end)
end, "Utilisation: /giveweapon <id> <arme> <munitions>")

---@param source number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("giveitem", {"commands.giveitem"}, function(source, player, args, isRcon)
    if #args ~= 3 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    ---@type Player
    local target = NarcosServer_PlayersManager.get(targetId)
    local itemId = args[2]
    if not NarcosServer_ItemsManager.exists(itemId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Cet item n'existe pas !") end
        return
    end
    local ammount = tonumber(args[3])
    if ammount == nil or ammount <= 0 then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Montant invalide") end
        return
    end
    ---@type Item
    local item = NarcosServer_ItemsManager.get(itemId)
    ---@type Inventory
    local inventory = target:getInventory()
    if inventory:canAddItem(itemId, ammount) then
        inventory:addItem(itemId, function()
            target:sendData(function()
                if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, ("Don de ~o~%s %s~s~ à %s effectué"):format(ammount, item.label, target.name)) end
                target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Un membre du staff vous a fait don de ~o~%s %s"):format(ammount, item.label))
            end)
        end, tonumber(ammount))
    else
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, ("Le joueur n'a pas assez de place pour accueillir ~o~%s %s"):format(ammount, item.label)) end
        return
    end
end, "Utilisation: /giveitem <id> <item> <quantité>")

---@param source number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("givemoney", {"commands.givemoney"}, function(source, player, args, isRcon)
    if #args ~= 2 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    local target = NarcosServer_PlayersManager.get(targetId)
    local ammount = tonumber(args[2])
    if ammount == nil or ammount < 0 then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Montant invalide") end
        return
    end
    local final = (target.cash + ammount)
    if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, ("Le joueur a désormais ~g~%s$"):format(NarcosServer.groupDigits(final))) end
    target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Votre argent a été définie à: ~g~%s$"):format(NarcosServer.groupDigits(final)))
    target:setCash(final)
end, "Utilisation: /givemoney <id> <montant>")

---@param source number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("setmoney", {"commands.setmoney"}, function(source, player, args, isRcon)
    if #args ~= 2 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    local target = NarcosServer_PlayersManager.get(targetId)
    local ammount = tonumber(args[2])
    if ammount == nil or ammount < 0 then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Montant invalide") end
        return
    end
    if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, ("Le joueur a désormais ~g~%s$"):format(NarcosServer.groupDigits(ammount))) end
    target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Votre argent a été définie à: ~g~%s$"):format(NarcosServer.groupDigits(ammount)))
    target:setCash(ammount)
end, "Utilisation: /setmoney <id> <montant>")

---@param source number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("setgroup", {"commands.setgroup"}, function(source, player, args, isRcon)
    if #args ~= 2 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    local target = NarcosServer_PlayersManager.get(targetId)
    local rankId = args[2]
    if not NarcosServer_RanksManager.exists(rankId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Ce rang n'existe pas") end
        return
    end
    target:setRankFromId(rankId, function(rank)
        target:sendData(function()
            if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, ("Le rang du joueur est désormais ~o~%s"):format(rank.label)) end
            target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Votre rang est désormais: ~o~%s"):format(rank.label))
        end)
    end)
end, "Utilisation: /setgroup <id> <rang>")

---@param _src number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("setjob", {"commands.setjob"}, function(_src, player, args, isRcon)
    if #args ~= 3 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    ---@type Player
    local target = NarcosServer_PlayersManager.get(targetId)
    local currentJobName, currentJobRank, currentJob = target.cityInfos["job"].id, target.cityInfos["job"].rank, NarcosServer_JobsManager.get(target.cityInfos["job"].id)
    if currentJobName == args[2] and currentJobRank == args[3] then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Vous avez déjà ce job !") end
        return
    end
end, "Utilisation: /setjob <id> <job> <rang>")

--[[
    if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, ("Le job du joueur est désormais ~y~%s ~s~(~y~grade "..rankId.."~s~)"):format(job.name)) end
    target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Votre job est désormais: ~y~%s ~s~(~y~grade "..rankId.."~s~)"):format(job.name))
--]]