---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [24/06/2021 03:25]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Narcos.netRegisterAndHandle("receiveLoadouts", function(loadouts)
    for k,v in pairs(loadouts) do
        GiveWeaponToPed(PlayerPedId(), GetHashKey(k), tonumber(v.ammo), false, false)
        if v.comp ~= nil then
            for _,comp in pairs(v.comp) do
                GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(k), GetHashKey(comp))
            end
        end
    end
end)

Narcos.netRegisterAndHandle("receiveLoadout", function(loadout)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(loadout.model), loadout.ammo, false, false)
end)

Narcos.netRegisterAndHandle("removeWeapon", function(weaponName)
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weaponName))
end)

Narcos.netRegisterAndHandle("clearLoadout", function()
    RemoveAllPedWeapons(PlayerPedId())
end)