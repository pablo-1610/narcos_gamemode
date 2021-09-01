---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [30/06/2021 12:35]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_BlipsManager.createPublic(vector3(442.78, -984.40, 30.68), 137, 38, NarcosConfig_Server.blipsScale, "Commissariat central", true)

Narcos.netHandle("jobsLoaded", function()
    NarcosServer_JobsManager.precise["police"] = {
        vehCb = {
            vector3(462.47, -1014.79, 28.06),
            vector3(462.66, -1019.61, 28.10)
        },

        garageVehicles = {
            ["police"] = {color = {0, 0, 0}},
            ["fbi2"] = {color = {0, 0, 0}},
        },

        vehiclesOut = {
            {pos = vector3(446.01, -1026.23, 28.65), heading = 4.16},
            {pos = vector3(442.33, -1026.98, 28.72), heading = 8.78},
        },

        getMarkers = function()
            return {
                -- Custom markers
            }
        end,

        getBlips = function()
            return {
                -- Custom blips
            }
        end
    }
end)