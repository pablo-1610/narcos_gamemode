---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 18:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_PlayersManager = {}
NarcosServer_PlayersManager.list = {}

NarcosServer_PlayersManager.add = function(source, identifiers)
    NarcosServer.trace(("Le joueur ^3%s^7 se ^2connecte"):format(GetPlayerName(source)), Narcos.prefixes.connection)
    Player(source, identifiers)
end

NarcosServer_PlayersManager.remove = function(source)
    NarcosServer.trace(("Le joueur ^3%s^7 se ^1déconnecte"):format(GetPlayerName(source)), Narcos.prefixes.connection)
    NarcosServer_PlayersManager.list[source] = nil
end

NarcosServer_PlayersManager.exists = function(source)
    return (NarcosServer_PlayersManager.list[source] ~= nil)
end

NarcosServer_PlayersManager.get = function(source)
    if not NarcosServer_PlayersManager.exists(source) then
        return
    end
    return NarcosServer_PlayersManager.list[source]
end

---@param player Player
NarcosServer_PlayersManager.register = function(player)
    --[[
    MySQL.Async.insert("INSERT INTO players (lastInGameId, license, name, body, outfits, selectedOutfit, identity, cash) VALUES(@a, @b, @c, @d, @e, @f, @g, @i)", {
                ['a'] = self.source,
                ['b'] = self:getLicense(),
                ['c'] = self:getName(),
                ['d'] = json.encode({}),
                []
            })
    --]]
end

Narcos.netRegisterAndHandle("playerJoined", function()
    local _src = source
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    if player:getIsNewPlayer() then
        NarcosServer.trace(("Le joueur ^3%s^7 est nouveau ! Bienvenue"):format(player.name), Narcos.prefixes.connection)
        NarcosServer.toClient("creatorInitialize", _src)
    end
end)

Narcos.netHandle("sideLoaded", function()
    MySQL.Async.execute("UPDATE players SET lastInGameId = 0", {})
end)

--- @HANDLERS playerConnecting
AddEventHandler("playerConnecting", function(name, _, deferrals)
    local _src = source
    local identifiers = NarcosServer.getIdentifiers(source)
    deferrals.update("Vérification de vos identifiants...")
    Wait(500)
    if not identifiers['fivem'] then
        deferrals.done("Impossible de trouver votre licence RockStar, veuillez réessayer !")
    end
    deferrals.done()
    NarcosServer_PlayersManager.add(_src, identifiers)
end)

--- @HANDLERS playerDropped
AddEventHandler('playerDropped', function (reason)
    local _src = source
    NarcosServer_PlayersManager.remove(_src)
end)