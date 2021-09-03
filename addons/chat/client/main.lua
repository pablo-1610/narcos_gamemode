---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [22/06/2021 23:01]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:client:ClearChat')
RegisterNetEvent('__cfx_internal:serverPrint')
RegisterNetEvent('_chat:messageEntered')


NarcosClient_Chat = {}
NarcosClient_Chat.commands = {}

local chatInputActive, chatInputActivating, chatHidden, chatLoaded = false, false, true, false

Narcos.netHandle("sideLoaded", function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)
    NarcosClient.toServer("chatRequestAutocompletion")
end)

Narcos.netRegisterAndHandle("chatCbAutocompletion", function(autocompletion)
    NarcosClient.trace("Autocomplétion du chat reçue")
    for command,v in pairs(autocompletion) do
        NarcosClient.trace(("-> %s"):format(command))
        NarcosClient_Chat.commands[command] = v
    end
    NarcosClient_Chat.refreshCommands()
end)

---addSuggestions
---@public
---@param suggestions table
NarcosClient_Chat.addSuggestions = function(suggestions)
    for _, suggestion in ipairs(suggestions) do
        SendNUIMessage({
            type = 'ON_SUGGESTION_ADD',
            suggestion = suggestion
        })
    end
end

---setCommandInfos
---@public
---@param command string
---@param infos string
NarcosClient_Chat.setCommandInfos = function(command, infos)
    if not NarcosClient_Chat.commands[command] then
        return
    end
    NarcosClient_Chat.commands[command].help = infos
end

---refreshCommands
---@public
NarcosClient_Chat.refreshCommands = function()
    local suggestions = {}
    for command, v in pairs(NarcosClient_Chat.commands) do
        table.insert(suggestions, { name = '/' .. command, help = (("Utilisation: %s"):format(v.help) or ''), staff = v.staff })
    end
    NarcosClient_Chat.addSuggestions(suggestions)
end

Narcos.netHandleBasic('chat:addMessage', function(message)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = message
    })
end)

NarcosClient_KeysManager.addKey("t", "Fenêtre de chat", function()
    if currentState ~= NarcosEnums.GameStates.PLAYING then
        return
    end
    if chatInputActive then
        return
    end
    NarcosClient_Chat.refreshCommands()
    chatInputActive = true
    chatInputActivating = true
    SendNUIMessage({
        type = 'ON_OPEN'
    })
    Narcos.newThread(function()
        while chatInputActive do
            Wait(0)
            if not IsControlPressed(0, 245) then
                SetNuiFocus(true)
                chatInputActivating = false
            end
        end
        chatInputActive = false
        SetNuiFocus(false)
    end)
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false
    if not data.canceled then
        local id = PlayerId()
        local r, g, b = 0, 0x99, 255
        if data.message:sub(1, 1) == '/' then
            ExecuteCommand(data.message:sub(2))
        end
    end
    SetNuiFocus(false)
    cb('ok')
end)