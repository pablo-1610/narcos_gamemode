---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [30/06/2021 12:35]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local npc, object

local function createAmbiantNpc()
    npc = NarcosServer_NpcsManager.createPublic("s_m_y_cop_01", false, true, {coords = vector3(433.79, -978.54, 30.70), heading = 95.35}, "WORLD_HUMAN_GUARD_STAND")
    npc:setInvincible(true)
    npc:setHoldingWeapon("weapon_specialcarbine")
    npc = NarcosServer_NpcsManager.createPublic("s_m_y_cop_01", false, true, {coords = vector3(433.77, -985.31, 30.7), heading = 95.35}, "WORLD_HUMAN_GUARD_STAND")
    npc:setInvincible(true)
    npc:setHoldingWeapon("weapon_specialcarbine")

    npc = NarcosServer_NpcsManager.createPublic("s_m_y_cop_01", false, true, {coords = vector3(431.82, -972.61, 30.71), heading = 40.20}, "CODE_HUMAN_MEDIC_TIME_OF_DEATH")
    npc:setInvincible(true)

    -- ROUTE
    npc = NarcosServer_NpcsManager.createPublic("s_m_y_cop_01", false, true, {coords = vector3(400.69, -1015.11, 29.42), heading = 184.24}, "WORLD_HUMAN_CAR_PARK_ATTENDANT")
    npc:setInvincible(true)

    npc = NarcosServer_NpcsManager.createPublic("s_m_y_cop_01", false, true, {coords = vector3(402.16, -1014.95, 29.36), heading = 184.24}, "WORLD_HUMAN_GUARD_STAND_ARMY")
    npc:setInvincible(true)
    npc:setHoldingWeapon("weapon_combatpdw")

    -- PROPS
    object = NarcosServer_ObjectsManager.createPublic("prop_barrier_work04a", true, {coords = vector3(401.35, -1013.12, 29.41), heading = 355.0})
    object:setInvincible(true)

    object = NarcosServer_ObjectsManager.createPublic("prop_air_lights_05a", true, {coords = vector3(403.90, -1013.64, 29.27), heading = 336.0})
    object:setInvincible(true)

    -- CHIEN
    npc = NarcosServer_NpcsManager.createPublic("a_c_shepherd", false, true, {coords = vector3(431.08, -973.43, 30.71), heading = 40.20}, "WORLD_DOG_SITTING_ROTTWEILER")
    npc:setInvincible(true)
end

createAmbiantNpc()

NarcosServer_BlipsManager.createPublic(vector3(442.78, -984.40, 30.68), 137, 38, NarcosConfig_Server.blipsScale, "Commissariat central", true)

Narcos.netHandle("jobsLoaded", function()
    NarcosServer_JobsManager.precise["police"] = {
        vehCb = {
            vector3(462.47, -1014.79, 28.06),
            vector3(462.66, -1019.61, 28.10)
        },

        garageVehicles = {
            ["police"] = {color = {0, 0, 0}},
            ["police2"] = {color = {0,0,0}},
            ["police3"] = {color = {0,0,0}},
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