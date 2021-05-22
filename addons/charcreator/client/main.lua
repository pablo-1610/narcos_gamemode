---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/05/2021 17:30]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local initialPosition = {vec = vector3(686.26, 577.86, 130.46), heading = 162.34}
local camPos = vector3(684.11, 571.66, 130.46)

Narcos.netRegisterAndHandle("creatorStarts", function()
    Wait(1500)
    NarcosClient.trace("Démarrage du créateur de personnage")
    DoScreenFadeOut(3000)
    while not IsScreenFadedOut() do Wait(1) end
    SetEntityCoords(PlayerPedId(), initialPosition.vec, false, false, false, false)
    SetEntityHeading(PlayerPedId(), initialPosition.heading)

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    SetCamCoord(cam, camPos)
    PointCamAtCoord(cam,initialPosition.vec.x, initialPosition.vec.y, initialPosition.vec.z+0.65)
    SetCamActive(cam, true)
    ClearFocus()
    RenderScriptCams(1,0,0,0,0)
    SetFocusPosAndVel(initialPosition.vec, 0,0,0)
    SetCamFov(cam, 12.0)
    DoScreenFadeIn(3500)
    Wait(1500)
    Narcos.toInternal("creatorMenu")
end)