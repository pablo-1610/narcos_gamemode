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
---@field public identifier string
---@field public label string
---@field public capacity number
---@field public type number
---@field public content table
Inventory = {}
Inventory.__index = Inventory

setmetatable(Inventory, {
    __call = function(_, identifier, label, capacity, type, content)
        local self = setmetatable({}, Inventory);
        self.identifier = identifier
        self.label = label
        self.capacity = capacity
        self.type = type
        self.content = content
        NarcosServer_InventoriesManager.list[self.identifier] = self
        return self;
    end
})

---getContent
---@public
---@return table
function Inventory:getContent()
    return self.content
end
