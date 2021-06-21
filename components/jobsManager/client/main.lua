---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 04:29]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_JobsManager = {}

NarcosClient_JobsManager.registerJobMenu = function(job, menu)
    NarcosClient_JobsManager.menu[job] = menu
end

Narcos.netHandle("sideLoaded", function()
    NarcosClient.toServer("requestJobsLabels")
end)

NarcosClient_KeysManager.addKey("f6", "Menu des interactions job", function()
    if currentState ~= NarcosEnums.GameStates.PLAYING then
        return
    end
    if NarcosClient_JobsManager.menu[personnalData.player.cityInfos["job"].id] ~= nil then
        NarcosClient_JobsManager.menu[personnalData.player.cityInfos["job"].id]()
    end
end)