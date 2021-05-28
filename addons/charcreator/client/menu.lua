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
local function refreshData()
    Narcos.toInternal("skinchanger:getData", function(comp_, max)
        open = true
        comp = comp_
        for k, v in pairs(comp) do
            local skip = false
            for _, n in pairs(ignore) do
                if n == v.name then
                    skip = true
                    comp[k] = nil
                end
            end
            if not skip then
                if v.value ~= 0 then
                    index[v.name] = v.value
                else
                    index[v.name] = 1
                end
                for i, value in pairs(max) do
                    if i == v.name then
                        comp[k].max = value
                        comp[k].table = {}
                        for i = 0, value do
                            table.insert(comp[k].table, "~g~" .. i .. "~s~")
                        end
                        break
                    end
                end
            end
        end
    end)
end

local waitingChanges = false

Narcos.netHandle("skinchanger:modelLoaded", function()
    waitingChanges = false
end)

Narcos.netHandle("creatorMenu", function()
    if isAMenuActive then
        return
    end
    local sexSelected = false
    Narcos.toInternal("skinchanger:loadDefaultModel", true)
    refreshData()
    local currentData = {}
    Narcos.toInternal("skinchanger:getData", function(comp_, max)
        for k, v in pairs(comp) do
            local skip = false
            for _, n in pairs(ignore) do
                if n == v.name then
                    skip = true
                    comp[k] = nil
                end
            end
            if not skip then
                if v.value ~= 0 then
                    currentData[v.name] = v.value
                else
                    currentData[v.name] = 1
                end
            end
        end
    end)
    print(json.encode(currentData))
    local builder = {
        firstname = nil, lastname = nil, age = nil,
    }
    local currentCustom = nil
    local validate = function()
        return (NarcosClient.InputHelper.validateInputStringDefinition(builder.firstname) and NarcosClient.InputHelper.validateInputStringDefinition(builder.lastname))
    end
    isAMenuActive = true

    SetPedDefaultComponentVariation(PlayerPedId())

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
    Narcos.toInternal("skinchanger:change", "tshirt_1", currentData["tshirt_1"])
    Narcos.newThread(function()
        while isAMenuActive do
            FreezeEntityPosition(PlayerPedId(), true)
            Wait(Narcos.second(2))
        end
    end)
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
                        NarcosClient.trace(json.encode(currentData))
                        NarcosClient.toServer("creatorRegister", builder, currentData)
                        shouldStayOpened = false
                        Narcos.toInternal("creatorExit")
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
                    RageUI.ButtonWithStyle("Homme", nil, {}, true, function(_, _, s)
                        if s then
                            waitingChanges = true
                            currentData['sex'] = 0
                            Narcos.toInternal("skinchanger:loadDefaultModel", true)
                            Narcos.toInternal("skinchanger:change", "tshirt_1", currentData["tshirt_1"])
                            sexSelected = true
                        end
                    end)
                    RageUI.ButtonWithStyle("Femme", nil, {}, true, function(_, _, s)
                        if s then
                            waitingChanges = true
                            currentData['sex'] = 1
                            Narcos.toInternal("skinchanger:loadDefaultModel", false)
                            Narcos.toInternal("skinchanger:change", "tshirt_1", currentData["tshirt_1"])
                            ClearAllPedProps(PlayerPedId())
                            sexSelected = true
                        end
                    end)
                    if sexSelected then
                        RageUI.Separator("↓ ~o~Customisation ~s~↓")
                        for k, v in pairs(comp) do
                            if v.table[1] ~= nil then
                                if v.name ~= "sex" then
                                    RageUI.ButtonWithStyle(("Customisation ~y~\"~s~%s~y~\""):format(v.label), nil, { RightLabel = "→→" }, true, function(_, _, s)
                                        if s then
                                            currentCustom = k
                                        end
                                    end, RMenu:Get(cat, sub("characterdet")))
                                end
                            end
                        end
                    end

                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("characterdet")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Customisation ~s~↓")
                for i = 0, comp[currentCustom].max do
                    RageUI.ButtonWithStyle(("Variation n°%s"):format(i), "Appuyez pour ~g~VALIDER ~s~cette variation", {}, true, function(_, a, s)
                        if a then
                            if currentData[comp[currentCustom].name] ~= (i) then
                                Narcos.toInternal("skinchanger:change", comp[currentCustom].name, i)
                            end
                        end

                        if s then
                            currentData[comp[currentCustom].name] = (i)
                            RageUI.Text { message = "~g~Changement appliqué", time_display = 1500 }
                            refreshData()
                            if comp[currentCustom].componentId ~= nil then
                                SetPedComponentVariation(GetPlayerPed(-1), comp[currentCustom].componentId, i, 0, 2)
                            end
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
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("identity"))
        RMenu:Delete(cat, sub("character"))
        RMenu:Delete(cat, sub("characterdet"))
    end)
end)


