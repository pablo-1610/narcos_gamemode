---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 16:54]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterCommand("coords", function()
    local pos = GetEntityCoords(PlayerPedId())
    print(("%s, %s, %s et %s°"):format(pos.x, pos.y, pos.z, GetEntityHeading(PlayerPedId())))
end)

RegisterCommand("tp", function(source, args)
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end)

RegisterCommand("revive", function()
    NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 0.0, -1, 0)
    ClearPedBloodDamage(PlayerPedId())

end)