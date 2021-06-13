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

Player = {}
Player.__index = Player

setmetatable(Player, {
    __call = function(_, source, identifiers)
        local self = setmetatable({}, Player);
        self.source = source
        self.name = GetPlayerName(source)
        self.identifiers = identifiers
        self.ingame = false
        self.rank = NarcosServer_RanksManager.get(NarcosConfig_Server.defaultRank)
        NarcosServer_PlayersManager.list[#NarcosServer_PlayersManager.list+1] = self
        self:asyncLoadData()
        return self
    end
})

-- Getters

---@public
---@return void
function Player:asyncLoadData()
    MySQL.Async.fetchAll("SELECT * FROM players WHERE license = @a", {['a'] = self:getLicense()}, function(result)
        if result[1] then
            self.newPlayer = false
            self.rank = NarcosServer_RanksManager.get(result.rank, true)
            self.body = json.decode(result.body)
            self.outfits = json.decode(result.outfits)
            self.selectedOutfit = result.selectedOutfit
            self.identity = json.decode(result.identity)
            self.cash = self.cash
            self.position = json.decode(result.position)
            if self.selectedOutfit > #self.outfits then
                self.selectedOutfit = self.outfits[#self.outfits]
            end
            MySQL.Async.execute("UPDATE players SET lastInGameId = @a WHERE license = @b", {['a'] = self:getSource(), ['b'] = self:getLicense()})
        else
            self.newPlayer = true
        end
    end)
end

---@public
---@return number
function Player:getSource()
    return self.source
end

---@public
---@return string
function Player:getName()
    return self.name
end

---@public
---@return boolean
function Player:getIsNewPlayer()
    return self.newPlayer
end

---@public
---@return table
function Player:getIdentifiers()
    return self.identifiers
end

---@public
---@return string
function Player:getLicense()
    return self.identifiers['license']
end

---@public
---@return boolean
function Player:getInGame()
    return self.ingame
end

---@public
---@return Rank
function Player:getRank()
    return self.rank
end

-- Setters

---@public
---@return void
function Player:setInGame(boolean)
    self.ingame = boolean
end

---@public
---@return void
function Player:setRank(rank)
    self.rank = rank
end

---@public
---@return void
function Player:setRankById(rankId)
    if not NarcosServer_RanksManager.exists(rankId) then
        return
    end
    ---@type Rank
    local rank = NarcosServer_RanksManager.get(rankId)
    self.rank = rank
end

-- Utils

---@public
---@return void
function Player:kick(reason)
    DropPlayer(self.source, reason)
end
