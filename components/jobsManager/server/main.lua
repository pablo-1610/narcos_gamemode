---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 04:29]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local managerWatcher = {}

NarcosServer_JobsManager = {}
NarcosServer_JobsManager.list = {}
NarcosServer_JobsManager.precise = {}

---@param job Job
NarcosServer_JobsManager.updateManagerWatchers = function(job)
    job:getEmployeesSorted(function(employees)
        for source, suscribedJob in pairs(managerWatcher) do
            if suscribedJob == job.name then
                NarcosServer.toClient("managerReceivedUpdate", source, employees, job.ranks)
            end
        end
    end)
end

NarcosServer_JobsManager.exists = function(jobName)
    return (NarcosServer_JobsManager.list[jobName] ~= nil)
end

NarcosServer_JobsManager.get = function(jobName)
    if not NarcosServer_JobsManager.exists(jobName) then
        return
    end
    return NarcosServer_JobsManager.list[jobName]
end

NarcosServer_JobsManager.createJob = function(name, label)
    local ranks = {}
    local positions = NarcosConfig_Server.baseBuilderPositions
    for position, rankLabel in pairs(NarcosConfig_Server.baseBuilderRank) do
        local rankPerms = {}
        for k,v in pairs(NarcosEnums.Permissions) do
            rankPerms[k] = false
        end
        if position == 1 then
            for k, v in pairs(rankPerms) do
                rankPerms[k] = true
            end
        end
        ranks[position] = {label = rankLabel.label, permissions = rankPerms, outfit = {}, salary = 1500}
    end
    NarcosServer_MySQL.insert("INSERT INTO jobs (name, label, money, history, ranks, positions, type) VALUES(@a, @b, @c, @hist, @d, @e, @f)", {
        ['a'] = name,
        ['b'] = label,
        ['c'] = NarcosConfig_Server.baseBuilderMoney,
        ['hist'] = json.encode({}),
        ['d'] = json.encode(ranks),
        ['e'] = json.encode(positions),
        ['f'] = 3
    }, function()
        NarcosServer.trace(("Job créé avec succès (^2%s^7)"):format(label), Narcos.prefixes.succes)
        Job(name, label, NarcosConfig_Server.baseBuilderMoney, ranks, positions, 3)
        local ranksLabels = {}
        local labels = {}
        for k, v in pairs(NarcosServer_JobsManager.list) do
            if not ranksLabels[k] then ranksLabels[k] = {} end
            for rankId, rankData in pairs(v.ranks) do
                ranksLabels[k][rankId] = rankData.label
            end
            labels[k] = v.label
        end
        NarcosServer.toAll("clientCacheSetCache", "jobsLabels", labels)
        NarcosServer.toAll("clientCacheSetCache", "jobsRanksLabels", ranksLabels)
    end)
end

Narcos.netRegisterAndHandle("managerSubscribe", function(jobName)
    local _src = source
    NarcosServer.trace(("%s s'est subscribe au manager ^3%s^7"):format(GetPlayerName(_src), jobName), Narcos.prefixes.sync)
    managerWatcher[_src] = jobName
end)

Narcos.netRegisterAndHandle("managerUnSubscribe", function()
    local _src = source
    NarcosServer.trace(("%s s'est unsuscribe des manager"):format(GetPlayerName(_src)), Narcos.prefixes.sync)
    managerWatcher[_src] = nil
end)

Narcos.netRegisterAndHandle("requestJobsLabels", function()
    local _src = source
    local ranksLabels = {}
    local labels = {}
    for k, v in pairs(NarcosServer_JobsManager.list) do
        if not ranksLabels[k] then ranksLabels[k] = {} end
        for rankId, rankData in pairs(v.ranks) do
            ranksLabels[k][rankId] = rankData.label
        end
        labels[k] = v.label
    end
    NarcosServer.toClient("clientCacheSetCache", _src, "jobsRanksLabels", ranksLabels)
    NarcosServer.toClient("clientCacheSetCache", _src, "jobsLabels", labels)
end)

Narcos.netRegisterAndHandle("setJobRankSalary", function(jobName, args)
    local _src = source
    if not NarcosServer_PlayersManager.exists(_src) then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("setJobRankSalary %s"):format(_src), _src)
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    ---@type Job
    local job = NarcosServer_JobsManager.get(jobName)
    if not player.cityInfos["job"].id == job then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Une erreur est survenue")
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    -- SECURITY
    ---@type Job
    local playerJob = NarcosServer_JobsManager.get(player.cityInfos["job"].id)
    ---@type Rank
    local playerRank = playerJob.ranks[player.cityInfos["job"].rank]
    if(not playerRank:havePermission("MANAGE") or not playerRank:havePermission("ROLES")) then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Vous n'avez pas la permission de faire cette action, les permissions ont peut être été modifiées pendant votre utilisation")
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    --
    ---@type JobRank
    local rank = job.ranks[args[1]]
    if not rank then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Une erreur est survenue")
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    if args[1] == 1 then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Vous ne pouvez pas changer le boss")
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    local newSalary = args[2]
    job.ranks[args[1]].salary = newSalary
    NarcosServer_MySQL.execute("UPDATE jobs SET ranks = @ranks WHERE name = @name", {
        ["ranks"] = json.encode(job.ranks),
        ["name"] = jobName
    })
    NarcosServer_JobsManager.updateManagerWatchers(job)
    player:sendSystemMessage(NarcosEnums.Prefixes.SUC, "Modification effectuée")
    NarcosServer.toClient("serverReturnedCb", _src)
end)

