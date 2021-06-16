---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [Item] created at [16/06/2021 12:03]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Item
---@field public name string
---@field public label string
---@field public weight number
Item = {}
Item.__index = Item

setmetatable(Item, {
    __call = function(_, name, label, weight)
        local self = setmetatable({}, Item);
        self.name = name
        self.label = label
        self.weight = weight
        NarcosServer_ItemsManager.list[name] = self
        return self;
    end
})
