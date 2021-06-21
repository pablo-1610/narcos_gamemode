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
            Job(v.name, v.label, json.decode(v.ranks), json.decode(v.positions), v.type)
        end
        NarcosServer.trace(("Enregistrement de ^3%s ^7jobs"):format(tot), Narcos.prefixes.dev)
    end)
end)