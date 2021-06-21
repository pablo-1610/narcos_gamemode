---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [server] created at [13/06/2021 18:22]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosConfig_Server = {
    defaultRank = "default",

    bannedInstance = 666,

    blipsScale = 0.85,

    startingCash = 5,
    startingPosition = vector3(2614.53,2920.02,40.42),
    startingHeading = 65.90,

    baseCityInfos = {["job"] = {id = -1, rank = -1}, ["org"] = {id = -1, rank = -1}},
    baseInventory = {["bread"] = 10, ["water"] = 10},
    baseBuilderMoney = 5000,

    errorWebhook = "https://discord.com/api/webhooks/856303231235260416/QCbp0wufoZb50RgL5aE9Hpu0R_h-u5VgyY2Jnj2Y049KUW9ErNl-jadAFvX4BWx-sVNI",

    locationPosition = vector3(2606.74, 2909.40, 40.42),
    locationNpc = {type = "a_m_m_mexlabor_01", pos = vector3(2606.03, 2908.10, 40.42), heading = 330.02},

    reminderInterval = ((1000*60)*15),
    reminder = {
        "Vous pouvez à tout moment cacher/afficher l'HUD avec la touche ~b~W ~s~!",
        "N'hésitez pas à rejoindre notre Discord, disponible dans le menu F5",
        "Vous êtes victime de joueurs toxics ? Utilisez le menu F5 pour appeller un staff."
    },

    baseBuilderRank = {
        [1] = {label = "Patron"},
        [2] = {label = "Associé"},
        [3] = {label = "Débutant"}
    },

    baseBuilderPositions = {
        ["GARAGE"] = {
            location = vector3(0,0,0),
            desc = "le garage",
            blip = {active = false, sprite = 50, color = 67}
        },

        ["MANAGER"] = {
            location = vector3(0,0,0),
            desc = "l'ordinateur",
            blip = {active = false, sprite = 521, color = 67}
        },

        ["SAFE"] = {
            location = vector3(0,0,0),
            desc = "le coffre",
            blip = {active = false, sprite = 478, color = 67}
        }
    },

    availableWeathers = {
        'EXTRASUNNY',
        'CLEAR',
        'NEUTRAL',
        'SMOG',
        'FOGGY',
        'OVERCAST',
        'CLOUDS',
        'CLEARING',
        'RAIN',
        'THUNDER',
    }
}