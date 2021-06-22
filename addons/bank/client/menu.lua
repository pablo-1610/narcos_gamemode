---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [menu] created at [23/06/2021 01:08]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("bankOpenMenu", function(cards, availableCardNum)
    if isAMenuActive then
        return
    end
    isAMenuActive = true
    FreezeEntityPosition(PlayerPedId(), true)
    local title, cat, desc = "Banque", "bank", "Nous protégeons votre argent"
    local sub = function(str)
        return cat .. "_" .. str
    end

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("cards"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("cards")).Closed = function()
    end

    RMenu.Add(cat, sub("cards_build"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("cards")), nil, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("cards_build")).Closed = function()
    end

    RMenu.Add(cat, sub("cards_manage"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("cards")), nil, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("cards_manage")).Closed = function()
    end

    RMenu.Add(cat, sub("prets"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("prets")).Closed = function()
    end

    RMenu.Add(cat, sub("crypto"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("crypto")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, sub("main")), true)

    Narcos.newThread(function()
        while isAMenuActive do
            local shouldStayOpened, selectedCard = false
            local function tick()
                shouldStayOpened = true
            end

            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                RageUI.ButtonWithStyle("Gérer mes cartes virtuelles", "Gérer mes cartes bleues virtuelles", {RightLabel = "→"}, true, nil, RMenu:Get(cat, sub("cards")))
                RageUI.ButtonWithStyle("Gérer mes prêts", "Gérer mes prêts", {RightLabel = "→"}, true, nil, RMenu:Get(cat, sub("prets")))
                RageUI.ButtonWithStyle("Espace cryptomonnaies", "Accédez à l'espace dédidé aux cryptomonnaies", {RightLabel = "→"}, true, nil, RMenu:Get(cat, sub("crypto")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("cards")), true, true, true, function()
                tick()
                RageUI.ButtonWithStyle("Créer une carte bleue", "Créez une carte bleue virtuelle", {RightLabel = "→"}, true, nil, RMenu:Get(cat, sub("cards_build")))
                if #cards > 0 then
                    RageUI.Separator("↓ ~g~Mes cartes ~s~↓")
                    for k, v in pairs(cards) do
                        RageUI.ButtonWithStyle(("%s"):format(v.number), "Gérer cette carte bleue virtuelle", {RightLabel = "→"}, true, function(_,_,s)
                            selectedCard = k
                        end, RMenu:Get(cat, sub("cards_manage")))
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("cards_build")), true, true, true, function()
                tick()
                RageUI.ButtonWithStyle(("Titulaire: ~g~%s %s"):format(personnalData.player.identity.lastname:upper(), personnalData.player.identity.firstname), nil, {}, true, nil)
                RageUI.ButtonWithStyle(("Numéro: ~y~%s %s"):format(availableCardNum), nil, {}, true, nil)
            end, function()
            end)

            if not shouldStayOpened and isAMenuActive then
                isAMenuActive = false
            end
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("cards"))
        RMenu:Delete(cat, sub("cards_build"))
        RMenu:Delete(cat, sub("cards_manage"))
        RMenu:Delete(cat, sub("prets"))
        RMenu:Delete(cat, sub("crypto"))
    end)
end)