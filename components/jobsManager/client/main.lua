---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 04:29]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_JobsManager = {}
NarcosClient_JobsManager.menu = {}

NarcosClient_JobsManager.registerJobMenu = function(job, menu)
    NarcosClient_JobsManager.menu[job] = menu
end

Narcos.netHandle("sideLoaded", function()
    NarcosClient.toServer("requestJobsLabels")
    NarcosClient_KeysManager.addKey("f6", "Menu des interactions job", function()
        if currentState ~= NarcosEnums.GameStates.PLAYING then
            return
        end
        if NarcosClient_JobsManager.menu[personnalData.player.cityInfos["job"].id] ~= nil then
            if isAMenuActive then
                return
            end
            NarcosClient_JobsManager.menu[personnalData.player.cityInfos["job"].id]()
        else
            local title, cat, desc = clientCache["jobsLabels"][personnalData.player.cityInfos["job"].id], ("itr%s"):format(math.random(1,50000)), NarcosConfig_Client.interactionMenuTitle
            local sub = function(str)
                return cat .. "_" .. str
            end
            isAMenuActive = true

            RMenu.Add(cat, sub("main"), RageUI.CreateMenu(title, desc, nil, nil, "pablo", "black"))
            RMenu:Get(cat, sub("main")).Closed = function()
            end

            RageUI.Visible(RMenu:Get(cat, sub("main")), true)

            Narcos.newThread(function()
                while isAMenuActive do
                    local shouldStayOpened = false
                    local function tick()
                        shouldStayOpened = true
                    end

                    RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                        tick()
                        RageUI.Separator("")
                        RageUI.Separator("~r~Votre job n'a pas de menu F6 :(")
                        RageUI.Separator("")
                    end, function()
                    end)

                    if not shouldStayOpened and isAMenuActive then
                        isAMenuActive = false
                    end
                    Wait(0)
                end
                RMenu:Delete(cat, sub("main"))
            end)
        end
    end)
end)