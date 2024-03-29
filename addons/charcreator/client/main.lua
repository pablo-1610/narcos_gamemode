---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local camPos, cam = vector3(684.11, 571.66, 130.46), nil

RegisterCommand("fake", function()
    Narcos.toInternal("creatorInitialize")
end, false)

Narcos.netRegisterAndHandle("creatorInitialize", function()
    NarcosClient.PlayerHeler.spawnPlayer({x = 686.26, y = 577.86, z = 129.75, heading = 162.34}, true, function()
        PlayUrl("narcosCrea", "https://youtu.be/AZRbcVG6WEQ", 0.05, false)
    end, function()
        NarcosClient_SkinManager.loadSkin({
            ["arms"] = 15,
            ["tshirt_1"] = 15,
            ["torso_1"] = 15,
            ["shoes_1"] = 5,
            ["pants_1"] = 15
        })
        DoScreenFadeIn(6500)
    end)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    SetCamCoord(cam, camPos)
    PointCamAtCoord(cam,686.26, 577.86, 129.75+1.20)
    SetCamActive(cam, true)
    ClearFocus()
    RenderScriptCams(1,0,0,0,0)
    SetFocusPosAndVel(vector3(686.26, 577.86, 129.75), 0,0,0)
    SetCamFov(cam, 12.0)
    FreezeEntityPosition(PlayerPedId(), true)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GUARD_STAND", -1, false)
    NarcosClient_SyncManager.overrideTime(12,00)
    NarcosClient_SyncManager.overrideWeather("EXTRASUNNY")
    Narcos.toInternal("rpOverride", "builder", "Créé son personnage")
    NarcosClient.trace("Démarrage du créateur de personnage")
    Narcos.toInternal("creatorMenu")
end)

Narcos.netRegisterAndHandle("creatorExit", function(start, startHd)
    NarcosClient_SyncManager.stopOverrideBoth()
    Destroy("narcosCrea")
    RequestStreamedTextureDict("pablo")
    while not HasStreamedTextureDictLoaded("pablo") do Wait(1) end
    RenderScriptCams(0,0,0,0,0)
    NarcosClient.DrawHelper.showLoading("Bienvenue sur Los Narcos")
    PlayUrl("narcos", "https://youtu.be/4y8c1kk3gZA", 0.35, false)
    NarcosClient.PlayerHeler.freezePlayer(PlayerId(), true)
    SwitchOutPlayer(PlayerPedId(), 0, 1)
    local run, secElapsed, fadeIn = true, 0, 0
    Narcos.newThread(function()
        while fadeIn < 255 do
            fadeIn = fadeIn + 1
            Wait(7)
        end
    end)
    Narcos.newThread(function()
        while run do
            secElapsed = secElapsed + 1
            Wait(Narcos.second(1))
        end
    end)
    Narcos.newThread(function()
        local baseWidth = 0.3 -- Longueur
        local baseHeight = 0.03 -- Epaisseur
        local baseX = 0.5 -- gauche / droite ( plus grand = droite )
        local baseY = 1.04 -- Hauteur ( Plus petit = plus haut )
        while run do
            DrawSprite("pablo", "logo_base", 0.5, 0.5,0.3, 0.5, 0.0, 255, 255, 255, fadeIn)
            Wait(0)
        end
    end)
    Wait(20000)
    local playerPed = PlayerPedId()
    Narcos.newThread(function()
        while fadeIn > 0 do
            fadeIn = fadeIn - 1
            Wait(7)
        end
        NarcosClient.DrawHelper.showLoading(false)
        run = false
        RequestCollisionAtCoord(start.x, start.y, start.z)
        SetEntityHeading(PlayerPedId(), startHd)
        SetEntityCoordsNoOffset(PlayerPedId(), start.x, start.y, start.z, false, false, false, true)
        NarcosClient.PlayerHeler.freezePlayer(PlayerId(), true)
        SetEntityHeading(PlayerPedId(), startHd)
        ClearPedTasksImmediately(PlayerPedId())
        local time = GetGameTimer()
        while (not HasCollisionLoadedAroundEntity(PlayerPedId()) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end
        NarcosClient.PlayerHeler.freezePlayer(PlayerId(), false)
        SwitchInPlayer(PlayerPedId())
        currentState = NarcosEnums.GameStates.PLAYING
        Narcos.toInternal("playerOk")
    end)
    Wait(1800)
    while getVolume("narcos") > 0.0 do
        Wait(25)
        setVolume("narcos", (getVolume("narcos")-0.0006))
    end
    Narcos.toInternal("setSaver", true)
end)