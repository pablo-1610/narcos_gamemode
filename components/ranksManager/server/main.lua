---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 18:07]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_RanksManager = {}
NarcosServer_RanksManager.list = {}

NarcosServer_RanksManager.exists = function(rankId)
    return (NarcosServer_RanksManager.list[rankId] ~= nil)
end

NarcosServer_RanksManager.get = function(rankId, cantFail)
    if cantFail then
        return (NarcosServer_RanksManager.list[rankId] or NarcosServer_RanksManager.list[NarcosConfig_Server.defaultRank])
    else
        return NarcosServer_RanksManager.list[rankId]
    end
end

Narcos.netHandle("sideLoaded", function()
    MySQL.Async.fetchAll("SELECT * FROM ranks", {}, function(result)
        for k,v in pairs(result) do
            Rank(v.id, v.label, v.color, json.decode(v.permissions))
        end
    end)
end)