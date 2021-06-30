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
            self.zonesRelatives[k].zone = NarcosServer_ZonesManager.createPrivate(vector3(v.location.x, v.location.y, v.location.z), 20, { r = 255, g = 255, b = 255, a = 255 }, function(source, player)
                self:interactWithBaseZone(source, player, k)
            end, ("Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec %s"):format(v.desc), 20.0, 1.0)
            if v.blip.active then
                self.zonesRelatives[k].blip = NarcosServer_BlipsManager.createPrivate(vector3(v.location.x, v.location.y, v.location.z), v.blip.sprite, v.blip.color, NarcosConfig_Server.blipsScale, ("(%s) %s"):format(self.label, v.label), false)
            end
        end
        self.type = type
        self.inventory = NarcosServer_InventoriesManager.getOrCreate(("job:%s"):format(self.name), ("Entrepôt %s"):format(label), 100.0, 2)
        NarcosServer_JobsManager.list[self.name] = self
        NarcosServer_JobsManager.precise[self.name] = {}
        return self;
    end
})

---openGarage
---@public
---@return void
---@param _src number
---@param player Player
---@param zone string
function Job:openGarage(_src, player, zone)
    ---@type JobRank
    local playerRank = self.ranks[player.cityInfos["job"].rank]
    if not playerRank then
        player:sendSystemMessage("~r~Erreur", "Une erreur est survenue")
        return
    end
    if not playerRank:hasPermission("GARAGE") then
        player:sendSystemMessage("~r~Erreur", "Vous n'avez pas la permission d'accéder au garage !")
        return
    end
    if not NarcosServer_JobsManager.precise[self.name].garageVehicles or NarcosServer.getTableLenght(NarcosServer_JobsManager.precise[self.name].garageVehicles) == 0 then
        player:sendSystemMessage("~r~Erreur", "Aucun véhicule n'est disponible")
        return
    end
    NarcosServer.toClient("jobGarageMenu", self.name, NarcosServer_JobsManager.precise[job.name].garageVehicles)
end

---handlePlayerJoined
---@public
---@return void
---@param _src number
---@param player Player
function Job:handlePlayerJoined(_src, player)
    ---@type JobRank
    for _, zoneData in pairs(self.zonesRelatives) do
        if zoneData.blip ~= nil then
            NarcosServer_BlipsManager.addAllowed(zoneData.blip, _src)
        end
        NarcosServer_ZonesManager.addAllowed(zoneData.zone, _src)
    end
end

---handlePlayerLeft
---@public
---@return void
---@param _src number
---@param player Player
function Job:handlePlayerLeft(_src, player)
    for _, zoneData in pairs(self.zonesRelatives) do
        if zoneData.blip ~= nil then
            NarcosServer_BlipsManager.removeAllowed(zoneData.blip, _src)
        end
        NarcosServer_ZonesManager.removeAllowed(zoneData.zone, _src)
    end
end

local actionByBaseZones = {
    ---@param job Job
    ["GARAGE"] = function(job, _src, player, zone)
        job:openGarage(_src, player, zone)
    end
}

---interactWithBaseZone
---@public
---@return void
---@param _src number
---@param player Player
---@param zone string
function Job:interactWithBaseZone(_src, player, zone)
    if actionByBaseZones[zone] then
        actionByBaseZones[zone](self, _src, player, zone)
    end
end
