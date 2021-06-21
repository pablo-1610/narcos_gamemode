---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 07:43]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("vehicleLocationOpen", function(vehicles)
    if isAMenuActive then
        return
    end
    local title, cat, desc = "Location", location, "Louez un véhicule"
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
                RageUI.Separator("~b~Francisco Faggio")
                RageUI.ButtonWithStyle("Moto douteuse", "~y~Description~s~: Cette moto peut faire l'affaire, bien qu'elle semble avoir déjà beaucoup servie...", {}, (not serverUpdating), function(_,_,s)
                    if s then

                    end
                end)
                RageUI.ButtonWithStyle("Voiture (presque) neuve", "~y~Description~s~: Une petite voiture de ville, que réver de mieux ?", {}, (not serverUpdating), function(_,_,s)
                    if s then

                    end
                end)
            end, function()
            end)

            if not shouldStayOpened and isAMenuActive then
                isAMenuActive = false
            end
            Wait(0)
        end
        RMenu:Delete(cat, sub("main"))
    end)
end)