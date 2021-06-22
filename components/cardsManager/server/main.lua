---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [23/06/2021 01:21]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@param player Player
Narcos.netHandle("playerObjectLoaded", function(_src)
    local player = NarcosServer_PlayersManager.get(_src)
    local cards = {}
    NarcosServer_MySQL.query("SELECT * FROM cards WHERE owner = @a", {
        ['a'] = player:getLicense()
    }, function(result)
        for k,v in pairs(result) do
            cards[k] = {id = v.id, owner = v.owner, number = v.number, pin = v.pin, history = json.decode(v.history)}
        end
        player:setCache("cards", cards)
    end)
end)