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

NarcosServer.getTableLenght = function(table)
    local tot = 0
    for k,v in pairs(table) do
        tot = (tot + 1)
    end
    return tonumber(tot)
end

NarcosServer.groupDigits = function(value)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. "."):reverse()) .. right
end

NarcosServer.registerConsoleCommand = function(command, func)
    RegisterCommand(command, function(_src, args)
        if _src ~= 0 then
            return
        end
        func(_src, args)
    end, false)
end

NarcosServer.registerPermissionCommand = function(command, permissions, func, help)
    NarcosServer_Chat.setCommand(command, help, (#permissions>0))
    RegisterCommand(command, function(_src, args)
        if _src == 0 then
            NarcosServer.webhook(("Console: /%s %s"):format(command:lower(),json.encode(args)), "orange", NarcosConfig_Server.staffWebhook)
            func(_src, nil, args, true)
            return
        end
        if not NarcosServer_PlayersManager.exists(_src) then
            NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("permissionCommand (%s) - %s"):format(command, _src), _src)
        end
        ---@type Player
        local player = NarcosServer_PlayersManager.get(_src)
        ---@type Rank
        local rank = player.rank
        if rank:havePermissions(permissions) then
            NarcosServer.webhook(("[%s] %s: /%s %s"):format(player.id, player.name, command:lower(),json.encode(args)), "grey", NarcosConfig_Server.staffWebhook)
            func(_src, player, args, false)
        else
            player:sendSystemMessage("~r~Erreur","Vous n'avez pas la permission de faire cette action !")
        end
    end)
end

NarcosServer.registerCommand = function(command, func, help)
    NarcosServer_Chat.setCommand(command, help, false)
    RegisterCommand(command, function(_src, args)
        if _src == 0 then
            NarcosServer.webhook(("Console: /%s %s"):format(command:lower(),json.encode(args)), "orange", NarcosConfig_Server.staffWebhook)
            func(_src, nil, args, true)
            return
        end
        if not NarcosServer_PlayersManager.exists(_src) then
            NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("permissionCommand (%s) - %s"):format(command, _src), _src)
        end
        ---@type Player
        local player = NarcosServer_PlayersManager.get(_src)
        func(_src, player, args, false)
    end)
end

NarcosServer.getIdentifiers = function(source)
    local identifiers = {}
    local playerIdentifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(playerIdentifiers) do
        local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
        identifiers[before] = playerIdentifiers[_]
    end
    return identifiers
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

