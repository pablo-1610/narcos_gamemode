---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [Player] created at [13/06/2021 18:33]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Player
---@field public source number
---@field public identifiers table
---@field public name string
---@field public ingame boolean
---@field public newPlayer boolean
---@field public id number
---@field public rank Rank
---@field public body table
---@field public outfits table
---@field public selectedOutfit number
---@field public identity string
---@field public cash number
---@field public position table
---@field public cityInfos table
---@field public vip number
---@field public loadout table
---@field public params table
---@field public inventory Inventory
---@field public cache table

Player = {}
Player.__index = Player

setmetatable(Player, {
    ---@param source number
    ---@param identifiers table
    __call = function(_, source, identifiers, anormalLoad)
        local self = setmetatable({}, Player);
        self.source = source
        self.cache = {}
        self.name = GetPlayerName(source)
        self.identifiers = identifiers
        self.ingame = false
        self.rank = NarcosServer_RanksManager.get(NarcosConfig_Server.defaultRank)
        self.inventory = NarcosServer_InventoriesManager.getOrCreate(identifiers['license'], ("Sac de %s"):format(self.name), 20.0, 1)
        NarcosServer_PlayersManager.list[tonumber(source)] = self
        self:asyncLoadData(anormalLoad)
        return self
    end
})

-- Getters

