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
NarcosServer.registerPermissionCommand("givemoney", {"commands.setmoney"}, function(source, player, args, isRcon)
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

---@param source number
---@param player Player
---@param args table
---@param isRcon boolean
NarcosServer.registerPermissionCommand("setjob", {"commands.setjob"}, function(source, player, args, isRcon)
    if #args ~= 3 then
        return
    end
    local targetId = tonumber(args[1])
    if not NarcosServer_PlayersManager.exists(targetId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Le joueur n'est pas en ligne") end
        return
    end
    local target = NarcosServer_PlayersManager.get(targetId)
    local jobId = args[2]
    if not NarcosServer_JobsManager.exists(jobId) then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Ce job n'existe pas") end
        return
    end
    local job = NarcosServer_JobsManager.get(jobId)
    local rankId = tonumber(args[3])
    if job.ranks[rankId] == nil then
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.ERR, ("Le rang de ce job n'existe pas (%s max)"):format(#job.ranks)) end
        return
    end
    target:updateJob(target.cityInfos["job"].id, job, rankId, function()
        if not isRcon then player:sendSystemMessage(NarcosEnums.Prefixes.SUC, ("Le job du joueur est désormais ~y~%s ~s~(~y~grade "..rankId.."~s~)"):format(job.name)) end
        target:sendSystemMessage(NarcosEnums.Prefixes.INF, ("Votre job est désormais: ~y~%s ~s~(~y~grade "..rankId.."~s~)"):format(job.name))
    end)
end, "Utilisation: /setjob <id> <job> <rang>")