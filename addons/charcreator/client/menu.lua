---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [menu] created at [21/05/2021 17:31]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local cat, desc = "creatorMenu", "~g~Customisation du personnage"
local sub = function(str)
    return cat .. "_" .. str
end

Narcos.netHandle("creatorMenu", function()
    if isAMenuActive then
        return
    end
    isAMenuActive = true
    FreezeEntityPosition(PlayerPedId(), true)
    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_bawsaq"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("identity"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_bawsaq"))
    RMenu:Get(cat, sub("identity")).Closed = function()
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
                RageUI.Separator("↓ ~g~Informations ~s~↓")
            end, function()
            end)

            if not shouldStayOpened and isAMenuActive then
                isAMenuActive = false
            end
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
    end)
end)