---asyncLoadData
---@public
---@return void
function Player:asyncLoadData(anormalLoad)
    NarcosServer_MySQL.query("SELECT * FROM players WHERE license = @a", { ['a'] = self:getLicense() }, function(result)
        if result[1] then
            self.newPlayer = false
            self.rank = NarcosServer_RanksManager.get(result[1].rank, true)
            self.body = json.decode(result[1].body)
            self.outfits = json.decode(result[1].outfits)
            self.selectedOutfit = result[1].selectedOutfit
            self.identity = json.decode(result[1].identity)
            self.cash = result[1].cash
            self.position = json.decode(result[1].position)
            self.cityInfos = json.decode(result[1].cityInfos)
            if not NarcosServer_JobsManager.exists(self.cityInfos["job"].id) then
                ---@type Job
                local unemployed = NarcosServer_JobsManager.get(NarcosConfig_Server.defaultJob)
                self.cityInfos["job"].id = NarcosConfig_Server.defaultJob
                self.cityInfos["job"].rank = (#unemployed.ranks)
            end
            self.vip = result[1].vip
            self.loadout = json.decode(result[1].loadout)
            self.params = json.decode(result[1].params)
            if not self.outfits[self.selectedOutfit] then
                local sort = {}
                for name, _ in pairs(self.outfits) do
                    table.insert(sort, name)
                end
                self.selectedOutfit = sort[math.random(1, #sort)]
            end
        else
            self.newPlayer = true
        end
        Narcos.toInternal("playerObjectLoaded", self.source)
        if anormalLoad then
            Narcos.toInternal(("%scomplete"):format(self.source), self)
        end
    end)
end

---getSource
---@public
---@return number
function Player:getSource()
    return self.source
end

---getName
---@public
---@return string
function Player:getName()
    return self.name
end

---getIsNewPlayer
---@public
---@return boolean
function Player:getIsNewPlayer()
    return self.newPlayer
end

---getIdentifiers
---@public
---@return table
function Player:getIdentifiers()
    return self.identifiers
end

---getLicense
---@public
---@return string
function Player:getLicense()
    return self.identifiers['license']
end

---getInGame
---@public
---@return boolean
function Player:getInGame()
    return self.ingame
end

---getRank
---@public
---@return Rank
function Player:getRank()
    return self.rank
end

---getCache
---@public
---@return void
---@param key any
function Player:getCache(key)
    return self.cache[key].data
end

---getInventory
---@public
---@return Inventory
function Player:getInventory()
    return NarcosServer_InventoriesManager.get(self:getLicense())
end

---getFullName
---@public
---@return string
function Player:getFullName()
    return ("%s %s"):format(self.identity.firstname, self.identity.lastname:upper())
end

---getJobName
---@public
---@return string
function Player:getJobName()
    return self.cityInfos["job"].id
end

-- Setters

---setInGame
---@public
---@return void
---@param boolean boolean
function Player:setInGame(boolean)
    self.ingame = boolean
end

---setRank
---@public
---@return void
---@param rank string
function Player:setRank(rank)
    self.rank = rank
end

---setCash
---@public
---@return void
---@param cash number
function Player:setCash(cash)
    self.cash = cash
    self:sendData()
end

---setRankFromId
---@public
---@return void
---@param rankId string
function Player:setRankFromId(rankId, cb)
    if not NarcosServer_RanksManager.exists(rankId) then
        return
    end
    self.rank = NarcosServer_RanksManager.get(rankId)
    cb(self.rank)
end

---showNotification
---@public
---@return void
---@param message string
function Player:showNotification(message)
    NarcosServer.toClient("showNotification", self.source, message)
end

---showAdvancedNotification
---@public
---@return void
---@param sender string
---@param subject string
---@param msg string
---@param textureDict string
---@param iconType number
---@param sound boolean
function Player:showAdvancedNotification(sender, subject, msg, textureDict, iconType, sound)
    NarcosServer.toClient("showAdvancedNotification", self.source, sender, subject, msg, textureDict, iconType, sound)
end

---setRankById
---@public
---@return void
---@param rankId string
function Player:setRankById(rankId)
    if not NarcosServer_RanksManager.exists(rankId) then
        return
    end
    ---@type Rank
    local rank = NarcosServer_RanksManager.get(rankId)
    self.rank = rank
end

-- Utils

---updateJob
---@public
---@return void
---@param oldJobId string
---@param newJob Job
---@param rank number
---@param cb function
function Player:updateJob(newJob, rank, cb)

end

---sendSystemMessage
---@public
---@return void
---@param title string
---@param message string
function Player:sendSystemMessage(title, message)
    self:showAdvancedNotification("Système", title, message, "CHAR_LESTER_DEATHWISH", false)
end

---setCache
---@public
---@return void
---@param index any
---@param value any
function Player:setCache(index, value)
    if self.cache[index] == nil then
        self.cache[index] = {}
    end
    self.cache[index].data = value
end

---setCacheDisconnectRule
---@public
---@return void
---@param index any
---@param value any
function Player:setCacheDisconnectRule(index, value)
    if self.cache[index] == nil then
        self.cache[index] = {}
    end
    self.cache[index].disconnect = value
end

---canAfford
---@public
---@return boolean
---@param price number
function Player:canAfford(price)
    return (self.cash >= price)
end

---removeCash
---@public
---@return void
---@param ammount number
function Player:removeCash(ammount)
    local fake = (self.cash - ammount)
    if fake <= 0 then
        self.cash = 0
    else
        self.cash = fake
    end
    self:sendData()
end

---addCash
---@public
---@return void
---@param ammount number
function Player:addCash(ammount)
    self.cash = (self.cash + ammount)
    self:sendData()
end

---addWeapon
---@public
---@return void
---@param weapon string
---@param ammount number
---@param cb function
function Player:addWeapon(weapon, ammount, cb)
    if not self.loadout[weapon] then
        self.loadout[weapon] = {ammo = 0}
    end
    self.loadout[weapon].ammo = (self.loadout[weapon].ammo + ammount)
    NarcosServer.toClient("receiveLoadout", self.source, {model = weapon, ammo = ammount})
    self:sendData(function()
        if cb ~= nil then
            cb()
        end
    end)
end

---clearWeapons
---@public
---@return void
---@param cb function
function Player:clearWeapons(cb)
    self.loadout = {}
    NarcosServer.toClient("clearLoadout", self.source)
    self:sendData(function()
        if cb ~= nil then
            cb()
        end
    end)
end

---pay
---@public
---@return void
---@param ammount number
---@param cb function
function Player:pay(ammount, cb)
    if (self.cash < ammount) then
        cb(false, (ammount - self.cash))
    else
        self.cash = (self.cash - ammount)
        self:sendData(function()
            cb(true)
        end)
    end
end

---savePlayer
---@public
---@return void
function Player:savePlayer()
    NarcosServer_MySQL.execute("UPDATE players SET cash = @a, cityInfos = @b, rank = @d, loadout = @e WHERE license = @c", {
        ['a'] = self.cash,
        ['b'] = json.encode(self.cityInfos),
        ['c'] = self:getLicense(),
        ['d'] = self.rank.id,
        ['e'] = json.encode(self.loadout)
    })
end

---sendData
---@public
---@return void
---@param cb function
function Player:sendData(cb)
    NarcosServer.toClient("updateLocalData", self.source, { player = self, inventory = NarcosServer_InventoriesManager.get(self:getLicense()) })
    if cb ~= nil then
        cb()
    end
end

---savePosition
---@public
---@return void
---@param position table
function Player:savePosition(position)
    position = json.encode(position)
    if self.cash == nil then
        return
    end
    NarcosServer_MySQL.execute("UPDATE players SET position = @a WHERE license = @b", {
        ['a'] = position,
        ['b'] = self:getLicense()
    })
end

---kick
---@public
---@return void
---@param reason string
function Player:kick(reason)
    DropPlayer(self.source, reason)
end

