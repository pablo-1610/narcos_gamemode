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
---@field public money number
---@field public ranks table
---@field public positions table
---@field public zonesRelatives table
---@field public blipsRelatives table
---@field public type number
---@field public inventory Inventory
Job = {}
Job.__index = Job

setmetatable(Job, {
    __call = function(_, name, label, money, ranks, positions, type)
        local self = setmetatable({}, Job);
        self.name = name
        self.label = label
        self.money = money
        self.ranks = {}
        for k,v in pairs(ranks) do
           self.ranks[k] = JobRank(v.label, v.permissions)
        end
        self.positions = positions
        self.zonesRelatives = {}
        for k, v in pairs(self.positions) do
            self.zonesRelatives[k] = NarcosServer_ZonesManager.createPrivate(v.location, 22, {r = 158, g = 245, b = 66, a = 255}, function(source)
                self:interactWithZone(source, k)
            end, ("Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec %s"):format(v.desc), 20.0, 1.0)
        end
        self.type = type
        self.inventory = NarcosServer_InventoriesManager.getOrCreate(("job:%s"):format(self.name), ("Entrepôt %s"):format(label), 100.0, 2)
        NarcosServer_JobsManager.list[self.name] = self
        return self;
    end
})

---interactWithZone
---@public
---@return void
function Job:interactWithZone(_src, zone)

end
