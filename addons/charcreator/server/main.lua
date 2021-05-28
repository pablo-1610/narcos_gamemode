---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterNetEvent("esx:onPlayerSpawn")
Narcos.netHandleBasic("esx:onPlayerSpawn", function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer.identity == "" then
        SetPlayerRoutingBucket(_src, 1500+_src)
        NarcosServer.toClient("creatorStarts", _src)
    else
        local tenue = {}

        if not xPlayer.tenues or xPlayer.tenues == "" then
            tenue = {
                ['shoes_1'] = 16,
                ['shoes_2'] = 11,
                ['pants_1'] = 12,
                ['pants_2'] = 0,
                ['tshirt_1'] = 15,
                ['tshirt_2'] = 0,
                ['torso_1'] = 39,
                ['torso_2'] = 1,
                ['arms'] = 0,
            }

        else
            local all = json.decode(xPlayer.tenues)
            tenue = all[xPlayer.selectedTenue] or tenue
        end
        NarcosServer.toClient("creatorSetBaseSkin", _src, json.decode(xPlayer.baseCharacter), tenue)
    end
end)

Narcos.netRegisterAndHandle("creatorRegister", function(identity, face)
    local _src = source
    SetPlayerRoutingBucket(_src, 0)
    local xPlayer = ESX.GetPlayerFromId(_src)
    local license = xPlayer.identifier
    ESX.GetPlayerFromId(_src).baseCharacter = json.decode(xPlayer.baseCharacter)
    local tenue = {
        ['shoes_1'] = 16,
        ['shoes_2'] = 11,
        ['pants_1'] = 12,
        ['pants_2'] = 0,
        ['tshirt_1'] = 15,
        ['tshirt_2'] = 0,
        ['torso_1'] = 39,
        ['torso_2'] = 1,
        ['arms'] = 0,
    }
    NarcosServer.toClient("creatorSetBaseSkin", _src, face, tenue)
    MySQL.Async.execute("UPDATE users SET identity = @a, baseCharacter = @b WHERE identifier = @c", {
        ['a'] = json.encode(identity),
        ['b'] = json.encode(face),
        ['c'] = license
    })
end)