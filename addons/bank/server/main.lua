---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 07:12]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local bankers = {
    {npcLoc = {coords = vector3(-109.94, 6469.19, 31.62), heading = 136.58}, zoneLoc = vector3(-111.43, 6467.60, 31.62)},
    {npcLoc = {coords = vector3(-111.94, 6471.39, 31.62), heading = 131.85}, zoneLoc = vector3(-113.55, 6469.75, 31.62)}
}
local npcs, zones = {}
local blip = NarcosServer_BlipsManager.createPublic(vector3(-114.50, 6468.57, 31.62), 207, 43, NarcosConfig_Server.blipsScale, "Banque centrale", true)

local function generateCardNum()
    local sb = ""
    for i = 1,4 do
        local nums = {math.random(1,9),math.random(1,9),math.random(1,9),math.random(1,9)}
        if i == 4 then
            sb = sb..("%s%s%s%s"):format(nums[1],nums[2],nums[3],nums[4])
        else
            sb = sb..("%s%s%s%s "):format(nums[1],nums[2],nums[3],nums[4])
        end
    end
    return sb
end

local function openBankMenu(_src, player, bId)
    NarcosServer.toClient("bankOpenMenu", _src, player:getCache("cards"), generateCardNum(), NarcosConfig_Server.cardCreationCost, bId)
end

