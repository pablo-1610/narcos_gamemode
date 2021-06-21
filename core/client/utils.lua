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

-- MenuHelper
NarcosClient.MenuHelper = {
    alert = nil,

    defineLabelString = function(valueToCheck)
        if valueToCheck ~= nil and valueToCheck ~= "" then
            return ("~g~%s"):format(valueToCheck)
        else
            return "~b~Définir ~s~→→"
        end
    end,

    defineLabelInt = function(valueToCheck, currency)
        if valueToCheck ~= nil then
            return ("~g~%s%s"):format(valueToCheck, (currency or ""))
        else
            return "~b~Définir ~s~→→"
        end
    end,

    greenIfTrue = function(bool)
        if bool then
            return "~g~"
        else
            return "~s~"
        end
    end
}


-- DrawHelper
NarcosClient.DrawHelper = {
    showLoading = function(message)
        if type(message) == "string" then
            Citizen.InvokeNative(0xABA17D7CE615ADBF, "STRING")
            AddTextComponentSubstringPlayerName(message)
            Citizen.InvokeNative(0xBD12F8228410D9B4, 3)
        else
            Citizen.InvokeNative(0xABA17D7CE615ADBF, "STRING")
            AddTextComponentSubstringPlayerName("")
            Citizen.InvokeNative(0xBD12F8228410D9B4, -1)
        end
    end,

    showBasicNotification = function(message)
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(0,1)
    end,

    showAdvancedNotification = function(sender, subject, msg, textureDict, iconType, sound)
        if sound then
            SetAudioFlag("LoadMPData", 1)
            PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", 1)
        end
        AddTextEntry('AutoEventAdvNotif', msg)
        BeginTextCommandThefeedPost('AutoEventAdvNotif')
        EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
    end,

    drawTexts = function(x, y, text, center, scale, rgb, font, justify)
        SetTextFont(font)
        SetTextScale(scale, scale)
        SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
        SetTextEntry("STRING")
        SetTextCentre(center)
        AddTextComponentString(text)
        EndTextCommandDisplayText(x,y)
    end
}

Narcos.netRegisterAndHandle("showNotification", showBasicNotification)
Narcos.netRegisterAndHandle("showAdvancedNotification", function(sender, subject, msg, textureDict, iconType, sound)
    if sound then
        SetAudioFlag("LoadMPData", 1)
        PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", 1)
    end
    AddTextEntry('AutoEventAdvNotif', msg)
    BeginTextCommandThefeedPost('AutoEventAdvNotif')
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
end)

-- PlayerHelper
NarcosClient.PlayerHeler = {
    freezePlayer = function(id, bool)
        local player = id
        SetPlayerControl(player, not bool, false)

        local ped = GetPlayerPed(player)

        if not bool then
            if not IsEntityVisible(ped) then
                SetEntityVisible(ped, true)
            end
            if not IsPedInAnyVehicle(ped) then
                SetEntityCollision(ped, true)
            end
            FreezeEntityPosition(ped, false)
            SetPlayerInvincible(player, false)
        else
            if IsEntityVisible(ped) then
                SetEntityVisible(ped, false)
            end
            SetEntityCollision(ped, false)
            FreezeEntityPosition(ped, true)
            SetPlayerInvincible(player, true)
            if not IsPedFatallyInjured(ped) then
                ClearPedTasksImmediately(ped)
            end
        end
    end,


    spawnPlayer = function(selectedSpawn, blind, beforeReveal, afterReveal)
        if blind then DoScreenFadeOut(0) end
        NarcosClient.PlayerHeler.freezePlayer(PlayerId(), true)
        NarcosClient.requestModel("mp_m_freemode_01")
        SetPlayerModel(PlayerId(), Narcos.hash("mp_m_freemode_01"))
        SetModelAsNoLongerNeeded(Narcos.hash("mp_m_freemode_01"))
        RequestCollisionAtCoord(selectedSpawn.x, selectedSpawn.y, selectedSpawn.z)
        local ped = PlayerId()
        SetEntityCoordsNoOffset(ped, selectedSpawn.x, selectedSpawn.y, selectedSpawn.z, false, false, false, true)
        NetworkResurrectLocalPlayer(selectedSpawn.x, selectedSpawn.y, selectedSpawn.z, selectedSpawn.heading, true, true, false)
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        ClearPlayerWantedLevel(PlayerId())
        local time = GetGameTimer()
        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end
        beforeReveal()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        NarcosClient.PlayerHeler.freezePlayer(PlayerId(), false)
        SetPedDefaultComponentVariation(PlayerPedId())
        afterReveal()
    end,

    getClosestPlayer = function()
        local players = GetActivePlayers()
        local coords = GetEntityCoords(PlayerPedId())
        local pCloset = nil
        local pClosetPos = nil
        local pClosetDst = nil
        for k,v in pairs(players) do
            if GetPlayerPed(v) ~= PlayerPedId() then
                local oPed = GetPlayerPed(v)
                local oCoords = GetEntityCoords(oPed)
                local dst = GetDistanceBetweenCoords(oCoords, coords, true)
                if pCloset == nil then
                    pCloset = v
                    pClosetPos = oCoords
                    pClosetDst = dst
                else
                    if dst < pClosetDst then
                        pCloset = v
                        pClosetPos = oCoords
                        pClosetDst = dst
                    end
                end
            end
        end

        return pCloset, pClosetDst
    end
}

