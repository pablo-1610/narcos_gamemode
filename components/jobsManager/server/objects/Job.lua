---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [Job] created at [21/06/2021 04:29]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Job
Job = {}
Job.__index = Job

setmetatable(Job, {
    __call = function(_)
        local self = setmetatable({}, Job);

        return self;
    end
})
