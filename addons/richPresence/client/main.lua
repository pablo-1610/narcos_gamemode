---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [27/05/2021 17:08]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netHandleBasic("esxloaded", function()
    NarcosClient_DiscordRpManager.invokeRpc(
            {
                id = 847445071015051264,
                text = "Se promène dans la nature",
                image = "city",
                buttons = {
                    {"Discord", "https://discord.gg/JjkVfQByVE"},
                }
            }
    )
end)