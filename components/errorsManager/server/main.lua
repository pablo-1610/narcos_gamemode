---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 00:41]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_ErrorsManager = {}

NarcosServer_ErrorsManager.die = function(error, args, cb)
    NarcosServer.webhook(("Erreur #%s\n\nDétails: [%s]"):format(error, args), "red", NarcosConfig_Server.errorWebhook)
    if cb ~= nil then
        cb()
    end
    return
end
