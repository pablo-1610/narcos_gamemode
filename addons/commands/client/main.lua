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

RegisterCommand("freeze", function()
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterCommand("tp", function(source, args)
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end)

RegisterCommand("car", function(source, args)
    if not args[1] then
        ESX.ShowNotification("Précisez une voiture")
        return
    end
    local model = GetHashKey(args[1])
    if not IsModelValid(model) then
        ESX.ShowNotification("~r~Voiture inexistante")
    end
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    local car = CreateVehicle(model, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
end)

RegisterCommand("revive", function()
    NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 0.0, -1, 0)
    ClearPedBloodDamage(PlayerPedId())

end)