---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [30/06/2021 12:35]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netHandle("jobsLoaded", function()
    NarcosServer_JobsManager.precise["police"] = {
        garageVehicles = {
            ["fb2"] = {color = {80, 128, 74}}
        },

        vehiclesOut = {
            {pos = vector3(-482.66, 6024.72, 31.34), heading = 228.71}
        }
    }
end)