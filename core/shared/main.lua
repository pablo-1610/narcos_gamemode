---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.

  File [main] created at [21/05/2021 16:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos = {}
Narcos.newThread = Citizen.CreateThread
Narcos.newWaitingThread = Citizen.SetTimeout
Citizen.CreateThread, CreateThread, Citizen.SetTimeout, SetTimeout, InvokeNative = nil, nil, nil, nil, nil

Narcos.prefixes = {
    zones = "^1ZONE",
    err = "^1ERREUR",
    blips = "^1BLIPS",
    npcs = "^1NPCS",
    dev = "^4INFOS",
    sync = "^6SYNC",
    jobs = "^6JOBS",
    succes = "^2SUCCÈS"
}