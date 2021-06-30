---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [menu] created at [20/06/2021 23:50]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local title, cat, desc = "Mon personnage", "personnalMenu", "Menu personnel"
local sub = function(str)
    return cat .. "_" .. str
end

local noclip, names, blips, invincible = false, false, false, false

local NoClipSpeed = 1

local function NoClipToggle(bool)
    noclip = bool
    if noclip then
        Narcos.newThread(function()
            while noclip do
                Wait(0)
                HideHudComponentThisFrame(19)
                HideHudComponentThisFrame(20)
            end
        end)
        Narcos.newThread(function()
            while noclip do
                Wait(0)
                local pCoords = GetEntityCoords(PlayerPedId(), false)
                local camCoords = NarcosClient.PlayerHeler.getCamDirection()
                SetEntityVelocity(PlayerPedId(), 0.01, 0.01, 0.01)
                SetEntityCollision(PlayerPedId(), 0, 1)
                FreezeEntityPosition(PlayerPedId(), true)

                if IsControlPressed(0, 32) then
                    pCoords = pCoords + (NoClipSpeed * camCoords)
                end

                if IsControlPressed(0, 269) then
                    pCoords = pCoords - (NoClipSpeed * camCoords)
                end

                if IsDisabledControlJustPressed(1, 15) then
                    NoClipSpeed = NoClipSpeed + 0.3
                end
                if IsDisabledControlJustPressed(1, 14) then
                    NoClipSpeed = NoClipSpeed - 0.3
                    if NoClipSpeed < 0 then
                        NoClipSpeed = 0
                    end
                end
                SetEntityCoordsNoOffset(PlayerPedId(), pCoords, true, true, true)
                SetEntityVisible(PlayerPedId(), 0, 0)

            end
            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityVisible(PlayerPedId(), 1, 0)
            SetEntityCollision(PlayerPedId(), 1, 1)
        end)
    end
end

