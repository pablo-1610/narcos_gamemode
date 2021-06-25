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
        for k, v in pairs(ranks) do
            self.ranks[k] = JobRank(v.label, v.permissions)
        end
        self.positions = positions
        self.zonesRelatives = {}
        for k, v in pairs(self.positions) do
            self.zonesRelatives[k] = {}
            self.zonesRelatives[k].perm = v.perm
            self.zonesRelatives[k].zone = NarcosServer_ZonesManager.createPrivate(vector3(v.location.x, v.location.y, v.location.z), 20, { r = 255, g = 255, b = 255, a = 255 }, function(source)
                self:interactWithBaseZone(source, k)
            end, ("Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec %s"):format(v.desc), 20.0, 1.0)
            if v.blip.active then
                self.zonesRelatives[k].blip = NarcosServer_BlipsManager.createPrivate(vector3(v.location.x, v.location.y, v.location.z), v.blip.sprite, v.blip.color, NarcosConfig_Server.blipsScale, ("(%s) %s"):format(self.label, v.label), false)
            end
        end
        self.type = type
        self.inventory = NarcosServer_InventoriesManager.getOrCreate(("job:%s"):format(self.name), ("Entrepôt %s"):format(label), 100.0, 2)
        NarcosServer_JobsManager.list[self.name] = self
        return self;
    end
})

---handlePlayerJoined
---@public
---@return void
---@param _src number
---@param player Player
function Job:handlePlayerJoined(_src, player)
    ---@type JobRank
    local playerRank = self.ranks[player.cityInfos["job"].rank]
    for zoneName, zoneData in pairs(self.zonesRelatives) do
        if zoneData.perm ~= nil then
            if playerRank:hasPermission(zoneData.perm) then
                if zoneData.blip ~= nil then
                    NarcosServer_BlipsManager.addAllowed(zoneData.blip, _src)
                end
                NarcosServer_ZonesManager.addAllowed(zoneData.zone, _src)
            end
        else
            if zoneData.blip ~= nil then
                NarcosServer_BlipsManager.addAllowed(zoneData.blip, _src)
            end
            NarcosServer_ZonesManager.addAllowed(zoneData.zone, _src)
        end
    end
end

function Job:handlePlayerLeft(_src, player)
    local playerRank = self.ranks[player.cityInfos["job"].rank]
    for zoneName, zoneData in pairs(self.zonesRelatives) do
        if zoneData.perm ~= nil then
            if playerRank:hasPermission(zoneData.perm) then
                if zoneData.blip ~= nil then
                    NarcosServer_BlipsManager.removeAllowed(zoneData.blip, _src)
                end
                NarcosServer_ZonesManager.removeAllowed(zoneData.zone, _src)
            end
        else
            if zoneData.blip ~= nil then
                NarcosServer_BlipsManager.removeAllowed(zoneData.blip, _src)
            end
            NarcosServer_ZonesManager.removeAllowed(zoneData.zone, _src)
        end
    end
end

function Job:interactWithBaseZone(source, zone)

end
