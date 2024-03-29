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
    NarcosServer_MySQL.query("SELECT * FROM ranks", {}, function(result)
        local tot = 0
        for k,v in pairs(result) do
            tot = (tot + 1)
            local perm = json.decode(v.permissions)
            Rank(v.id, v.label, v.color, perm)
            for _,permission in pairs(perm) do
                --print(("[%s]: %s"):format(v.label, permission))
            end
        end
        NarcosServer.trace(("Enregistrement de ^3%s ^7grades"):format(tot), Narcos.prefixes.dev)
    end)
end)