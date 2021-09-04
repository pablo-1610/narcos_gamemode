---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 04:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local x, y = 0.86, 0.026
local alpha, space = 255, 0.045
local varAlpha, currentVaring = 255, false
local toggle, locked, variation, speedoactive = false, false, false, false
local varTable = { [true] = { symbol = "+", color = { 76, 181, 80 }, minus = 0.01 }, [false] = { symbol = "-", color = { 255, 82, 82 }, minus = 0.0075 } }
local variationData = {}

local function drawHud()
    DrawRect(1.0, 0, 0.08, 0.06, 0,0,0,math.round(alpha/3))
    DrawRect(1.0, 0, 0.08, 0.005, 20, 69, 122,math.round(alpha/0.5))
    NarcosClient.DrawHelper.drawTexts(0.97, 0.0015, ("%s:%s"):format(gameClock[1],gameClock[2]), false, 0.40, {255,255,255,math.round(alpha/0.5)}, 4,0)

    NarcosClient.DrawHelper.drawTexts(x, y, ("%s — %s"):format(clientCache["jobsLabels"][personnalData.player.cityInfos["job"].id], clientCache["jobsRanksLabels"][personnalData.player.cityInfos["job"].id][personnalData.player.cityInfos["job"].rank]), false, 0.50, { 255, 255, 255, alpha }, 4, 0)

    NarcosClient.DrawHelper.drawTexts(x, (y + space), ("%s$"):format(NarcosClient.MenuHelper.groupDigits(personnalData.player.cash)), false, 0.50, { 66, 176, 245, alpha }, 4, 0)
    if variation then
        NarcosClient.DrawHelper.drawTexts(x - (varTable[variationData.isPositive].minus), (y + (space * 2)), ("%s%s$"):format(varTable[variationData.isPositive].symbol, NarcosClient.MenuHelper.groupDigits(variationData.ammount)), false, 0.50, { varTable[variationData.isPositive].color[1], varTable[variationData.isPositive].color[2], varTable[variationData.isPositive].color[3], varAlpha }, 4, 0)
    end
end

NarcosClient_Hud = {}

local function variationFunc(incomingAmmount, positive)
    currentVaring = true
    varAlpha = 0
    variationData = { ammount = incomingAmmount, isPositive = positive }
    variation = true
    Narcos.newThread(function()
        while varAlpha ~= 255 do
            varAlpha = varAlpha + 3
            Wait(1)
        end
    end)
    Narcos.newThread(function()
        Wait(2500)
        while varAlpha > 0 do
            varAlpha = varAlpha - 3
            Wait(1)
        end
        varAlpha = 0
        variation = false
        currentVaring = false
    end)
end

NarcosClient_Hud.isSpeedoActive = function()
    return speedoactive
end

local baseSpeedoMinor = 0.21
NarcosClient_Hud.activeSpeedo = function()
    speedoactive = true
    while speedoactive do
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                local kmh = (GetEntitySpeed(vehicle)*3.6)
                if not kmh or kmh == "" or kmh <= 0 then kmh = 0 end
                DrawRect(0.5, 1.0, 0.252-baseSpeedoMinor, 0.154, 196, 196, 196,math.round(alpha/3))
                DrawRect(0.5, 1.0, 0.25-baseSpeedoMinor, 0.15, 0,0,0,math.round(alpha/2))
                NarcosClient.DrawHelper.drawTexts(0.5, 0.925, tostring(math.floor((kmh+0.5))), true, 0.85, { 255, 189, 109, alpha }, 2, 0)
                NarcosClient.DrawHelper.drawTexts(0.5, 0.97, "kmh", true, 0.45, { 255,255,255, alpha }, 2, 0)
            else
                speedoactive = false
            end
        else
            speedoactive = false
        end
    end
end

NarcosClient_Hud.showVariation = function(before, after)
    if not currentVaring and before ~= nil then
        if before > after then
            local ammount = ((before - after))
            variationFunc(ammount, false)
        elseif before < after then
            local ammount = ((after - before))
            variationFunc(ammount, true)
        end
    end
end

NarcosClient_Hud.showTimer = function(mssec)
    if toggle then
        return
    end
    locked = true
    toggle = true
    alpha = 0
    Narcos.newThread(function()
        while alpha ~= 255 do
            alpha = alpha + 3
            Wait(1)
        end
    end)
    Narcos.newThread(function()
        Wait(mssec)
        while alpha > 0 do
            alpha = alpha - 3
            Wait(1)
        end
        toggle = false
        locked = false
        alpha = 0
    end)
    while toggle do
        drawHud()
        Wait(0)
    end
end

NarcosClient_KeysManager.addKey("z", "Affichage de l'HUD", function()
    if currentState ~= NarcosEnums.GameStates.PLAYING then
        return
    end
    if locked then
        return
    end
    NarcosClient_Hud.toggle((not toggle))
end)

NarcosClient_Hud.toggle = function(bool)
    toggle = bool
    if toggle then
        Narcos.newThread(function()
            locked = true
            alpha = 0
            Narcos.newThread(function()
                while alpha ~= 255 do
                    alpha = alpha + 3
                    Wait(1)
                end
                locked = false
            end)
            while toggle do
                drawHud()
                Wait(0)
            end
            locked = true
            Narcos.newThread(function()
                while locked do
                    alpha = alpha - 3
                    Wait(1)
                end
            end)
            while alpha > 0 do
                drawHud()
                Wait(0)
            end
            locked = false
        end)
    end
end

Narcos.netHandle("playerOk", function()
    NarcosClient_Hud.toggle(true)
end)