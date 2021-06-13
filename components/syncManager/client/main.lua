---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [13/06/2021 20:39]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netHandle("sideLoaded", function()
    NarcosClient.toServer("requestOneSync")
end)

Narcos.netRegisterAndHandle("syncSetTime", function(time)
    NarcosClient.trace(("Le temps est désormais ^3%s:%s"):format(tonumber(time[1]),tonumber(time[2])))
    NetworkOverrideClockTime(tonumber(time[1]), tonumber(time[2]), 00)
end)

Narcos.netRegisterAndHandle("syncSetWeather", function(weather)
    NarcosClient.trace(("La météo est désormais ^3%s"):format(weather))
    SetWeatherTypeOverTime(weather, 30.0)
    Wait(Narcos.second(30))
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
end)