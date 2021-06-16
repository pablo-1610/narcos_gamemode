---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [16/06/2021 12:33]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_InstancesManager = {}

NarcosServer_InstancesManager.setOnPublicInstance = function(source)
    SetPlayerRoutingBucket(source, 0)
end

NarcosServer_InstancesManager.setOnBannedInstance = function(source)
    SetPlayerRoutingBucket(source, NarcosConfig_Server.bannedInstance)
end

NarcosServer_InstancesManager.setInstance = function(source, instanceId)
    if instanceId == 0 then
        NarcosServer_InstancesManager.setOnPublicInstance(source)
    end
    if instanceId == NarcosConfig_Server.bannedInstance then
        NarcosServer_InstancesManager.setOnBannedInstance(source)
    end
    SetPlayerRoutingBucket(source, tonumber(instanceId))
end