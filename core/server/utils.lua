---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [utils] created at [21/05/2021 16:16]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer = {}

NarcosServer.toClient = function(eventName, targetId, ...)
    TriggerClientEvent("narcos:" .. Narcos.hash(eventName), targetId, ...)
end

NarcosServer.toAll = function(eventName, ...)
    TriggerClientEvent("narcos:" .. Narcos.hash(eventName), -1, ...)
end

NarcosServer.kick = function(_src, reason)
    DropPlayer(_src, ("[Los Narcos] Vous venez de vous faire expulser du serveur: \"%s\" !"):format(reason))
end

NarcosServer.registerConsoleCommand = function(command, func)
    RegisterCommand(command, function(source,args)
        if source ~= 0 then return end
        func(source, args)
    end, false)
end

NarcosServer.getLicense = function(source)
    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
    return ""
end

NarcosServer.trace = function(message, prefix)
    print("[^1Los Narcos^7] (" .. prefix .. "^7) " .. message .. "^7")
end

local webhookColors = {
    ["red"] = 16711680,
    ["green"] = 56108,
    ["grey"] = 8421504,
    ["orange"] = 16744192
}

NarcosServer.webhook = function(message, color, url)
    local DiscordWebHook = url
    local embeds = {
        {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = webhookColors[color],
            ["footer"] = {
                ["text"] = "Narcos Logs",
            },
        }
    }
    PerformHttpRequest(DiscordWebHook, function(err, text, headers)
    end, 'POST', json.encode({ username = "Narcos Logs", embeds = embeds }), { ['Content-Type'] = 'application/json' })
end