---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [client] created at [21/05/2021 16:18]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient = {}

NarcosClient.warnVariator = "~r~"
NarcosClient.dangerVariator = "~y~"

Narcos.newRepeatingTask(function()
    if NarcosClient.warnVariator == "~r~" then NarcosClient.warnVariator = "~s~" else NarcosClient.warnVariator = "~r~" end
    if NarcosClient.dangerVariator == "~y~" then NarcosClient.dangerVariator = "~o~" else NarcosClient.dangerVariator = "~y~" end
end, nil, 0,650)

NarcosClient.toServer = function(eventName, ...)
    TriggerServerEvent("narcos:" .. Narcos.hash(eventName), ...)
end

NarcosClient.inputBox = function(TextEntry, ExampleText, MaxStringLenght, isValueInt)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        if isValueInt then
            local isNumber = tonumber(result)
            if isNumber then return result else return nil end
        end

        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

NarcosClient.advancedNotification = function(sender, subject, msg, textureDict, iconType)
    AddTextEntry('AutoEventAdvNotif', msg)
    BeginTextCommandThefeedPost('AutoEventAdvNotif')
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
end

NarcosClient.playAnim = function(dict, anim, flag, blendin, blendout, playbackRate, duration)
    if blendin == nil then blendin = 1.0 end
    if blendout == nil then blendout = 1.0 end
    if playbackRate == nil then playbackRate = 1.0 end
    if duration == nil then duration = -1 end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(1) end
    TaskPlayAnim(GetPlayerPed(-1), dict, anim, blendin, blendout, duration, flag, playbackRate, 0, 0, 0)
    RemoveAnimDict(dict)
end