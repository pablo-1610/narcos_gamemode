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

local index, comp, ignore = {}, {}, {
    "tshirt_1",
    "tshirt_2",
    "torso_1",
    "torso_2",
    "decals_1",
    "decals_2",
    "arms",
    "arms_2",
    "pants_1",
    "pants_2",
    "shoes_1",
    "shoes_2",
    "mask_1",
    "mask_2",
    "bproof_1",
    "bproof_2",
    "chain_1",
    "chain_2",
    "helmet_1",
    "helmet_2",
    "glasses_1",
    "glasses_2",
    "watches_1",
    "watches_2",
    "bracelets_1",
    "bracelets_2",
    "bags_1",
    "bags_2",
}

local waitingChanges = false

Narcos.netHandle("skinchanger:modelLoaded", function()
    waitingChanges = false
end)

Narcos.netHandle("creatorMenu", function()
    if isAMenuActive then
        return
    end
    isAMenuActive = true

    local builder = {
        firstname = nil, lastname = nil, age = nil,
    }

    local builderCharacter = NarcosClient_SkinManager.getSkin()
    local maxValues = NarcosClient_SkinManager.getMaxVals()
    local selectedVariator = nil

    local validate = function()
        return (NarcosClient.InputHelper.validateInputStringDefinition(builder.firstname) and NarcosClient.InputHelper.validateInputStringDefinition(builder.lastname) and builder.age ~= nil)
    end

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

    RMenu.Add(cat, sub("characterdet"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("character")), nil, desc, nil, nil, "root_cause", "shopui_title_bawsaq"))
    RMenu:Get(cat, sub("characterdet")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, sub("main")), true)

    Narcos.newThread(function()
        while isAMenuActive do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end

            maxValues = NarcosClient_SkinManager.getMaxVals()

            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Customisation ~s~↓")
                RageUI.ButtonWithStyle("Mon identité", nil, { RightLabel = "→→" }, true, nil, RMenu:Get(cat, sub("identity")))
                RageUI.ButtonWithStyle("Mon personnage", nil, { RightLabel = "→→" }, true, nil, RMenu:Get(cat, sub("character")))
                RageUI.Separator("↓ ~y~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~Valider ~s~la création", nil, {}, validate(), function(_, _, s)
                    if s then
                        NarcosClient.toServer("creatorRegister", builder, currentData)
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
                        local input = NarcosClient.InputHelper.showBox("Prénom (doit commencer par une majuscule)", "", 20, false)
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
                        local input = NarcosClient.InputHelper.showBox("Nom (doit commencer par une majuscule)", "", 20, false)
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
                if waitingChanges then
                    RageUI.Separator("")
                    RageUI.Separator(("%sChangement de sexe..."):format(NarcosClient.warnVariator))
                    RageUI.Separator("")
                else
                    RageUI.Separator("↓ ~g~Sexe ~s~↓")
                    RageUI.ButtonWithStyle(("%sHomme"):format(NarcosClient.MenuHelper.greenIfTrue(builderCharacter['sex'] == 1)), nil, {}, true, function(_, _, s)
                        if s then
                            waitingChanges = true
                            NarcosClient_SkinManager.Character['sex'] = 1
                            builderCharacter['sex'] = 1
                            NarcosClient.requestModel("mp_m_freemode_01")
                            SetPlayerModel(PlayerId(), Narcos.hash("mp_m_freemode_01"))
                            SetPedDefaultComponentVariation(PlayerPedId())
                            NarcosClient_SkinManager.loadSkin({
                                ["arms"] = 15,
                                ["tshirt_1"] = 15,
                                ["torso_1"] = 15,
                                ["shoes_1"] = 5,
                                ["pants_1"] = 15,
                                ["pants_2"] = 0
                            })
                            waitingChanges = false
                        end
                    end)
                    RageUI.ButtonWithStyle(("%sFemme"):format(NarcosClient.MenuHelper.greenIfTrue(builderCharacter['sex'] == 0)), nil, {}, true, function(_, _, s)
                        if s then
                            waitingChanges = true
                            NarcosClient_SkinManager.Character['sex'] = 0
                            builderCharacter['sex'] = 0
                            NarcosClient.requestModel("mp_f_freemode_01")
                            SetPlayerModel(PlayerId(), Narcos.hash("mp_f_freemode_01"))
                            SetPedDefaultComponentVariation(PlayerPedId())
                            NarcosClient_SkinManager.loadSkin({
                                ["arms"] = 14,
                                ["arms_2"] = 0,
                                ["tshirt_1"] = 2,
                                ["torso_1"] = 49,
                                ["shoes_1"] = 5,
                                ["pants_1"] = 110,
                                ["pants_2"] = 5
                            })
                            ClearAllPedProps(PlayerPedId())
                            waitingChanges = false
                        end
                    end)
                    RageUI.Separator("↓ ~o~Customisation ~s~↓")
                    for k, v in pairs(NarcosClient_SkinManager.trad) do
                        RageUI.ButtonWithStyle(("Customisation ~y~\"~s~%s~y~\""):format(v), nil, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                selectedVariator = k
                            end
                        end, RMenu:Get(cat, sub("characterdet")))
                    end

                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("characterdet")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Customisation ~s~↓")

            end, function()
            end)

            if not shouldStayOpened and isAMenuActive then
                isAMenuActive = false
            end
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("identity"))
        RMenu:Delete(cat, sub("character"))
        RMenu:Delete(cat, sub("characterdet"))
    end)
end)


