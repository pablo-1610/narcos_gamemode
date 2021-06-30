---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [garageMenu] created at [30/06/2021 13:12]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("jobGarageMenu", function(job, availableVehicles)
    if isAMenuActive then
        return
    end
    local title, cat, desc = "Garage", "jobGarage", "Choisissez un véhicule"
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
                RageUI.Separator("Véhicules disponibles")
                for model, _ in pairs(availableVehicles) do
                    RageUI.ButtonWithStyle(("~o~%s"):format(GetDisplayNameFromVehicleModel(GetHashKey(model))), "Appuyez pour selectionner ce véhicule", {RightLabel = "→"}, true, function(_,_,s)
                        if s then
                            serverUpdating = true
                            shouldStayOpened = false
                            NarcosClient.toServer("jobGarageOut", model)
                        end
                    end)
                end
            end, function()
            end)

            if not shouldStayOpened and isAMenuActive then
                isAMenuActive = false
            end
            Wait(0)
        end
        RMenu:Delete(cat, sub("main"))
        FreezeEntityPosition(PlayerPedId(), false)
    end)
end)