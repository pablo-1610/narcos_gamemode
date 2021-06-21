---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 05:11]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local index = 1
local table = NarcosConfig_Server.reminder

Narcos.netHandle("sideLoaded", function()
    while true do
        Wait(NarcosConfig_Server.reminderInterval)
        ---@param player Player
        for k, player in pairs(NarcosServer_PlayersManager.list) do
            player:showAdvancedNotification("Los Narcos","~o~Information",table[index],"CHAR_MP_FM_CONTACT",true)
        end
        index = (index + 1)
        if index > #table then
            index = 1
        end
    end
end)