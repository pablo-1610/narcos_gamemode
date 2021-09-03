---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [04/09/2021 00:01]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local announceTask

Narcos.netRegisterAndHandle("receiveAnnounceStop", function()
    Narcos.cancelTaskNow(announceTask)
    announceTask = nil
end)

Narcos.netRegisterAndHandle("receiveAnnounce", function(message, duration)
    if announceTask ~= nil then
        Narcos.cancelTaskNow(announceTask)
    end
    local fadeIn, alertFade, alertFadeIn = 0, 100, true
    Narcos.newThread(function()
        while announceTask ~= nil do
            fadeIn = fadeIn + 1
            if (fadeIn >= 200) then return end
            Wait(25)
        end
    end)
    Narcos.newThread(function()
        while announceTask ~= nil do
            Wait(2)
            if alertFadeIn then
                alertFade = alertFade + 1
                if (alertFade >= 255) then alertFadeIn = false end
            else
                alertFade = alertFade - 1
                if (alertFade <= 100) then alertFadeIn = true end
            end
        end
    end)
    --local width = 0.28
    local width = 0
    local count = (#NarcosClient.split(message, "")-1)
    print(count)
    width = count*0.0145
    announceTask = Narcos.newRepeatingTask(function(task)
        DrawRect(0, 0, width, 0.08, 0,0,0,(math.round(fadeIn/2)))
        DrawRect(0, 0, width, 0.005, 255,0,0,fadeIn < 200 and math.round(fadeIn/2) or alertFade)
        NarcosClient.DrawHelper.drawTexts(0.0035, 0.0055, message, false, 0.40, { 255,255,255, fadeIn < 200 and math.round(fadeIn/2) or 180 }, 8, 0)
    end, nil, 1,0)
end)