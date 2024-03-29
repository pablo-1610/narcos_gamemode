---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.

  File [main] created at [21/05/2021 16:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@public
---@type number
local tasks = 0

---@public
---@type table
local activeTasks = {}

---repeatingTask
---@public
---@return number
Narcos.newRepeatingTask = function(onRun, onFinished, delay, interval)
    tasks = tasks + 1
    local taskID = tasks
    activeTasks[taskID] = true
    Narcos.newThread(function()
        Wait(delay)
        while activeTasks[taskID] do
            onRun()
            Wait(interval)
        end
        if onFinished ~= nil then onFinished() end
    end)
    return taskID
end

---cancelTaskNow
---@public
---@return void
---@param taskID number
Narcos.cancelTaskNow = function(taskID)
    if not activeTasks[taskID] then return end
    activeTasks[taskID] = nil
end