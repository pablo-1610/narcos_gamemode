---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [27/05/2021 14:00]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_DiscordRpManager = {}

local taskId, running = nil, false

NarcosClient_DiscordRpManager.invokeRpc = function()
    NarcosClient.trace("Initialisation de la Rich Presence")
    if running then
        return
    end
    running = true
    taskId = Narcos.newRepeatingTask(function()
        SetDiscordAppId(847445071015051264)
        SetRichPresence("Los Narcos")
        SetDiscordRichPresenceAsset("narcos")
        SetDiscordRichPresenceAssetText("Découvrez le monde des narcos")
        SetDiscordRichPresenceAssetSmall("base")
        SetDiscordRichPresenceAssetSmallText("Los Narcos v1.01 Pre-Release")
    end, function()
        NarcosClient.trace("La rich présence a été détruite.")
        running, taskId = false, nil
    end, 5, 5)
end