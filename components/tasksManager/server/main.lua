---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [22/05/2021 02:00]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_TasksManager = {}
NarcosServer_TasksManager.list = {}

local lastTime = nil

NarcosServer_TasksManager.schedule = function(h, m, cb)
    table.insert(NarcosServer_TasksManager.list, {
        h  = h,
        m  = m,
        cb = cb
    })
end

local function GetTime()
    local timestamp = os.time()
    local d = os.date('*t', timestamp).wday
    local h = tonumber(os.date('%H', timestamp))
    local m = tonumber(os.date('%M', timestamp))
    return {d = d, h = h, m = m}
end

function OnTime(d, h, m)
    for i=1, #NarcosServer_TasksManager.list, 1 do
        if NarcosServer_TasksManager.list[i].h == h and NarcosServer_TasksManager.list[i].m == m then
            NarcosServer_TasksManager.list[i].cb(d, h, m)
        end
    end
end

local function Tick()
    local time = GetTime()
    if time.h ~= lastTime.h or time.m ~= lastTime.m then
        OnTime(time.d, time.h, time.m)
        lastTime = time
    end
    Narcos.newWaitingThread(60000, Tick)
end

lastTime = GetTime()
Tick()