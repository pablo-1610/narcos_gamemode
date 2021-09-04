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
---@field public ranksClone table
---@field public positions table
---@field public zonesRelatives table
---@field public blipsRelatives table
---@field public type number
---@field public inventory Inventory
---@field public employees table
Job = {}
Job.__index = Job

setmetatable(Job, {
    __call = function(_, name, label, money, ranks, positions, type)
        local self = setmetatable({}, Job);
        self.name = name
        self.label = label
        self.money = money
        self.employees = employees
        self.ranks = {}
        self.employees = {}
        NarcosServer_MySQL.query("SELECT * FROM job_employees WHERE job_id = @job_id", {
            ["job_id"] = self.name
        }, function(result)
            for k, v in pairs(result) do
                self.employees[v.identifier] = v.rank
            end
        end)
        for k, v in pairs(ranks) do
            self.ranks[k] = JobRank(v.label, v.permissions, v.outfit, v.salary)
        end
        self.ranksClone = self.ranks
        self.positions = positions
        self.zonesRelatives = {}
        for k, v in pairs(self.positions) do
            self.zonesRelatives[k] = {}
            self.zonesRelatives[k].perm = v.perm
            self.zonesRelatives[k].zone = NarcosServer_ZonesManager.createPrivate(vector3(v.location.x, v.location.y, v.location.z), 20, { r = 255, g = 255, b = 255, a = 255 }, function(source, player)
                self:interactWithBaseZone(source, player, k)
            end, ("Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec %s"):format(v.desc), 20.0, 1.0)
            if v.blip.active then
                self.zonesRelatives[k].blip = NarcosServer_BlipsManager.createPrivate(vector3(v.location.x, v.location.y, v.location.z), v.blip.sprite, v.blip.color, NarcosConfig_Server.blipsScale, ("(%s) %s"):format(self.label, v.label), true)
            end
        end
        self.type = type
        self.inventory = NarcosServer_InventoriesManager.getOrCreate(("job:%s"):format(self.name), ("Entrepôt %s"):format(label), 100.0, 2)
        NarcosServer_JobsManager.list[self.name] = self
        NarcosServer_JobsManager.precise[self.name] = {}
        Narcos.newWaitingThread(1, function()
            if NarcosServer_JobsManager.precise[self.name] ~= nil then
                local additionalData = NarcosServer_JobsManager.precise[self.name]
                if additionalData.vehCb ~= nil then
                    for k, v in pairs(additionalData.vehCb) do
                        local uniqueId = ("VEHCB%s"):format(k)
                        self.zonesRelatives[uniqueId] = {}
                        self.zonesRelatives[uniqueId].blip = NarcosServer_BlipsManager.createPrivate(v, 357, 75, 0.75, ("(%s) Retour véhicules de fonction"):format(self.label), true)
                        self.zonesRelatives[uniqueId].zone = NarcosServer_ZonesManager.createPrivate(v, 20, { r = 255, g = 82, b = 82, a = 255 }, function(source, player)
                            local veh = GetVehiclePedIsIn(GetPlayerPed(source), false)
                            if not DoesEntityExist(veh) then
                                player:sendSystemMessage(NarcosEnums.Prefixes.ERR, "Vous n'êtes dans aucun véhicule")
                                return
                            end
                            DeleteEntity(veh)
                            player:sendSystemMessage(NarcosEnums.Prefixes.SUC, "Véhicule rangé")
                        end, "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule", 20.0, 1.0)
                    end
                end
            end
        end)
        return self;
    end
})

function Job:areRankWaitingReboot()
    return false
end

---openManager
---@public
---@return void
---@param _src number
---@param player Player
---@param zone string
function Job:openManager(_src, player, zone)
    local playerRank = self.ranks[player.cityInfos["job"].rank]
    if not playerRank then
        player:sendSystemMessage("~r~Erreur", "Une erreur est survenue")
        return
    end
    if not playerRank == 1 or not playerRank:hasPermission("MANAGE") then
        player:sendSystemMessage("~r~Erreur", "Vous n'avez pas la permission d'accéder au manager !")
        return
    end
    local employeesTable = {}
    -- Get Employee list
    NarcosServer_MySQL.query("SELECT identifier, identity, job_employees.rank FROM job_employees JOIN players ON job_employees.identifier = players.license WHERE job_id = @job_id ORDER BY job_employees.rank ASC", {["job_id"] = self.name}, function(result)
        for k,v in pairs(result) do
            v.identity = json.decode(v.identity)
            table.insert(employeesTable, v)
        end
        NarcosServer.toClient("jobManagerMenu", _src, employeesTable, self.ranksClone, self.label, self.name, (self:areRankWaitingReboot()))
    end)
end

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
    if not playerRank == 1 or not playerRank:hasPermission("MANAGE") then
        player:sendSystemMessage("~r~Erreur", "Vous n'avez pas la permission d'accéder au garage !")
        return
    end
    if not NarcosServer_JobsManager.precise[self.name].garageVehicles or NarcosServer.getTableLenght(NarcosServer_JobsManager.precise[self.name].garageVehicles) == 0 then
        player:sendSystemMessage("~r~Erreur", "Aucun véhicule n'est disponible")
        return
    end
    NarcosServer.toClient("jobGarageMenu", _src, self.name, NarcosServer_JobsManager.precise[self.name].garageVehicles)
end

---isEmployee
---@public
---@return void
---@param identifier string
function Job:isEmployee(identifier)
    return self.employees[identifier] ~= nil
end

---handlePlayerJoined
---@public
---@return void
---@param _src number
---@param player Player
function Job:handlePlayerJoined(_src, player)
    if self.name == NarcosConfig_Server.defaultJob then return end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    local identifier = player:getLicense()
    local rank = player.cityInfos["job"].rank
    if self.employees[identifier] then
        -- Security check
        self.employees[identifier] = rank
    else
        self.employees[identifier] = rank
        NarcosServer_MySQL.execute("INSERT INTO job_employees (identifier, job_id, rank) VALUES(@identifier, @job_id, @rank)", {
            ["identifier"] = identifier,
            ["job_id"] = self.name,
            ["rank"] = rank
        })
    end
    for id, zoneData in pairs(self.zonesRelatives) do
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
    if self.name == NarcosConfig_Server.defaultJob then return end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    local identifier = player:getLicense()
    if self.employees[identifier] then
        self.employees[identifier] = nil
        NarcosServer_MySQL.execute("DELETE FROM job_employees WHERE identifier = @identifier AND job_id = @job_id", {
            ["identifier"] = identifier,
            ["job_id"] = self.name,
        })
    end
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
    end,

    ---@param job Job
    ["MANAGER"] = function(job, _src, player, zone)
        job:openManager(_src, player, zone)
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

---updateEmployees
---@public
---@return void
function Job:getEmployeesSorted(cb)
    local employeesTable = {}
    -- Get Employee list
    NarcosServer_MySQL.query("SELECT identifier, identity, job_employees.rank FROM job_employees JOIN players ON job_employees.identifier = players.license WHERE job_id = @job_id ORDER BY job_employees.rank ASC", {["job_id"] = self.name}, function(result)
        for k,v in pairs(result) do
            v.identity = json.decode(v.identity)
            table.insert(employeesTable, v)
        end
        cb(employeesTable)
    end)
end
