---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [30/06/2021 14:09]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local function clearDeadVehicles()
    for _, vehicle in ipairs(GetAllVehicles()) do
        if GetVehicleEngineHealth(vehicle) <= 0 then
            DeleteEntity(vehicle)
        end
    end
end

Narcos.netHandle("sideLoaded", function()
    Narcos.newRepeatingTask(function()
        clearDeadVehicles()
    end, function()
    end, 1, (Narcos.second(60)*5))
end)