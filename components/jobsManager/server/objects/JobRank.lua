---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [JobRank] created at [21/06/2021 06:28]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class JobRank
---@field public label string
---@field public permissions table
---@field public outfit table
---@field public salary number
---@field public id number
JobRank = {}
JobRank.__index = JobRank

setmetatable(JobRank, {
    __call = function(_, label, permissions, outfit, salary, id)
        local self = setmetatable({}, JobRank);
        self.label = label
        self.permissions = permissions
        self.outfit = outfit
        self.salary = salary
        self.id = id
        return self;
    end
})

---hasPermission
---@public
---@param permission string
function JobRank:hasPermission(permission)
    if self.id == 1 then return true end
    return (self.permissions[permission] or false)
end