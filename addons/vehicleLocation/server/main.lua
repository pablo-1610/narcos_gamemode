---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 07:43]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_BlipsManager.createPublic(NarcosConfig_Server.locationNpc.pos, 409, 28, NarcosConfig_Server.blipsScale, "Location de véhicules", true)
local npc = NarcosServer_NpcsManager.createPublic(NarcosConfig_Server.locationNpc.type, false, true, { coords = NarcosConfig_Server.locationNpc.pos, heading = NarcosConfig_Server.locationNpc.heading }, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT_FACILITY", nil)
npc:setInvincible(true)
NarcosServer_ZonesManager.createPublic(NarcosConfig_Server.locationPosition, 20, { r = 255, g = 255, b = 255, a = 130 }, function(source)
    npc:playSpeech("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
    NarcosServer.toClient("vehicleLocationOpen", source, NarcosConfig_Server.locationVehicles)
end, "Appuyez sur ~INPUT_CONTEXT~ pour accéder à la location de véhicules", 20.0, 1.0)

