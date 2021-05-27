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
    local builder = {
        firstname = nil, lastname = nil, age = nil,
    }
    local validate = function()
        return (NarcosClient.InputHelper.validateInputStringDefinition(builder.firstname) and NarcosClient.InputHelper.validateInputStringDefinition(builder.lastname))
    end
    isAMenuActive = true
    FreezeEntityPosition(PlayerPedId(), true)
    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_bawsaq"))
    RMenu:Get(cat, sub("main")).Closable = false
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("identity"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_bawsaq"))
    RMenu:Get(cat, sub("identity")).Closed = function()
    end

    RMenu.Add(cat, sub("character"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_bawsaq"))
    RMenu:Get(cat, sub("character")).Closed = function()
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
                RageUI.Separator("↓ ~g~Customisation ~s~↓")
                RageUI.ButtonWithStyle("Mon identité", nil, { RightLabel = "→→" }, true, nil, RMenu:Get(cat, sub("identity")))
                RageUI.ButtonWithStyle("Mon personnage", nil, { RightLabel = "→→" }, true, nil, RMenu:Get(cat, sub("character")))
                RageUI.Separator("↓ ~y~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~Valider ~s~la création", nil, {}, validate(), function(_, _, s)
                    if s then
                        shouldStayOpened = false
                    end
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("identity")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Identité ~s~↓")
                RageUI.ButtonWithStyle("Prénom:", nil, { RightLabel = NarcosClient.MenuHelper.defineLabelString(builder.firstname) }, true, function(_, _, s)
                    if s then
                        local input = NarcosClient.InputHelper.showBox("Prénom", "", 20, false)
                        if NarcosClient.InputHelper.validateInputStringDefinition(input) then
                            local matchesRegex = NarcosClient.InputHelper.validateInputStringRegex(input, "^[A-Z][A-Za-z\\é\\è\\ê\\-]+$")
                            if matchesRegex then
                                RageUI.SetIndicator(nil)
                                builder.firstname = input
                            else
                                RageUI.SetIndicator("Ce prénom est invalide")
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Nom:", nil, { RightLabel = NarcosClient.MenuHelper.defineLabelString(builder.lastname) }, true, function(_, _, s)
                    if s then
                        local input = NarcosClient.InputHelper.showBox("Nom", "", 20, false)
                        if NarcosClient.InputHelper.validateInputStringDefinition(input) then
                            local matchesRegex = NarcosClient.InputHelper.validateInputStringRegex(input, "^[A-Z][A-Za-z\\é\\è\\ê\\-]+$")
                            if matchesRegex then
                                RageUI.SetIndicator(nil)
                                builder.lastname = input
                            else
                                RageUI.SetIndicator("Ce nom est invalide")
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Age:", nil, { RightLabel = NarcosClient.MenuHelper.defineLabelInt(builder.age, " ans") }, true, function(_, _, s)
                    if s then
                        local input = tonumber(NarcosClient.InputHelper.showBox("Âge", "", 2, true))
                        if NarcosClient.InputHelper.validateInputIntDefinition(input, true) then
                            local pass = true
                            if input < 18 or input > 79 then
                                pass = false
                                RageUI.SetIndicator("Vous êtes trop jeune/vieux")
                            end
                            if pass then
                                builder.age = input
                                RageUI.SetIndicator(nil)
                            end
                        end
                    end
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("character")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Personnage ~s~↓")
            end, function()
            end)

            if not shouldStayOpened and isAMenuActive then
                isAMenuActive = false
            end
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
        Narcos.toInternalBasic("creatorExit")
    end)
end)