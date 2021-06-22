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
NarcosServer_PlayersManager.connecting = {}

NarcosServer_PlayersManager.add = function(source, identifiers)
    NarcosServer.trace(("Le joueur ^3%s^7 se ^2connecte ^7(id: %s)"):format(GetPlayerName(source), source), Narcos.prefixes.connection)
    Player(source, identifiers)
end

NarcosServer_PlayersManager.remove = function(source)
    NarcosServer.trace(("Le joueur ^3%s^7 se ^1déconnecte ^7(id: %s)"):format(GetPlayerName(source), source), Narcos.prefixes.connection)
    NarcosServer_InventoriesManager.removeFromCache(NarcosServer_PlayersManager.list[tonumber(source)].identifiers['license'])
    NarcosServer_PlayersManager.list[tonumber(source)] = nil
end

NarcosServer_PlayersManager.exists = function(source)
    return (NarcosServer_PlayersManager.list[source] ~= nil)
end

NarcosServer_PlayersManager.get = function(source)
    if not NarcosServer_PlayersManager.exists(source) then
        return
    end
    return NarcosServer_PlayersManager.list[tonumber(source)]
end

---@param player Player
NarcosServer_PlayersManager.register = function(source, creatorInfos, cb)
    --- @ERROR 401
    if not NarcosServer_PlayersManager.exists(source) then
        DropPlayer(source, "Une erreur est survenue (ERREUR 401), veuillez contacter un staff.")
        return
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(source)
    --- @ERROR 402
    if player.cash ~= nil then
        DropPlayer(source, "Une erreur est survenue (ERREUR 402), veuillez contacter un staff.")
        return
    end

    MySQL.Async.fetchAll("SELECT * FROM players WHERE license = @a", {
        ['a'] = player:getLicense()
    }, function(result)
        if result[1] then
            --- @ERROR 403
            DropPlayer(source, "Une erreur est survenue (ERREUR 403), veuillez contacter un staff.")
            NarcosServer_ErrorsManager.die(NarcosEnums.Errors.LICENSE_EXIST, ("license: %s"):format(player:getLicense()))
        else
            local identity, character, filter = creatorInfos[1], creatorInfos[2], creatorInfos[3]

            local body, outfits = {}, {}
            outfits["Explorateur"] = {}
            for component, id in pairs(character) do
                if filter[component] then
                    body[component] = id
                else
                    outfits["Explorateur"][component] = id
                end
            end

            local currentpos, baseCityInfos = { pos = NarcosConfig_Server.startingPosition, heading = NarcosConfig_Server.startingHeading }, NarcosConfig_Server.baseCityInfos
            MySQL.Async.execute("INSERT INTO players (lastInGameId, license, rank, name, body, outfits, selectedOutfit, identity, cityInfos, cash, position, vip, loadout, params) VALUES (@a, @b, @c, @d, @e, @f, @g, @h, @ct, @i, @j, @vip, @loadout, @pp)",
            {
                ['a'] = source,
                ['b'] = player:getLicense(),
                ['c'] = NarcosConfig_Server.defaultRank,
                ['d'] = GetPlayerName(source),
                ['e'] = json.encode(body),
                ['f'] = json.encode(outfits),
                ['g'] = "Explorateur",
                ['h'] = json.encode(identity),
                ['ct'] = json.encode(baseCityInfos),
                ['i'] = NarcosConfig_Server.startingCash,
                ['j'] = json.encode(currentpos),
                ['vip'] = 0,
                ['loadout'] = json.encode({}),
                ['pp'] = json.encode({})
            }, function(insertId)
                player.body = body
                player.outfits = outfits
                player.selectedOutfit = "Explorateur"
                player.identity = identity
                player.cash = NarcosConfig_Server.startingCash
                player.position = currentpos
                player.cityInfos = baseCityInfos
                player.loadout = {}
                player.params = {}
                player.vip = 0
                NarcosServer_PlayersManager.list[source] = player
                player:sendData()
                cb()
            end)
        end
    end)
end

Narcos.netRegisterAndHandle("playerJoined", function()
    local _src = source
    Narcos.toInternal("sendCaches", _src)
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    if player:getIsNewPlayer() then
        NarcosServer_InstancesManager.setInstance(_src, (NarcosConfig_Server.instancesRanges.creator + _src))
        NarcosServer.trace(("Le joueur ^3%s^7 est nouveau ! Bienvenue"):format(player.name), Narcos.prefixes.connection)
        NarcosServer.toClient("creatorInitialize", _src)
    else
        MySQL.Async.execute("UPDATE players SET lastInGameId = @a WHERE license = @b", { ['a'] = tonumber(_src), ['b'] = player:getLicense() })
        player:sendData(function()
            NarcosServer.toClient("playerSpawnBase", _src, player.position, player.body, player.outfits[player.selectedOutfit])
        end)
    end
end)

Narcos.netHandle("sideLoaded", function()
    MySQL.Async.execute("UPDATE players SET lastInGameId = 0", {})
end)

RegisterNetEvent("playerJoining")
AddEventHandler("playerJoining", function(src)
    local _src = source
    local identifiers = NarcosServer.getIdentifiers(_src)
    NarcosServer_PlayersManager.add(tonumber(_src), identifiers)
end)

--- @HANDLERS playerConnecting
AddEventHandler("playerConnecting", function(name, _, deferrals)
    local _src = source
    local identifiers = NarcosServer.getIdentifiers(source)
    deferrals.update("Vérification de vos identifiants...")
    Wait(500)
    if not identifiers['license'] then
        deferrals.done("Impossible de trouver votre licence RockStar, veuillez réessayer !")
    end
    deferrals.done()
end)

--- @HANDLERS playerDropped
AddEventHandler('playerDropped', function(reason)
    local _src = source
    NarcosServer_PlayersManager.remove(_src)
end)