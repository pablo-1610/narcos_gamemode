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
    populationEnabled = false,

    defaultRank = "default",
    defaultJob = "unemployed",

    paycheckInterval = 30, -- In minutes

    bannedInstance = 1,

    blipsScale = 0.90,

    startingCash = 500,
    startingPosition = vector3(-724.64, -1444.10, 5.0),
    startingHeading = 325.13,

    unemployedJobName = "Explorateur",

    baseInventory = { ["bread"] = 10, ["water"] = 10 },
    baseCityInfos = { ["job"] = { id = "unemployed", rank = 1 }, ["org"] = { id = "unemployed", rank = 1 } },
    baseBuilderMoney = 5000,

    errorWebhook = "https://discord.com/api/webhooks/856303231235260416/QCbp0wufoZb50RgL5aE9Hpu0R_h-u5VgyY2Jnj2Y049KUW9ErNl-jadAFvX4BWx-sVNI",
    staffWebhook = "https://discord.com/api/webhooks/857439977629810709/YVGozHr9x9qRT_8NZDF-sZ_hHGvf65-lANsIoA_fjwJT6gQ6ndyy8PSNE2s9Ma0tR9lx0",

    locationPosition = vector3(-700.07, -1425.54, 5.00),
    locationNpc = { type = "a_m_m_mexlabor_01", pos = vector3(-699.24, -1425.34, 5.00), heading = 108.13 },
    locationOut = { pos = vector3(-681.46, -1428.14, 5.00), heading = 85.74 },

    locationsOut = {

    },

    cardCreationCost = 150,
    cardsByVip = function(vipLevel)
        local levels = { [1] = 2, [2] = 3 }
        return (levels[vipLevel] or 1)
    end,

    locationVehicles = {
        { model = "bmx", title = "Le vélo de course", desc = "Je l'ai monté moi même ! Reconditionné à neuf.", price = 15, vip = false },
        { model = "manchez2", title = "La moto douteuse", desc = "Cette moto peut faire l'affaire, bien qu'elle semble avoir déjà beaucoup servie...", price = 80, vip = false },
        { model = "veto", title = "Le kart", desc = "Très utile pour une balade dans les champs de canabis !", price = 150, vip = true }
    },

    reminderInterval = ((1000 * 60) * 15),
    reminder = {
        "Vous pouvez à tout moment cacher/afficher l'HUD avec la touche ~b~W ~s~!",
        "N'hésitez pas à rejoindre notre Discord, disponible dans le menu personnel",
        "Vous êtes victime de joueurs toxics ? Utilisez la commande ~b~/report~s~ !"
    },

    baseBuilderRank = {
        [1] = { label = "Patron" },
        [2] = { label = "Associé" },
        [3] = { label = "Débutant" }
    },

    -- Ne pas toucher
    instancesRanges = {
        creator = 100,
        driving = 2500,
    },

    availableWeapons = {
        "WEAPON_KNIFE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB",
        "WEAPON_CROWBAR", "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50",
        "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_ASSAULTSMG", "WEAPON_ASSAULTRIFLE",
        "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_PUMPSHOTGUN",
        "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_STUNGUN", "WEAPON_SNIPERRIFLE",
        "WEAPON_HEAVYSNIPER", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_RPG", "WEAPON_MINIGUN",
        "WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_SMOKEGRENADE", "WEAPON_BZGAS", "WEAPON_MOLOTOV",
        "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_FLARE", "WEAPON_SNSPISTOL", "WEAPON_SPECIALCARBINE",
        "WEAPON_HEAVYPISTOL", "WEAPON_BULLPUPRIFLE", "WEAPON_HOMINGLAUNCHER", "WEAPON_PROXMINE", "WEAPON_SNOWBALL",
        "WEAPON_VINTAGEPISTOL", "WEAPON_DAGGER", "WEAPON_FIREWORK", "WEAPON_MUSKET", "WEAPON_MARKSMANRIFLE",
        "WEAPON_HEAVYSHOTGUN", "WEAPON_GUSENBERG", "WEAPON_HATCHET", "WEAPON_RAILGUN", "WEAPON_COMBATPDW",
        "WEAPON_KNUCKLE", "WEAPON_MARKSMANPISTOL", "WEAPON_FLASHLIGHT", "WEAPON_MACHETE", "WEAPON_MACHINEPISTOL",
        "WEAPON_SWITCHBLADE", "WEAPON_REVOLVER", "WEAPON_COMPACTRIFLE", "WEAPON_DBSHOTGUN", "WEAPON_FLAREGUN",
        "WEAPON_AUTOSHOTGUN", "WEAPON_BATTLEAXE", "WEAPON_COMPACTLAUNCHER", "WEAPON_MINISMG", "WEAPON_PIPEBOMB",
        "WEAPON_POOLCUE", "WEAPON_SWEEPER", "WEAPON_WRENCH", "WEAPON_DOUBLEACTION", "WEAPON_MILITARYRIFLE", "WEAPON_COMBATSHOTGUN",
        "GADGET_PARACHUTE"
    },

    baseBuilderPositions = {
        ["GARAGE"] = {
            location = vector3(150, 0, 0),
            label = "Garage de l'entreprise",
            desc = "le garage",
            perm = "GARAGE",
            blip = { active = true, sprite = 50, color = 36 }
        },

        ["MANAGER"] = {
            location = vector3(150, 0, 0),
            label = "Gestion de l'entreprise",
            desc = "l'ordinateur",
            perm = "MANAGE",
            blip = { active = true, sprite = 521, color = 36 }
        },

        ["SAFE"] = {
            location = vector3(150, 0, 0),
            label = "Stockage de l'entreprise",
            desc = "le coffre",
            perm = "SAFE",
            blip = { active = true, sprite = 478, color = 36 }
        },

        ["CLOAKROOM"] = {
            location = vector3(150, 0, 0),
            label = "Vestiaires de l'entreprise",
            desc = "le vestiaire",
            perm = "CLOAKROOM",
            blip = { active = true, sprite = 73, color = 36 }
        }
    },

    availableWeathers = {
        'EXTRASUNNY',
        'CLEAR',
        'SMOG',
        --'FOGGY',
        --'OVERCAST',
        --'CLOUDS',
        --'CLEARING',
        --'RAIN',
    },

    availableClothesShops = {
        {
            vendorNpcLoc = { coords = vector3(5.99, 6511.19, 31.87), heading = 57.51 },
            vendorNpcZone = vector3(4.45, 6512.62, 31.87),
            mainZone = vector3(12.30, 6513.55, 31.87)
        }
    }
}