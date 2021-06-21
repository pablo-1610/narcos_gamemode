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
    FreezeEntityPosition(PlayerPedId(), true)
    local title, cat, desc = "Location", "location", "Louez un véhicule"
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
            vip = NarcosClient.PlayerHeler.isVip()
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end

            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                RageUI.Separator("~o~Francisco Faggio")
                for k,v in pairs(vehicles) do
                    if v.vip then
                        RageUI.ButtonWithStyle(("~y~[VIP] ~s~%s"):format(v.title), NarcosClient.MenuHelper.descOrVipCom(("~y~Description~s~: %s"):format(v.desc), vip), { RightLabel = NarcosClient.MenuHelper.generatePrice(v.price)}, (not serverUpdating) and vip, function(_,_,s)
                            if s then

                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(v.title, ("~y~Description~s~: %s"):format(v.desc), { RightLabel = NarcosClient.MenuHelper.generatePrice(v.price) }, (not serverUpdating), function(_,_,s)
                            if s then

                            end
                        end)
                    end
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
    end)
end)