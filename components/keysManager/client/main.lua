---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 18:37]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient_KeysManager = {}

---addKey
---@public
---@return void
NarcosClient_KeysManager.addKey = function(defaultKey, desc, action)
    local commandUuid = Narcos.uuid()
    RegisterCommand(("+narcos_%s"):format(commandUuid), function(source, args)
        action(source)
    end)
    RegisterKeyMapping(("+narcos_%s"):format(commandUuid), desc, "keyboard", defaultKey)
end