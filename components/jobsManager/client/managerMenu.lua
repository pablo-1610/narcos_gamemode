---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [managerMenu] created at [04/09/2021 22:20]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]
local title, cat, desc = "Manager", "jobManager", "Gérez votre entreprise"
local sub = function(str)
    return cat .. "_" .. str
end
--serverReturnedCb
Narcos.netRegister("managerReceivedUpdate")
Narcos.netRegisterAndHandle("jobManagerMenu", function(employees, ranks, label, name)
    if isAMenuActive then
        return
    end
    NarcosClient.toServer("managerSubscribe", name)
    Narcos.netHandle("managerReceivedUpdate", function(job, employeesN, ranksN)
        if job == name then
            employees = employeesN
            ranks = ranksN
        end
    end)
    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("main")).Closed = function()
        NarcosClient.toServer("managerUnSubscribe")
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
        isAMenuActive = false
    end

    RMenu.Add(cat, sub("employees"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("employees")).Closed = function()
    end

    RMenu.Add(cat, sub("employees_manage"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("employees")), title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("employees_manage")).Closed = function()
    end

    RMenu.Add(cat, sub("ranks"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("ranks")).Closed = function()
    end

    FreezeEntityPosition(PlayerPedId(), true)
    isAMenuActive = true
    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    Narcos.newThread(function()
        local selectedEmployeed, selectedRank
        local function baseSep()
            RageUI.Separator(("Gestion de l'entreprise: ~y~%s"):format(label))
        end
        local function formatIdentity(identity)
            return ("%s %s"):format(identity.lastname:upper(), identity.firstname)
        end
        while isAMenuActive do
            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                baseSep()
                RageUI.ButtonWithStyle("Gérer les employés", nil, {RightLabel = "→→"}, true, nil, RMenu:Get(cat, sub("employees")))
                RageUI.ButtonWithStyle("Gérer les grades", nil, {RightLabel = "→→"}, true, nil, RMenu:Get(cat, sub("ranks")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("employees")), true, true, true, function()
                baseSep()
                for localId, employeeData in pairs(employees) do
                    RageUI.ButtonWithStyle(("~s~[~r~%s~s~] %s"):format(ranks[employeeData.rank].label, ("%s %s"):format(employeeData.identity.lastname:upper(), employeeData.identity.firstname)), nil, {RightLabel = "→→"}, (not (employeeData.identifier == personnalData.player.identifiers['license'])) and (employeeData.rank > personnalData.player.cityInfos["job"].rank), function(_,_,s)
                        if s then
                            selectedEmployeed = localId
                        end
                    end, RMenu:Get(cat, sub("employees_manage")))
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("employees_manage")), true, true, true, function()
                baseSep()
                RageUI.Separator(("Selection: ~o~%s"):format(formatIdentity(employees[selectedEmployeed].identity)))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("ranks")), true, true, true, function()
                baseSep()
            end, function()
            end)
            Wait(0)
        end
    end)
end)