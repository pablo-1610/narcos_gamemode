---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 16:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

uniqueId = 0

SetRoutingBucketPopulationEnabled(0, NarcosConfig_Server.populationEnabled)
SetRoutingBucketEntityLockdownMode()

Narcos.newThread(function()
    Narcos.toInternal("sideLoaded")
    SetMapName("Ville de Los Narcos")
    SetGameType("RolePlay Narcos")
end)

Narcos.netHandleBasic("onMySQLConnected", function()
    NarcosServer.trace("Connection base de donnée effectuée", Narcos.prefixes.succes)
end)