function NarcosClient.DrawText3D(x, y, z, text, r, g, b)
    -- some useful function, use it if you want!
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.80 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- InputHelper
NarcosClient.InputHelper = {
    showBox = function(TextEntry, ExampleText, MaxStringLenght, isValueInt)
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
                if isNumber then
                    return result
                else
                    return nil
                end
            end

            return result
        else
            Wait(500)
            blockinput = false
            return nil
        end
    end,

    validateInputStringDefinition = function(valueToCheck)
        if not valueToCheck then return false end
        return (valueToCheck ~= nil and valueToCheck ~= "")
    end,

    validateInputStringRegex = function(valueToCheck, regex)
        if not valueToCheck then return false end
        return string.match(valueToCheck, regex)
    end,

    validateInputIntDefinition = function(valueToCheck, positive)
        local checkPositivity = true
        if not valueToCheck then return false end
        if positive then
            if valueToCheck < 0 then
                checkPositivity = false
            end
        end
        return (valueToCheck ~= nil and checkPositivity)
    end
}

-- Other
NarcosClient.warnVariator = "~r~"
NarcosClient.dangerVariator = "~y~"

Narcos.newRepeatingTask(function()
    if NarcosClient.warnVariator == "~r~" then
        NarcosClient.warnVariator = "~s~"
    else
        NarcosClient.warnVariator = "~r~"
    end
    if NarcosClient.dangerVariator == "~y~" then
        NarcosClient.dangerVariator = "~o~"
    else
        NarcosClient.dangerVariator = "~y~"
    end
end, nil, 0, 650)

NarcosClient.toServer = function(eventName, ...)
    TriggerServerEvent("narcos:" .. Narcos.hash(eventName), ...)
end

NarcosClient.requestModel = function(model)
    NarcosClient.trace(("En attente du modèle \"^3%s^7\""):format(model))
    model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    NarcosClient.trace("Chargement du modèle complété")
end

NarcosClient.trace = function(message)
    print(("[^1Los Narcos^7] ^7%s"):format(message))
end

NarcosClient.advancedNotification = function(sender, subject, msg, textureDict, iconType)
    AddTextEntry('AutoEventAdvNotif', msg)
    BeginTextCommandThefeedPost('AutoEventAdvNotif')
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
end

NarcosClient.playAnim = function(dict, anim, flag, blendin, blendout, playbackRate, duration)
    if blendin == nil then
        blendin = 1.0
    end
    if blendout == nil then
        blendout = 1.0
    end
    if playbackRate == nil then
        playbackRate = 1.0
    end
    if duration == nil then
        duration = -1
    end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), dict, anim, blendin, blendout, duration, flag, playbackRate, 0, 0, 0)
    RemoveAnimDict(dict)
end