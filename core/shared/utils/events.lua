---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.

  File [main] created at [21/05/2021 16:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---toInternal
---@public
---@return void
Narcos.toInternal = function(eventName, ...)
    TriggerEvent("narcos:" .. Narcos.hash(eventName), ...)
end

---toInternalBasic
---@public
---@return void
Narcos.toInternalBasic = function(eventName, ...)
    TriggerEvent(eventName, ...)
end

local registredEvents = {}
local function isEventRegistred(eventName)
    for k, v in pairs(registredEvents) do
        if v == eventName then
            return true
        end
    end
    return false
end

---netRegisterAndHandle
---@public
---@return void
Narcos.netRegisterAndHandle = function(eventName, handler)
    local event = "narcos:" .. Narcos.hash(eventName)
    if not isEventRegistred(event) then
        RegisterNetEvent(event)
        table.insert(registredEvents, event)
    end
    AddEventHandler(event, handler)
end

---netRegister
---@public
---@return void
Narcos.netRegister = function(eventName)
    local event = "narcos:" .. Narcos.hash(eventName)
    RegisterNetEvent(event)
end

---netHandle
---@public
---@return void
Narcos.netHandle = function(eventName, handler)
    local event = "narcos:" .. Narcos.hash(eventName)
    AddEventHandler(event, handler)
end

---netHandleBasic
---@public
---@return void
Narcos.netHandleBasic = function(eventName, handler)
    AddEventHandler(eventName, handler)
end

---hash
---@public
---@return any
Narcos.hash = function(notHashedModel)
    return GetHashKey(notHashedModel)
end

---second
---@public
---@return number
Narcos.second = function(from)
    return from * 1000
end