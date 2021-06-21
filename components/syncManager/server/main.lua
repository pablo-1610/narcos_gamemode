---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 20:39]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_SyncManager = {}
NarcosServer_SyncManager.time = {12,00}
NarcosServer_SyncManager.weather = NarcosConfig_Server.availableWeathers[math.random(1,#NarcosConfig_Server.availableWeathers)]

-- Generators
NarcosServer_SyncManager.genWeather = function()
    local weather = NarcosConfig_Server.availableWeathers[math.random(1,#NarcosConfig_Server.availableWeathers)]
    while NarcosServer_SyncManager.weather == weather do
        weather = NarcosConfig_Server.availableWeathers[math.random(1,#NarcosConfig_Server.availableWeathers)]
        Wait(1)
    end
    NarcosServer.trace(("La météo est désormais: ^3%s"):format(weather:lower()), Narcos.prefixes.dev)
    return weather
end

NarcosServer_SyncManager.genHour = function()
    local time = {os.date("%H", os.time()), os.date("%M", os.time())}
    return time
end

-- Getters
NarcosServer_SyncManager.getWeather = function()
    return NarcosServer_SyncManager.weather
end

NarcosServer_SyncManager.getTime = function()
    return NarcosServer_SyncManager.time
end

-- Weather
Narcos.newThread(function()
    while true do
        Wait(Narcos.second(60*15))
        NarcosServer_SyncManager.weather = NarcosServer_SyncManager.genWeather()
        NarcosServer.toAll("syncSetWeather", NarcosServer_SyncManager.getWeather())
    end
end)

-- Time
Narcos.newThread(function()
    while true do
        Wait(Narcos.second(60))
        NarcosServer_SyncManager.time = NarcosServer_SyncManager.genHour()
        NarcosServer.toAll("syncSetTime", NarcosServer_SyncManager.getTime())
    end
end)

Narcos.netHandle("sideLoaded", function()
    NarcosServer.trace(("Serveur démarré avec météo: ^3%s"):format(NarcosServer_SyncManager.getWeather():lower()), Narcos.prefixes.dev)
    NarcosServer_SyncManager.time = NarcosServer_SyncManager.genHour()
end)

Narcos.netRegisterAndHandle("requestOneSync", function()
    local _src = source
    NarcosServer.toClient("syncSetWeather", _src, NarcosServer_SyncManager.getWeather(), true)
    NarcosServer.toClient("syncSetTime", _src, NarcosServer_SyncManager.getTime())
end)