for k, v in pairs(bankers) do
    local npc = NarcosServer_NpcsManager.createPublic("a_m_y_business_02", false, true, v.npcLoc, nil, nil)
    npc:setInvincible(true)
    npc:setDisplayInfos({name = "Banquier", range = 5.5, color = 0})
    bankers[k].zone = NarcosServer_ZonesManager.createPublic(v.zoneLoc, 20, { r = 255, g = 255, b = 255, a = 130 }, function(_src, player)
        bankers[k].npc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
        openBankMenu(_src, player, k)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour parler au banquier", 20.0, 1.0)
    bankers[k].npc = npc
end

Narcos.netRegisterAndHandle("bankGetFromCard", function(id, ammount, bankId)
    local _src = source
    if not NarcosServer_PlayersManager.exists(_src) then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("bankCreateCard (%s)"):format(_src), _src)
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    local cache = player:getCache("cards")
    local card = cache[id]
    if not card then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.MAJOR_VAR_NO_EXISTS, ("bankAlimCard (%s)"):format(_src), _src)
    end
    if card.balance < ammount then
        player:showAdvancedNotification("Banque centrale","~r~Erreur","Vous ne pouvez pas retirer une somme supérieure à ce que vous possédez sur la carte !","CHAR_BANK_FLEECA",1,false)
        bankers[bankId].npc:playSpeechForPlayer("GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    cache[id].balance = (cache[id].balance - ammount)
    cache[id].history = NarcosServer_CardsManager.addHistory(cache[id].history, {desc = "Retrait physique", positive = false, ammount = ammount, date = ("le %s à %s:%s par %s"):format(os.date("%m/%d/%Y",os.time()), os.date("%H", os.time()), os.date("%M", os.time()), player:getFullName())})
    --table.insert(cache[id].history, {desc = "Retrait physique", positive = false, ammount = ammount, date = ("le %s à %s:%s par %s"):format(os.date("%m/%d/%Y",os.time()), os.date("%H", os.time()), os.date("%M", os.time()), player:getFullName())})
    player:addCash(ammount)
    player:setCache("cards", cache)
    player:showAdvancedNotification("Banque centrale","~g~Succès",("Les ~g~%s$ ~s~ont correctement été retirés de votre carte bleue, merci pour votre confiance"):format(NarcosServer.groupDigits(ammount)),"CHAR_BANK_FLEECA",1,false)
    bankers[bankId].npc:playSpeechForPlayer("GENERIC_THANKS", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
    NarcosServer.toClient("serverReturnedCb", _src)
end)

Narcos.netRegisterAndHandle("bankAlimCard", function(id, ammount, bankId)
    local _src = source
    if not NarcosServer_PlayersManager.exists(_src) then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("bankCreateCard (%s)"):format(_src), _src)
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    local cache = player:getCache("cards")
    local card = cache[id]
    if not card then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.MAJOR_VAR_NO_EXISTS, ("bankAlimCard (%s)"):format(_src), _src)
    end
    player:pay(ammount, function(success, missing)
        if not success then
            bankers[bankId].npc:playSpeechForPlayer("GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
            player:showAdvancedNotification("Banque centrale","~r~Erreur","Vous ne pouvez pas déposer une somme supérieure à ce que vous possédez en cash !","CHAR_BANK_FLEECA",1,false)
            NarcosServer.toClient("serverReturnedCb", _src)
            return
        else
            cache[id].balance = (cache[id].balance + ammount)
            cache[id].history = NarcosServer_CardsManager.addHistory(cache[id].history, {desc = "Dépôt physique", positive = true, ammount = ammount, date = ("le %s à %s:%s par %s"):format(os.date("%m/%d/%Y",os.time()), os.date("%H", os.time()), os.date("%M", os.time()), player:getFullName())})
            --table.insert(cache[id].history, {desc = "Dépôt physique", positive = true, ammount = ammount, date = ("le %s à %s:%s par %s"):format(os.date("%m/%d/%Y",os.time()), os.date("%H", os.time()), os.date("%M", os.time()), player:getFullName())})
            player:setCache("cards", cache)
            player:showAdvancedNotification("Banque centrale","~g~Succès",("Les ~g~%s$ ~s~ont correctement été déposés sur votre carte bleue, merci pour votre confiance"):format(NarcosServer.groupDigits(ammount)),"CHAR_BANK_FLEECA",1,false)
            bankers[bankId].npc:playSpeechForPlayer("GENERIC_THANKS", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
            NarcosServer.toClient("serverReturnedCb", _src)
        end
    end)
end)

Narcos.netRegisterAndHandle("bankCreateCard", function(pin, num, name, bankId)
    local _src = source
    if not NarcosServer_PlayersManager.exists(_src) then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("bankCreateCard (%s)"):format(_src), _src)
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    local maxCards = NarcosConfig_Server.cardsByVip(player.vip)
    if (NarcosServer.getTableLenght(player:getCache("cards"))) >= maxCards then
        player:showAdvancedNotification("Banque centrale","~r~Erreur",("Vous avez trop de cartes bleues (~y~%s max~s~). Passez à un rang supérieur pour en débloquer davantage !"):format(maxCards),"CHAR_BANK_FLEECA",1,false)
        NarcosServer.toClient("serverReturnedCb", _src)
        return
    end
    player:pay(NarcosConfig_Server.cardCreationCost, function(success, missing)
        if not success then
            player:showAdvancedNotification("Banque centrale","~r~Erreur",("Vous n'avez pas assez d'argent pour créer une carte (~g~%s$ ~s~manquants)"):format(NarcosServer.groupDigits(missing)),"CHAR_BANK_FLEECA",1,false)
            bankers[bankId].npc:playSpeechForPlayer("GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
            NarcosServer.toClient("serverReturnedCb", _src)
        else
            NarcosServer_MySQL.insert("INSERT INTO cards (owner, number, pin, balance, history) VALUES(@a, @b, @c, @d, @e)", {
                ['a'] = player:getLicense(),
                ['b'] = num,
                ['c'] = pin,
                ['d'] = 0,
                ['e'] = json.encode({})
            }, function(insrtId)
                local oldCache = player:getCache("cards")
                oldCache[insrtId] = {id = insrtId, owner = player:getLicense(), number = num, pin = pin, balance = 0, history = {}}
                player:setCache("cards", oldCache)
                player:showAdvancedNotification("Banque centrale","~g~Succès",("Création de la carte ~y~%s ~s~effectuée, n'hésitez pas à venir régulièrement pour consulter son activité"):format(num),"CHAR_BANK_FLEECA",1,false)
                bankers[bankId].npc:playSpeechForPlayer("GENERIC_THANKS", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", _src)
                NarcosServer.toClient("serverReturnedCb", _src)
            end)
        end
    end)
end)