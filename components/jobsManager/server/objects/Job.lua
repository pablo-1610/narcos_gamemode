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
---@field public name string
---@field public label string
---@field public ranks table
---@field public positions table
---@field public type number
Job = {}
Job.__index = Job

setmetatable(Job, {
    __call = function(_, name, label, ranks, positions, type)
        local self = setmetatable({}, Job);
        self.name = name
        self.label = label
        self.ranks = ranks
        self.positions = positions
        self.type = type
        NarcosServer_JobsManager.list[name] = self
        return self;
    end
})
