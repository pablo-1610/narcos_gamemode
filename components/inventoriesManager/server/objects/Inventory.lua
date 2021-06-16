---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [Inventory] created at [16/06/2021 12:10]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Inventory
Inventory = {}
Inventory.__index = Inventory

setmetatable(Inventory, {
    __call = function(_)
        local self = setmetatable({}, Inventory);

        return self;
    end
})
