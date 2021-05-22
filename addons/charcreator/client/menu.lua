---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [menu] created at [21/05/2021 17:31]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netHandle("creatorMenu", function()
    if isAMenuActive then
        return
    end
    isAMenuActive = true
    if not PabloUI:PanelExists("creator") then
        ---@type Panel
        local panel = PabloUI:CreatePanel("creator", "Créateur", "Customisation du personnage", {255,0,0})
        panel:SetClosable(false)

        ---@type Panel
        local subPanel = PabloUI:CreatePanel("identity", "Créateur", "Identité du personnage", {255,0,255})
        subPanel:SetDepend("creator")

        panel:SetElement(1, Panel.CreateButton("Identité de mon personnage", ">>", nil, function()
            ESX.ShowNotification("Ok !")
        end, "identity"))
        panel:SetElement(2, Panel.CreateButton("Traits du visage", ">>"))
        panel:SetElement(4, Panel.CreateCheckBox("Coucou", nil, function(newValue)
            ESX.ShowNotification(("Value: %s"):format(json.encode(newValue)))
        end, false))
    end
    PabloUI:DisplayPanel(PabloUI:GetPanel("creator"))
end)