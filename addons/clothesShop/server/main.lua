---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [01/07/2021 15:20]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local clothesShops = {}

Narcos.netHandle("sideLoaded", function()
    for id, clothesShop in pairs(NarcosConfig_Server.availableClothesShops) do
        clothesShops[id] = {}
        clothesShops[id].npc = NarcosServer_NpcsManager.createPublic("a_f_y_soucent_03", false, true, clothesShop.vendorNpcLoc, nil, nil)
        clothesShops[id].npc:setInvincible(true)
        clothesShops[id].npc:setDisplayInfos({ name = "Vendeuse", range = 5.5, color = 0 })
        clothesShops[id].blip = NarcosServer_BlipsManager.createPublic(clothesShop.vendorNpcLoc.coords, 73, 64, NarcosConfig_Server.blipsScale, "Boutique de vêtements", true)

        clothesShops[id].npcZone = NarcosServer_ZonesManager.createPublic(clothesShop.vendorNpcZone, 20, { r = 255, g = 255, b = 255, a = 130 }, function(_src, player)
            clothesShops[id].npc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
        end, "Appuyez sur ~INPUT_CONTEXT~ pour parler à la vendeuse", 20.0, 1.0)

        clothesShops[id].mainZone = NarcosServer_ZonesManager.createPublic(clothesShop.mainZone, 20, { r = 255, g = 255, b = 255, a = 130 }, function(_src, player)

        end, "Appuyez sur ~INPUT_CONTEXT~ pour vous changer", 20.0, 1.0)
    end
end)