---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [menu] created at [23/06/2021 01:08]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("bankOpenMenu", function(cards, availableCardNum, creationPrice, bankId)
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
        local selectedCard, cardpin = false, nil, nil
        table.sort(cards, function(a,b) return a.balance>b.balance end)
        while isAMenuActive do
            local shouldStayOpened
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
                RageUI.ButtonWithStyle("Créer une carte bleue", "Créez une carte bleue virtuelle", {RightLabel = "→"}, (not serverUpdating), nil, RMenu:Get(cat, sub("cards_build")))
                if NarcosClient.InputHelper.getTableLenght(cards) > 0 then
                    RageUI.Separator("↓ ~g~Mes cartes ~s~↓")
                    for k, v in pairs(cards) do
                        RageUI.ButtonWithStyle(("%s"):format(v.number), "Gérer cette carte bleue virtuelle", {RightLabel = ("~g~%s$"):format(NarcosClient.MenuHelper.groupDigits(v.balance))}, true, function(_,_,s)
                            if s then
                                selectedCard = k
                            end
                        end, RMenu:Get(cat, sub("cards_manage")))
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("cards_manage")), true, true, true, function()
                tick()
                RageUI.Separator(("Carte: ~o~%s ~s~(~g~%s$~s~)"):format(cards[selectedCard].number, NarcosClient.MenuHelper.groupDigits(cards[selectedCard].balance)))
                RageUI.Separator("↓ ~g~Actions ~s~↓")
                RageUI.ButtonWithStyle("Alimenter ma carte", "Vous permets de déposer du cash sur votre carte virtuelle", {RightLabel = "→"}, true, function(_,_,s)
                    if s then
                        local result = NarcosClient.InputHelper.showBox("Montant à déposer", "", 10, true)
                        if result ~= nil and tonumber(result) ~= nil and tonumber(result) > 0 then
                            serverUpdating = true
                            shouldStayOpened = false
                            NarcosClient.toServer("bankAlimCard", selectedCard, tonumber(result), bankId)
                            RageUI.SetIndicator(nil)
                        else
                            RageUI.SetIndicator("Montant invalide")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Retirer de ma carte", "Vous permets de retirer de l'argent en cash depuis votre carte", {RightLabel = "→"}, true, function(_,_,s)
                    if s then
                        local result = NarcosClient.InputHelper.showBox("Montant à retirer", "", 10, true)
                        if result ~= nil and tonumber(result) ~= nil and tonumber(result) > 0 then
                            serverUpdating = true
                            shouldStayOpened = false
                            NarcosClient.toServer("bankGetFromCard", selectedCard, tonumber(result), bankId)
                            RageUI.SetIndicator(nil)
                        else
                            RageUI.SetIndicator("Montant invalide")
                        end
                    end
                end)
                if NarcosClient.InputHelper.getTableLenght(cards[selectedCard].history) > 0 then
                    RageUI.Separator(("↓ ~y~Historique ~s~(~y~%s~s~) ~s~↓"):format(NarcosClient.InputHelper.getTableLenght(cards[selectedCard].history)))
                    local fakeI = #cards[selectedCard].history
                    for k,_ in pairs(cards[selectedCard].history) do
                        local positive, v = {[true] = "~g~+", [false] = "~r~-"}, cards[selectedCard].history[fakeI]
                        RageUI.ButtonWithStyle(("%s. %s"):format(k, v.desc), ("Opération effectuée %s"):format(v.date), {RightLabel = ("%s%s$"):format(positive[v.positive], NarcosClient.MenuHelper.groupDigits(v.ammount))}, true, nil)
                        fakeI = (fakeI-1)
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("cards_build")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Définition ~s~↓")
                RageUI.ButtonWithStyle(("Titulaire: ~g~%s %s"):format(personnalData.player.identity.lastname:upper(), personnalData.player.identity.firstname), nil, {}, true, nil)
                RageUI.ButtonWithStyle(("Numéro: ~y~%s"):format(availableCardNum), nil, {}, true, nil)
                RageUI.ButtonWithStyle(("Pin: %s"):format(cardpin == nil and "~r~Définir" or ("~r~%s"):format(cardpin)), nil, {RightLabel = "→"}, true, function(_,_,s)
                    if s then
                        local result = NarcosClient.InputHelper.showBox("Code secret à quatre chiffres", "", 4, true)
                        if result ~= nil and tonumber(result) ~= nil then
                            if tonumber(result) > 999 then
                                cardpin = result
                                RageUI.SetIndicator(nil)
                            else
                                RageUI.SetIndicator("Ce code n'est pas à 4 chiffres")
                            end
                        else
                            RageUI.SetIndicator("Aucun code indiqué")
                        end
                    end
                end)
                RageUI.Separator("↓ ~y~Validation ~s~↓")
                RageUI.ButtonWithStyle("Créer ma carte bleue", nil, {RightLabel = NarcosClient.MenuHelper.generatePrice(creationPrice)}, (cardpin ~= nil) and (not serverUpdating), function(_,_,s)
                    if s then
                        shouldStayOpened = false
                        serverUpdating = true
                        NarcosClient.toServer("bankCreateCard", cardpin, availableCardNum, (personnalData.player.identity.lastname:upper().." "..personnalData.player.identity.firstname), bankId)
                    end
                end)
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