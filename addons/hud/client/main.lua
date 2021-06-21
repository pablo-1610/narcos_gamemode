---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 04:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local toggle, locked = false, false

local alpha = 255
local function drawHud()
    NarcosClient.DrawHelper.drawTexts(0.86, 0.024, clientCache["jobsLabels"][personnalData.player.cityInfos["job"].id], false, 0.90, { 255, 255, 255, alpha }, 2, 0)
    NarcosClient.DrawHelper.drawTexts(0.86, 0.024 + 0.045, ("%s$"):format(personnalData.player.cash), false, 0.90, { 71, 196, 69, alpha }, 4, 0)
end

NarcosClient_Hud = {}
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