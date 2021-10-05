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

local function validatePermission(rank, rankId, permission)
    if rankId == 1 then return true end
    return rank[rankId].permissions[permission] or false
end

local operationState = false
--serverReturnedCb
Narcos.netRegister("managerReceivedUpdate")
Narcos.netRegisterAndHandle("jobManagerMenu", function(employees, ranks, label, name, customPermOrder, money)
    local permissionsEditor, permissionsEditorFinal, permissionsEditorScratch, rankBuilder = {}, {}, {}, {}
    ---@param rankData JobRank
    for rankId, jobRank in pairs(ranks) do
        permissionsEditor[rankId] = {}
        for permissionName, vv in pairs(NarcosEnums.Permissions) do
            permissionsEditor[rankId][permissionName] = { grant = (jobRank.permissions[permissionName] or false), label = vv.desc }
        end
    end
    if isAMenuActive then
        return
    end
    NarcosClient.toServer("managerSubscribe", name)
    Narcos.netHandle("managerReceivedUpdate", function(employeesN, ranksN, moneyN)
        employees = employeesN
        money = moneyN
        ranks = ranksN
        permissionsEditor = {}
        permissionsEditorFinal = {}
        ---@param rankData JobRank
        for rankId, jobRank in pairs(ranks) do
            permissionsEditor[rankId] = {}
            for permissionName, vv in pairs(NarcosEnums.Permissions) do
                permissionsEditor[rankId][permissionName] = { grant = (jobRank.permissions[permissionName] or false), label = vv.desc }
            end
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

    RMenu.Add(cat, sub("ranks_manage"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("ranks")), title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("ranks_manage")).Closed = function()
    end

    RMenu.Add(cat, sub("ranks_manage_create"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("ranks_manage")), title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("ranks_manage_create")).Closed = function()
    end

    RMenu.Add(cat, sub("ranks_manage_permissions"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("ranks_manage")), title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("ranks_manage_permissions")).Closed = function()
        for rankId, jobRank in pairs(ranks) do
            permissionsEditor[rankId] = {}
            for permissionName, vv in pairs(NarcosEnums.Permissions) do
                permissionsEditor[rankId][permissionName] = { grant = (jobRank.permissions[permissionName] or false), label = vv.desc }
            end
        end
    end

    RMenu.Add(cat, sub("confirm"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "pablo", "black"))
    RMenu:Get(cat, sub("confirm")).Closable = false
    RMenu:Get(cat, sub("confirm")).Closed = function()
    end

    FreezeEntityPosition(PlayerPedId(), true)
    isAMenuActive = true
    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    Narcos.newThread(function()
        local selectedEmployeed, selectedRank, confirmOption
        local function baseSep()
            RageUI.Separator(("Gestion de l'entreprise: ~y~%s ~s~(~g~%s$~s~)"):format(label, NarcosClient.MenuHelper.groupDigits(money)))
        end
        local function formatIdentity(identity)
            return ("%s %s"):format(identity.lastname:upper(), identity.firstname)
        end
        while isAMenuActive do
            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                baseSep()
                RageUI.ButtonWithStyle("Gérer les employés", nil, { RightLabel = "→→" }, validatePermission(ranks, personnalData.player.cityInfos["job"].rank, "EMPLOYEES"), nil, RMenu:Get(cat, sub("employees")))
                RageUI.ButtonWithStyle("Gérer les grades", nil, { RightLabel = "→→" }, validatePermission(ranks, personnalData.player.cityInfos["job"].rank, "ROLES"), nil, RMenu:Get(cat, sub("ranks")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("employees")), true, true, true, function()
                baseSep()
                RageUI.ButtonWithStyle("Recruter le joueur proche", "Appuyez pour recruter le joueur le plus proche de vous", {}, validatePermission(ranks, personnalData.player.cityInfos["job"].rank, "EMPLOYEES") and validatePermission(ranks, personnalData.player.cityInfos["job"].rank, "RECRUIT"), function(_,_,s)
                    if s then

                    end
                end)
                for localId, employeeData in pairs(employees) do
                    RageUI.ButtonWithStyle(("~s~[~r~%s~s~] %s"):format(ranks[employeeData.rank].label, ("%s %s"):format(employeeData.identity.lastname:upper(), employeeData.identity.firstname)), nil, { RightLabel = "→→" }, (not (employeeData.identifier == personnalData.player.identifiers['license'])) and (employeeData.rank > personnalData.player.cityInfos["job"].rank), function(_, _, s)
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
                RageUI.ButtonWithStyle("Définir le grade", nil, {}, validatePermission(ranks, personnalData.player.cityInfos["job"].rank, "DEMOTE"), function(_,_,s)
                    if s then

                    end
                end)
                RageUI.ButtonWithStyle("Virer la personne", nil, {}, validatePermission(ranks, personnalData.player.cityInfos["job"].rank, "FIRE"), function(_,_,s)
                    if s then
        
                    end
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("ranks")), true, true, true, function()
                baseSep()
                RageUI.ButtonWithStyle("~b~Créer un grade", nil, { RightLabel = "→→" }, true, function(_,_,s)
                    rankBuilder = {}
                end, RMenu:Get(cat, sub("ranks_manage_create")))
                RageUI.Separator("~s~↓ ~r~Grades ~s~↓")
                for rankId, rankData in pairs(ranks) do
                    RageUI.ButtonWithStyle(("~s~[~r~#%s~s~] %s"):format(rankId, rankData.label), nil, { RightLabel = "→→" }, (rankId > personnalData.player.cityInfos["job"].rank) and (rankId ~= 1), function(_, _, s)
                        if s then
                            selectedRank = rankId
                        end
                    end, RMenu:Get(cat, sub("ranks_manage")))
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("ranks_manage")), true, true, true, function()
                if ranks[selectedRank] then
                    baseSep()
                    RageUI.Separator(("Selection: ~o~%s"):format(ranks[selectedRank].label))

                    RageUI.ButtonWithStyle("Définir le salaire", nil, { RightLabel = ("~g~%s$~s~/~o~30m~s~ →→"):format(NarcosClient.MenuHelper.groupDigits(ranks[selectedRank].salary)) }, true, function(_, _, s)
                        if s then
                            local newSalary = NarcosClient.InputHelper.showBox("Nouveau salaire par 30 minutes", "", 10, true)
                            if newSalary ~= nil and tonumber(newSalary) ~= nil then
                                newSalary = tonumber(newSalary)
                                operationState = false
                                confirmOption = { "setJobRankSalary", ("Changer le salaire (%s)"):format(ranks[selectedRank].label), "ranks_manage", true, { selectedRank, newSalary } }
                                RageUI.Visible(RMenu:Get(cat, sub("confirm")), true)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Gestion des permissions", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    end, RMenu:Get(cat, sub("ranks_manage_permissions")))
                    RageUI.ButtonWithStyle("Définir la tenue", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            -- TODO -> Modify outfit
                        end
                    end, RMenu:Get(cat, sub("ranks_manage_clothes")))
                    RageUI.ButtonWithStyle("~r~Supprimer le grade", selectedRank == #ranks and "Appuyez pour supprimer ce grade" or "~r~Vous ne pouvez pas supprimer un rang intermédiaire", { RightLabel = "→→" }, selectedRank == #ranks, function(_, _, s)
                        if s then
                            operationState = false
                            confirmOption = { "deleteJobRank", ("Supprimer le grade (%s)"):format(ranks[selectedRank].label), "ranks_manage", true, { selectedRank } }
                        end
                    end, RMenu:Get(cat, sub("confirm")))
                else
                    RageUI.GoBack()
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("ranks_manage_create")), true, true, true, function()
                baseSep()
                RageUI.ButtonWithStyle("Nom du grade", nil, {RightLabel = NarcosClient.MenuHelper.defineLabelString(rankBuilder.label)}, true, function(_,_,s)
                    if s then
                        local label = NarcosClient.InputHelper.showBox("Nom du grade", "", 20, false)
                        if label ~= nil then
                            rankBuilder.label = label
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~g~Créer le grade", nil, {}, rankBuilder.label ~= nil, function(_,_,s)
                    operationState = false
                    confirmOption = { "createJobRank", ("Creation grade (%s)"):format(rankBuilder.label), "ranks_manage", true, { rankBuilder.label } }
                end, RMenu:Get(cat, sub("confirm")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("ranks_manage_permissions")), true, true, true, function()
                if ranks[selectedRank] then
                    baseSep()
                    RageUI.Separator(("Selection: ~o~%s"):format(ranks[selectedRank].label))
                    RageUI.ButtonWithStyle("~b~Appliquer les permissions", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            operationState = false
                            confirmOption = { "setJobRankPermissions", ("Modif. permissions (%s)"):format(ranks[selectedRank].label), "ranks_manage_permissions", true, { selectedRank, permissionsEditor[selectedRank] } }
                        end
                    end, RMenu:Get(cat, sub("confirm")))
                    RageUI.Separator("↓ ~r~Permissions ~s~↓")
                    for _, k in pairs(customPermOrder) do
                        RageUI.Checkbox(("%s%s"):format(NarcosClient.MenuHelper.greenIfTrue(permissionsEditor[selectedRank][k].grant),permissionsEditor[selectedRank][k].label), nil, permissionsEditor[selectedRank][k].grant, { Style = RageUI.CheckboxStyle.Tick }, function(_, _, _, c)
                            permissionsEditor[selectedRank][k].grant = c
                        end, function()
                        end, function()
                        end)
                    end
                else
                    RageUI.GoBack()
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("confirm")), true, true, true, function()
                baseSep()
                RageUI.Separator(("~s~\"~b~%s~s~\""):format(confirmOption[2]))
                if not operationState then
                    RageUI.ButtonWithStyle("~r~Oups, retour en arrière", nil, {}, true, function(_, _, s)
                        if s then
                            RageUI.Visible(RMenu:Get(cat, sub(confirmOption[3])), true)
                        end
                    end)
                    RageUI.ButtonWithStyle("~o~Confirmer l'opération", nil, {}, true, function(_, _, s)
                        if s then
                            if confirmOption[4] then
                                serverUpdating = true
                            end
                            NarcosClient.toServer(confirmOption[1], name, confirmOption[5])
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("~g~Opération complétée", nil, { RightLabel = "~g~Retour~s~ →→" }, true, function(_, _, s)
                        if s then
                            RageUI.Visible(RMenu:Get(cat, sub(confirmOption[3])), true)
                        end
                    end)
                end
            end, function()
            end)
            Wait(0)
        end
    end)
end)

Narcos.netHandle("serverReturnedCb", function()
    operationState = true
end)