Narcos.netRegisterAndHandle("deleteJobRank", function(jobName, args)
    local _src = source
    if not NarcosServer_PlayersManager.exists(_src) then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("deleteJobRank %s"):format(_src), _src)
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    ---@type Job
    local job = NarcosServer_JobsManager.get(jobName)
    if not player.cityInfos["job"].id == job then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Une erreur est survenue")
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    -- SECURITY
    ---@type Job
    local playerJob = NarcosServer_JobsManager.get(player.cityInfos["job"].id)
    ---@type Rank
    local playerRank = playerJob.ranks[player.cityInfos["job"].rank]
    if(not playerRank:havePermission("MANAGE") or not playerRank:havePermission("ROLES")) then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Vous n'avez pas la permission de faire cette action, les permissions ont peut être été modifiées pendant votre utilisation")
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    --
    ---@type JobRank
    local rank = job.ranks[args[1]]
    if not rank then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Une erreur est survenue")
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    if args[1] == 1 then
        player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Vous ne pouvez pas supprimer le boss")
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    local fakeRanks = job.ranks
    fakeRanks[args[1]] = nil
    -- DELETE
    for rankId, rankData in pairs(job.ranks) do
        if rankId > args[1] then
            fakeRanks[rankId] = nil
            fakeRanks[rankId-1] = rankData
        end
    end
    NarcosServer_MySQL.execute("UPDATE jobs SET ranks = @ranks WHERE name = @name", {
        ["ranks"] = json.encode(job.ranks),
        ["name"] = jobName
    })
    NarcosServer_MySQL.execute("DELETE FROM job_employees WHERE job_id = @job_id AND rank = @rank", {
        ["job_id"] = jobName,
        ["rank"] = args[1]
    })
    NarcosServer_MySQL.query("SELECT identifier, cityInfos FROM job_employees JOIN players ON job_employees.identifier = players.license WHERE job_id = @job_id AND job_employees.rank = @rank", {
        ["job_id"] = jobName,
        ["rank"] = args[1]
    }, function(result)
        local i = 0
        for k, data in pairs(result) do
            i = i + 1
            ---@param foundPlayer Player
            NarcosServer_PlayersManager.findByIdentifier(data.identifier, function(foundPlayer)
                local currentCity = json.decode(data.cityInfos)
                if not foundPlayer then
                    currentCity["job"] = NarcosConfig_Server.baseCityInfos["job"]
                    NarcosServer_MySQL.execute("UPDATE players SET ranks = @ranks WHERE license = @license", {
                        ["ranks"] = json.encode(currentCity),
                        ["license"] = data.identifier
                    })
                else
                    foundPlayer.cityInfos["job"] = NarcosConfig_Server.baseCityInfos["job"]
                    ---@type Job
                    local previousJob = NarcosServer_JobsManager.get(jobName)
                    previousJob:handlePlayerLeft(foundPlayer.source, foundPlayer)
                    foundPlayer:sendSystemMessage(NarcosEnums.Prefixes.INF, "Votre rang a été supprimé de votre job, vous avez donc été viré. Veuillez contacter un des responsable de l'entreprise")
                    foundPlayer:sendData(function()
                        foundPlayer:savePlayer()
                    end)
                end
            end)
        end
        job.ranks = fakeRanks
        NarcosServer_JobsManager.updateManagerWatchers(job)
        player:sendSystemMessage(NarcosEnums.Prefixes.SUC, "Modification effectuée")
        player:sendSystemMessage(NarcosEnums.Prefixes.INF, ("%s personnes ont été destituées"):format(i))
        NarcosServer.toClient("serverReturnedCb", _src)
    end)
end)

Narcos.netRegisterAndHandle("jobGarageOut", function(model)
    local _src = source
    if not NarcosServer_PlayersManager.exists(_src) then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("jobGarageOut sur le model %s"):format(model), _src)
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    ---@type Job
    local job = NarcosServer_JobsManager.get(player.cityInfos["job"].id)
    if not job then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.MAJOR_VAR_NO_EXISTS, ("job est nul sur jobGarageOut model %s"):format(model), _src)
    end
    if not NarcosServer_JobsManager.precise[job.name] or not NarcosServer_JobsManager.precise[job.name].garageVehicles[model:lower()] then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.MAJOR_VAR_NO_EXISTS, ("aucun veh sur jobGarageOut model %s"):format(model), _src)
    end
    local out = NarcosServer_JobsManager.precise[job.name].vehiclesOut[math.random(1, #NarcosServer_JobsManager.precise[job.name].vehiclesOut)]
    local veh = CreateVehicle(GetHashKey(model:lower()), out.pos, out.heading, true, true)
    while veh == nil do Wait(1) end
    local rgb = NarcosServer_JobsManager.precise[job.name].garageVehicles[model:lower()].color
    SetVehicleCustomPrimaryColour(veh, rgb[1], rgb[2], rgb[3])
    SetVehicleCustomSecondaryColour(veh, rgb[1], rgb[2], rgb[3])
    TaskWarpPedIntoVehicle(GetPlayerPed(_src), veh, -1)
    player:sendSystemMessage("~g~Succès", "Votre véhicule de travail a été sorti, bonne route !")
    NarcosServer.toClient("serverReturnedCb", _src)
end)

Narcos.netHandle("sideLoaded", function()
    NarcosServer_MySQL.query("SELECT * FROM jobs", {}, function(result)
        local tot = 0
        for k,v in pairs(result) do
            tot = (tot + 1)
            Job(v.name, v.label, v.money, json.decode(v.ranks), json.decode(v.positions), v.type)
        end
        NarcosServer.trace(("Enregistrement de ^3%s ^7jobs"):format(tot), Narcos.prefixes.dev)
        Narcos.toInternal("jobsLoaded")
    end)
end)