Narcos.netHandle("f5menu", function()
    if isAMenuActive then
        return
    end
    isAMenuActive = true

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("inventory"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), "Inventaire", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("inventory")).Closed = function()
    end

    RMenu.Add(cat, sub("inventory_item"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inventory")), "Inventaire", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("inventory_item")).Closed = function()
    end

    RMenu.Add(cat, sub("tactical"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), "Tactique", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("tactical")).Closed = function()
    end

    RMenu.Add(cat, sub("tactical_item"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("tactical")), "Tactique", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("tactical_item")).Closed = function()
    end

    RMenu.Add(cat, sub("portefeuille"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), "Portefeuille", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("portefeuille")).Closed = function()
    end

    RMenu.Add(cat, sub("admin"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), "Administration", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("admin")).Closed = function()
    end

    RMenu.Add(cat, sub("admin_players"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("admin")), "Administration", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("admin_players")).Closed = function()
    end

    RMenu.Add(cat, sub("admin_vehicles"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("admin")), "Administration", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("admin_vehicles")).Closed = function()
    end

    RMenu.Add(cat, sub("admin_other"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("admin")), "Administration", desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("admin_other")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, sub("main")), true)

    Narcos.newThread(function()
        local itemsLabels = clientCache["itemsLabel"]
        local selectedItem, selectedWeapon
        while isAMenuActive do

            local closestPlayer, closestPlayerDist = NarcosClient.PlayerHeler.getClosestPlayer()

            local function haveClosestPlayer()
                return (closestPlayer ~= nil) and (closestPlayerDist <= 1.5)
            end

            local function getClosestPlayerId()
                return GetPlayerServerId(closestPlayer)
            end

            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end

            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()

                RageUI.Separator(("ID: ~o~%s~s~ | Rang: ~o~%s"):format(personnalData.player.source, personnalData.player.rank.label))

                RageUI.ButtonWithStyle("Inventaire", nil, { RightLabel = "→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("inventory")))

                RageUI.ButtonWithStyle("Tactique", nil, { RightLabel = "→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("tactical")))

                RageUI.ButtonWithStyle("Portefeuille", nil, { RightLabel = "→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("portefeuille")))

                RageUI.ButtonWithStyle("Habits", nil, { RightLabel = "→" }, true, function(_, _, s)
                end)

                RageUI.ButtonWithStyle("Animations", nil, { RightLabel = "→" }, true, function(_, _, s)
                end)

                RageUI.ButtonWithStyle("Autre", nil, { RightLabel = "→" }, true, function(_, _, s)
                end)

                RageUI.ButtonWithStyle("Véhicule", nil, { RightLabel = "→" }, (IsPedSittingInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()), function(_, _, s)
                end)

                RageUI.ButtonWithStyle("Avantages", nil, { RightLabel = "→" }, NarcosClient.PlayerHeler.isVip(), function(_, _, s)
                end)

                RageUI.ButtonWithStyle("Administration", nil, { RightLabel = "→" }, NarcosClient.PlayerHeler.isStaff(), function(_, _, s)
                end, RMenu:Get(cat, sub("admin")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inventory")), true, true, true, function()
                tick()
                RageUI.Separator(("Poids: ~o~%s~s~/~o~%s"):format(personnalData.inventory.weight, personnalData.inventory.capacity))
                if personnalData.inventory.diffItems <= 0 then
                    RageUI.ButtonWithStyle("~r~Votre sac est vide", nil, {}, true)
                else
                    for item, count in pairs(personnalData.inventory.content) do
                        RageUI.ButtonWithStyle(("%s ~o~(%s)"):format(itemsLabels[item], count), nil, { RightLabel = "→"}, (not serverUpdating), function(_,_,s)
                            if s then
                                selectedItem = item
                            end
                        end, RMenu:Get(cat, sub("inventory_item")))
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inventory_item")), true, true, true, function()
                tick()
                RageUI.Separator(("Poids: ~o~%s~s~/~o~%s"):format(personnalData.inventory.weight, personnalData.inventory.capacity))
                if personnalData.inventory.content[selectedItem] then

                    RageUI.Separator(("%s ~o~(x%s)"):format(itemsLabels[selectedItem], personnalData.inventory.content[selectedItem]))
                    RageUI.ButtonWithStyle("Utiliser", nil, {}, (NarcosClient_InventoriesManager.isUsable(selectedItem) and (not serverUpdating)), function(_,_,s)
                        if s then
                            serverUpdating = true
                            NarcosClient_InventoriesManager.use(selectedItem)
                        end
                    end)

                    RageUI.ButtonWithStyle("Donner", nil, {}, (haveClosestPlayer()) and (not serverUpdating), function(_,_,s)
                        if s then
                            local qty = NarcosClient.InputHelper.showBox("Quantité", "", 5, true)
                            if qty ~= nil and tonumber(qty) > 0 then
                                serverUpdating = true
                                NarcosClient_InventoriesManager.give(selectedItem, qty, getClosestPlayerId())
                            end
                        end
                    end)
                else
                    RageUI.GoBack()
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("tactical")), true, true, true, function()
                tick()
                RageUI.Separator("Tactique")
                if NarcosClient.InputHelper.getTableLenght(personnalData.player.loadout) <= 0 then
                    RageUI.ButtonWithStyle("~r~Vous n'avez pas d'armes", nil, {}, true)
                else
                    for weapon, data in pairs(personnalData.player.loadout) do
                        RageUI.ButtonWithStyle(("%s"):format(NarcosConfig_Client.getWeaponLabel(weapon)), nil, { RightLabel = "→"}, true, function(_,_,s)
                            if s then
                                selectedWeapon = weapon
                            end
                        end, RMenu:Get(cat, sub("tactical_item")))
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("tactical_item")), true, true, true, function()
                tick()
                RageUI.Separator("Tactique")
                if not personnalData.player.loadout[selectedWeapon] then
                    RageUI.GoBack()
                else
                    RageUI.Separator(NarcosConfig_Client.getWeaponLabel(selectedWeapon))
                    RageUI.ButtonWithStyle("Donner", nil, {}, (haveClosestPlayer()) and (not serverUpdating), function(_,_,s)
                        if s then
                            -- TODO > Give weapon
                        end
                    end)
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("portefeuille")), true, true, true, function()
                tick()
                RageUI.Separator("Portefeuille")
                RageUI.ButtonWithStyle("Regarder ma carte d'identité", nil, { RightLabel = "→"}, true, function(_,_,s)
                    if s then
                        local mugshot, mugshotStr = NarcosClient.PlayerHeler.getPedMugshot(PlayerPedId())
                        Narcos.toInternal("showAdvancedNotification", "Carte d'identitié", ("~o~%s %s ~s~(~o~%s ans~s~)"):format(personnalData.player.identity.firstname,personnalData.player.identity.lastname:upper(),personnalData.player.identity.age), "", mugshotStr, 7, false)
                    end
                end)
                RageUI.ButtonWithStyle("Montrer ma carte d'identité", nil, { RightLabel = "→"}, (haveClosestPlayer()), function(_,_,s)
                    if s then
                        serverUpdating = true
                        shouldStayOpened = false
                        NarcosClient.toServer("showIdCard", getClosestPlayerId())
                    end
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("admin")), true, true, true, function()
                tick()
                RageUI.Separator("Administration")
                RageUI.ButtonWithStyle("Joueurs", nil, { RightLabel = "→" }, true, function(_,_,s)
                end, RMenu:Get(cat, sub("admin_players")))
                RageUI.ButtonWithStyle("Reports", nil, { RightLabel = "→" }, true, function(_,_,s)
                end, RMenu:Get(cat, sub("admin_reports")))
                RageUI.ButtonWithStyle("Véhicules", nil, { RightLabel = "→" }, true, function(_,_,s)
                end, RMenu:Get(cat, sub("admin_vehicles")))
                RageUI.ButtonWithStyle("Divers", nil, { RightLabel = "→" }, true, function(_,_,s)
                end, RMenu:Get(cat, sub("admin_other")))
                if not NarcosClient.PlayerHeler.isStaff() then
                    RageUI.GoBack()
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("admin_other")), true, true, true, function()
                tick()
                RageUI.Separator("Administration")
                RageUI.Checkbox(("%sNoClip"):format(NarcosClient.MenuHelper.greenIfTrue(noclip)), nil, noclip, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    noclip = Checked;
                end, function()
                    NoClipToggle(true)
                end, function()
                    NoClipToggle(false)
                end)

                RageUI.Checkbox(("%sBlips"):format(NarcosClient.MenuHelper.greenIfTrue(blips)), nil, blips, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    blips = Checked;
                end, function()
                end, function()
                end)

                RageUI.Checkbox(("%sNoms"):format(NarcosClient.MenuHelper.greenIfTrue(names)), nil, names, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    names = Checked;
                end, function()
                end, function()
                end)

                RageUI.Checkbox(("%sInvincibilité"):format(NarcosClient.MenuHelper.greenIfTrue(invincible)), nil, invincible, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    invincible = Checked;
                end, function()
                    SetEntityInvincible(PlayerPedId(), true)
                end, function()
                    SetEntityInvincible(PlayerPedId(), false)
                end)
                if not NarcosClient.PlayerHeler.isStaff() then
                    RageUI.GoBack()
                end
            end, function()
            end)

            if not shouldStayOpened and isAMenuActive then
                isAMenuActive = false
            end
            Wait(0)
        end
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("inventory"))
        RMenu:Delete(cat, sub("inventory_item"))
        RMenu:Delete(cat, sub("tactical"))
        RMenu:Delete(cat, sub("tactical_item"))
        RMenu:Delete(cat, sub("portefeuille"))
        RMenu:Delete(cat, sub("admin"))
        RMenu:Delete(cat, sub("admin_players"))
        RMenu:Delete(cat, sub("admin_vehicles"))
        RMenu:Delete(cat, sub("admin_other"))
    end)
end)
