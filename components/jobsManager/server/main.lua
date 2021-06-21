---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 04:29]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_JobsManager = {}
NarcosServer_JobsManager.list = {}

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
        ranks[position] = {label = rankLabel.label, permissions = rankPerms}
    end
    MySQL.Async.insert("INSERT INTO jobs (name, label, money, ranks, positions, type) VALUES(@a, @b, @c, @d, @e, @f)", {
        ['a'] = name,
        ['b'] = label,
        ['c'] = NarcosConfig_Server.baseBuilderMoney,
        ['d'] = json.encode(ranks),
        ['e'] = json.encode(positions),
        ['f'] = 3
    }, function()
        NarcosServer.trace(("Job créé avec succès (^2%s^7)"):format(label), Narcos.prefixes.succes)
        Job(name, label, NarcosConfig_Server.baseBuilderMoney, ranks, positions, 3)
    end)
end

Narcos.netRegisterAndHandle("requestJobsLabels", function()
    local _src = source
    local labels = {}
    for k, v in pairs(NarcosServer_JobsManager.list) do
        labels[k] = v.label
    end
    labels[-1] = "Chomeur"
    NarcosServer.toClient("clientCacheSetCache", _src, "jobsLabels", labels)
end)

Narcos.netHandle("sideLoaded", function()
    MySQL.Async.fetchAll("SELECT * FROM jobs", {}, function(result)
        local tot = 0
        for k,v in pairs(result) do
            tot = (tot + 1)
            Job(v.name, v.label, v.money, json.decode(v.ranks), json.decode(v.positions), v.type)
        end
        NarcosServer.trace(("Enregistrement de ^3%s ^7jobs"):format(tot), Narcos.prefixes.dev)
    end)
end)