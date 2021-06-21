---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:24]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer.registerConsoleCommand("addJob", function(source, args)
    if #args ~= 2 then
        NarcosServer.trace("Utilisation: ^3addJob <name> <label>", Narcos.prefixes.err)
        return
    end
    local job, label = args[1], args[2]
    NarcosServer_JobsManager.createJob(job, label)
end)