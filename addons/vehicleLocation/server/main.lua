---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 07:43]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local object = NarcosServer_ObjectsManager.createPublic("sm_prop_smug_heli", true, {coords = vector3(-745.31, -1468.63, 5.00), heading = 336.0})
object:setInvincible(true)

local ped = NarcosServer_NpcsManager.createPublic("s_m_y_airworker", false, true, {coords = vector3(-739.19, -1466.77, 5.00), heading = 90.0}, "CODE_HUMAN_POLICE_INVESTIGATE")
ped:setInvincible(true)
local pedName = ped:setRandomName()

---@param player Player
local test = NarcosServer_ZonesManager.createPublic(vector3(-740.31, -1466.88, 5.00), 20, {r = 255, g = 255, b = 255, a = 255}, function(_src, player)
    ped:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
    ped:sendMessageToPlayer(_src, ("~r~%s"):format(pedName), "~y~Observation", "Hmm... Il s'est passé quelque chose d'étrange ici, comme si il y avait eu un crash")
end, "Appuyez sur ~INPUT_CONTEXT~ pour dire bonjour", 2.0, 1.0)

local npc, blip, zone










Narcos.netHandle("sideLoaded", function()
    blip = NarcosServer_BlipsManager.createPublic(NarcosConfig_Server.locationNpc.pos, 409, 28, NarcosConfig_Server.blipsScale, "Location de véhicules", true)

    npc = NarcosServer_NpcsManager.createPublic(NarcosConfig_Server.locationNpc.type, false, true, { coords = NarcosConfig_Server.locationNpc.pos, heading = NarcosConfig_Server.locationNpc.heading }, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT_FACILITY", nil)
    npc:setInvincible(true)
    npc:setDisplayInfos({name = "Francisco Faggio", range = 5.5, color = 0})

    zone = NarcosServer_ZonesManager.createPublic(NarcosConfig_Server.locationPosition, 20, { r = 255, g = 255, b = 255, a = 130 }, function(_src)
        npc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
        NarcosServer.toClient("vehicleLocationOpen", source, NarcosConfig_Server.locationVehicles)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour accéder à la location de véhicules", 20.0, 1.0)
end)

Narcos.netRegisterAndHandle("locationRent", function(vehicleId)
    local _src = source
    local selectedVehicle = NarcosConfig_Server.locationVehicles[vehicleId]
    if not NarcosServer_PlayersManager.exists(_src) then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("locationRent (%s)"):format(_src), _src)
    end
    if not selectedVehicle then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.INVALID_PARAM, ("locationRent (%s/%s)"):format(_src, vehicleId), _src)
    end
    local price = selectedVehicle.price
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    if not player:canAfford(price) then
        npc:playSpeechForPlayer("GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
        player:showAdvancedNotification("Location","~r~Erreur","Vous n'avez pas assez d'argent pour acheter ce véhicule !","CHAR_AGENT14",false)
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    player:removeCash(price)
    player:sendData(function()
        npc:playSpeechForPlayer("GENERIC_THANKS", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
        player:showAdvancedNotification("Location","~g~Succès","Merci pour votre achat, et bonne route !","CHAR_AGENT14",false)
        local veh = CreateVehicle(GetHashKey(selectedVehicle.model), NarcosConfig_Server.locationOut.pos, NarcosConfig_Server.locationOut.heading, true, true)
        while veh == nil do Wait(1) end
        TaskWarpPedIntoVehicle(GetPlayerPed(_src), veh, -1)
        NarcosServer.toClient("serverReturnedCb", _src)
    end)
end)