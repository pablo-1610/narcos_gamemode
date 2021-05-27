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

local taskId, running, id, info, buttons, image = nil, false, 0, "", {}, ""

NarcosClient_DiscordRpManager.setImageOverride = function(newVal)
    image = newVal
end

NarcosClient_DiscordRpManager.setTextOverride = function(newVal)
    info = newVal
end

NarcosClient_DiscordRpManager.destroy = function()
    Narcos.cancelTaskNow(taskId)
end

NarcosClient_DiscordRpManager.invokeRpc = function(data)
    NarcosClient.trace("Initialisation: Discord Rich Presence")
    if running then
        return
    end
    id, info, buttons, image, running = data.id, data.text, data.buttons, data.image, true
    taskId = Narcos.newRepeatingTask(function()
        SetDiscordAppId(id)
        SetRichPresence(info)
        NarcosClient.trace(image)
        SetDiscordRichPresenceAsset(image)
        SetDiscordRichPresenceAssetText(info)
        SetDiscordRichPresenceAssetSmall("base")
        SetDiscordRichPresenceAssetSmallText("Los Narcos v1.01 Dev")
        for k, v in pairs(buttons) do
            SetDiscordRichPresenceAction((k - 1), v[1], v[2])
        end
    end, function()
        NarcosClient.trace("La rich présence a été détruite.")
        running, taskId = false, nil
    end, 5, Narcos.second(10))
end