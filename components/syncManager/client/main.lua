---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 20:39]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local timeOverride, weatherOverride = nil, nil

NarcosClient_SyncManager = {}

NarcosClient_SyncManager.overrideTime = function(h, m)
    timeOverride = {h,m}
    NetworkOverrideClockTime(tonumber(timeOverride[1]), tonumber(timeOverride[2]), 00)
end

NarcosClient_SyncManager.overrideWeather = function(weather)
    weatherOverride = weather
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weatherOverride)
    SetWeatherTypeNow(weatherOverride)
    SetWeatherTypeNowPersist(weatherOverride)
end

NarcosClient_SyncManager.stopOverrideTime = function()
    timeOverride = nil
    NarcosClient.toServer("requestOneSync")
end

NarcosClient_SyncManager.stopOverrideWeather = function()
    weatherOverride = nil
    NarcosClient.toServer("requestOneSync")
end

NarcosClient_SyncManager.stopOverrideBoth = function()
    timeOverride = nil
    weatherOverride = nil
    NarcosClient.toServer("requestOneSync")
end

Narcos.netHandle("sideLoaded", function()
    PauseClock(true)
    NarcosClient.toServer("requestOneSync")
end)

Narcos.netRegisterAndHandle("syncSetTime", function(time)
    if timeOverride ~= nil then
        NetworkOverrideClockTime(tonumber(timeOverride[1]), tonumber(timeOverride[2]), 00)
    else
        NarcosClient.trace(("Le temps est désormais défini sur ^3%s:%s"):format(tonumber(time[1]),tonumber(time[2])))
        NetworkOverrideClockTime(tonumber(time[1]), tonumber(time[2]), 00)
    end
end)

Narcos.netRegisterAndHandle("syncSetWeather", function(weather)
    if weatherOverride == nil then
        NarcosClient.trace(("La météo est désormais définie sur ^3%s"):format(weather))
        SetWeatherTypeOverTime(weather, 30.0)
        Wait(Narcos.second(30))
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(weather)
        SetWeatherTypeNow(weather)
        SetWeatherTypeNowPersist(weather)
    end
end)