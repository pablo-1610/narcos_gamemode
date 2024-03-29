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
        target:savePlayer()
        target:sendSystemMessage(NarcosEnums.Prefixes.INF, "Un membre du staff a supprimé vos armes")
    end)
end, "/clearloadout <id>")

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
            target:savePlayer()
            target:sendSystemMessage(NarcosEnums.Prefixes.INF, "Un membre du staff a supprimé le contenu de votre inventaire")
        end)
    end)
end, "/clearloadout <id>")

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
        target:savePlayer()
        target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Un membre du staff vous a fait don d'une arme (~o~%s~s~) avec ~o~%s ~s~balles"):format(weapon, ammount))
    end)
end, "/giveweapon <id> <arme> <munitions>")

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
                target:savePlayer()
                target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Un membre du staff vous a fait don de ~o~%s %s"):format(ammount, item.label))
            end)
        end, tonumber(ammount))
    else
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, ("Le joueur n'a pas assez de place pour accueillir ~o~%s %s"):format(ammount, item.label)) end
        return
    end
end, "/giveitem <id> <item> <quantité>")

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
    target:savePlayer()
    target:setCash(final)
end, "/givemoney <id> <montant>")

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
    target:savePlayer()
    target:setCash(ammount)
end, "/setmoney <id> <montant>")

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
            target:savePlayer()
            target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Votre rang est désormais: ~o~%s"):format(rank.label))
        end)
    end)
end, "/setgroup <id> <rang>")

---@param _src number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("setjobpos", {"commands.setjobpos"}, function(_src, player, args, isRcon)
    if isRcon then return end
    if #args ~= 2 then
        return
    end
    local job, positionId = args[1]:lower(), args[2]
    if not NarcosServer_JobsManager.exists(job) then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Ce job n'existe pas")
        return
    end
    job = NarcosServer_JobsManager.get(job)
    local positions = job.positions
    if not (positions[positionId:upper()]) then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Cette position n'existe pas")
        return
    end
    local pos = GetEntityCoords(GetPlayerPed(_src))
    positions[positionId:upper()].location = pos
    NarcosServer_MySQL.execute("UPDATE jobs SET positions = @positions WHERE name = @name", {
        ["positions"] = json.encode(positions),
        ["name"] = args[1]:lower()
    })
    player:sendSystemMessage(NarcosEnums.Prefixes.SUC, ("Position du job ~y~%s ~s~mise à jour"):format(job.label))
end, "/setjobpos <job> <id>")

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
    if not NarcosServer_JobsManager.exists(args[2]) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Ce job n'existe pas") end
        return
    end
    ---@type Job
    local newJob = NarcosServer_JobsManager.get(args[2])
    ---@type Job
    local currentJobName, currentJobRank, oldJob = target.cityInfos["job"].id, target.cityInfos["job"].rank, NarcosServer_JobsManager.get(target.cityInfos["job"].id)
    if currentJobName == args[2] and currentJobRank == tonumber(args[3]) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Vous avez déjà ce job !") end
        return
    end
    if tonumber(args[3]) <= 0 then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le grade doit être supérieur à 0") end
        return
    end
    if tonumber(args[3]) > NarcosServer.getTableLenght(newJob.ranks) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, ("Ce grade n'existe pas (~o~max %s~s~)"):format(NarcosServer.getTableLenght(newJob.ranks))) end
        return
    end
    target.cityInfos["job"].id = args[2]
    target.cityInfos["job"].rank = tonumber(args[3])
    oldJob:handlePlayerLeft(targetId, player)
    newJob:handlePlayerJoined(targetId, player)
    target:sendData(function()
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, ("Le job du joueur est désormais ~y~%s ~s~(~y~grade "..tonumber(args[3]).."~s~)"):format(newJob.name)) end
        target:savePlayer()
        target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Votre job est désormais: ~y~%s ~s~(~y~grade "..tonumber(args[3]).."~s~)"):format(newJob.name))
    end)
end, "/setjob <id> <job> <rang>")

---@param _src number
---@param isRcon boolean
NarcosServer.registerCommand("id", function(_src, player, _, isRcon)
    if isRcon then return end
    player:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Votre identifiant unique est le suivant: ~y~%s"):format(_src), _src)
end)

---@param _src number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("car", {"commands.car"}, function(_src, player, args, isRcon)
    if isRcon then return end
    if #args ~= 1 then return end
    local veh = CreateVehicle(GetHashKey(args[1]), GetEntityCoords(GetPlayerPed(_src)), 90.0, true, true)
    TaskWarpPedIntoVehicle(GetPlayerPed(_src), veh, -1)
end, "/car <modèle>")

---@param _src number
---@param player Player
---@param args table
NarcosServer.registerPermissionCommand("announce", {"commands.announce"}, function(_src, player, args)
    if #args <= 0 then
        return
    end
    NarcosServer.toAll("receiveAnnounce", table.concat(args, " "))
end, "/announce <message>")

NarcosServer.registerPermissionCommand("announce_clear", {"commands.announce"}, function()
    NarcosServer.toAll("receiveAnnounceStop")
end, "/announce_clear")