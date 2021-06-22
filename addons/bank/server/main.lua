---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 07:12]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local bankers = {
    {npcLoc = {coords = vector3(-109.94, 6469.19, 31.62), heading = 136.58}, zoneLoc = vector3(-111.43, 6467.60, 31.62)},
    {npcLoc = {coords = vector3(-111.94, 6471.39, 31.62), heading = 131.85}, zoneLoc = vector3(-113.55, 6469.75, 31.62)}
}
local npcs, zones = {}
local blip = NarcosServer_BlipsManager.createPublic(vector3(-114.50, 6468.57, 31.62), 207, 43, NarcosConfig_Server.blipsScale, "Banque centrale", true)

local function generateCardNum()
    local sb = ""
    for i = 1,3 do
        local nums = {math.random(1,9),math.random(1,9),math.random(1,9)}
        if i == 3 then
            sb = sb..("%s%s%s%s"):format(nums[1],nums[2],nums[3])
        else
            sb = sb..("%s%s%s%s "):format(nums[1],nums[2],nums[3])
        end
    end
    return sb
end

local function openBankMenu(_src, player)
    NarcosServer.toClient("bankOpenMenu", _src, player:getCache("cards"), generateCardNum())
end

for k, v in pairs(bankers) do
    local npc = NarcosServer_NpcsManager.createPublic("a_m_y_business_02", false, true, v.npcLoc, nil, nil)
    npc:setInvincible(true)
    npc:setDisplayInfos({name = "Banquier", range = 5.5, color = 0})
    bankers[k].zone = NarcosServer_ZonesManager.createPublic(v.zoneLoc, 20, { r = 255, g = 255, b = 255, a = 130 }, function(_src, player)
        bankers[k].npc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
        openBankMenu(_src, player)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour parler au banquier", 20.0, 1.0)
    bankers[k].npc = npc
end