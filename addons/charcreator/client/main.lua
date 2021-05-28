---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local initialPosition = {vec = vector3(686.26, 577.86, 129.75), heading = 162.34}
local camPos, cam = vector3(684.11, 571.66, 130.46), nil

Narcos.netRegisterAndHandle("creatorStarts", function()
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(1500)
    Narcos.toInternal("rpOverride", "builder", "Créé son personnage")
    NarcosClient.trace("Démarrage du créateur de personnage")
    DoScreenFadeOut(3000)
    while not IsScreenFadedOut() do Wait(1) end
    SetEntityCoords(PlayerPedId(), initialPosition.vec, false, false, false, false)
    SetEntityHeading(PlayerPedId(), initialPosition.heading)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    SetCamCoord(cam, camPos)
    PointCamAtCoord(cam,initialPosition.vec.x, initialPosition.vec.y, initialPosition.vec.z+1.20)
    SetCamActive(cam, true)
    ClearFocus()
    RenderScriptCams(1,0,0,0,0)
    SetFocusPosAndVel(initialPosition.vec, 0,0,0)
    SetCamFov(cam, 12.0)
    DoScreenFadeIn(3500)
    Wait(1500)
    Narcos.toInternal("creatorMenu")
end)

Narcos.netHandle("creatorExit", function()
    RequestStreamedTextureDict("pablo")
    while not HasStreamedTextureDictLoaded("pablo") do Wait(1) end
    RenderScriptCams(0,0,0,0,0)
    NarcosClient.DrawHelper.showLoading("Bienvenue sur Los Narcos")
    PlayUrl("narcos", "https://youtu.be/4y8c1kk3gZA", 0.5, false)
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
    RequestCollisionAtCoord(2614.53,2920.02,40.42)
    SetEntityCoordsNoOffset(PlayerPedId(), 2614.53,2920.02,40.42, false, false, false)
    SetEntityHeading(PlayerPedId(), 57.27)
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        local playerCoords = GetEntityCoords(playerPed)
        local playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
        local formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
        TriggerServerEvent('narcos:45968912', formattedCoords)
    end
    Narcos.newThread(function()
        while fadeIn > 0 do
            fadeIn = fadeIn - 1
            Wait(7)
        end
        NarcosClient.DrawHelper.showLoading(false)
        run = false
        SwitchInPlayer(PlayerPedId())
    end)
    Wait(1300)
    while getVolume("narcos") > 0.0 do
        Wait(25)
        setVolume("narcos", (getVolume("narcos")-0.0008))
    end
    Narcos.toInternal("rpSetToDefault")
end)

Narcos.netRegisterAndHandle("creatorSetBaseSkin", function(skin, tenue)
    Wait(8500)
    NarcosClient.trace("Skin reçu")
    for k,v in pairs(skin) do
        if k == "sex" then
            Narcos.toInternal("skinchanger:change", k, v)
        end
    end
    Wait(2000)
    for k,v in pairs(skin) do
        if k ~= "sex" then
            Narcos.toInternal("skinchanger:change", k, v)
            Wait(50)
        end
    end
    for k,v in pairs(tenue) do
        if k ~= "sex" then
            Narcos.toInternal("skinchanger:change", k, v)
            Wait(50)
        end
    end
end)

RegisterCommand("testCrea", function()
   Narcos.toInternal("creatorStarts")
end)