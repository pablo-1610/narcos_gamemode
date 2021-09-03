---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [04/09/2021 00:01]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local announceTask

Narcos.netRegisterAndHandle("receiveAnnounce", function(message)
    if announceTask ~= nil then
        Narcos.cancelTaskNow(announceTask)
    end
    announceTask = Narcos.newRepeatingTask(function()
        print("Sheesh")
    end, function()

    end, 0, 1)
end)