---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [enums] created at [20/06/2021 23:44]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosEnums = {
    Errors = {
        INV_CAPACITY_EXCEEDED = 1,
        INV_NO_ITEM = 2,
        TARGET_INVALID = 3,
        PLAYER_NO_EXISTS = 4,
        INVALID_PARAM = 5,
        MAJOR_VAR_NO_EXISTS = 6
    },

    GameStates = {
        LOADING = 0,
        PLAYING = 1
    },

    JobsType = {
        OPEN = 1,
        VIP = 2,
        WHITELISTED = 3
    },

    VipDivisions = {
        GOLD = 1,
        DIAMOND = 2
    },

    PermissionsCat = {
        "Gestion",
        "Utilisation"
    },

    Prefixes = {
        ERR = "~r~Erreur"
    },

    Permissions = {
        ["BOSS"] = {cat = 1, desc = "Permissions de boss"},
        ["RECRUIT"] = {cat = 1, desc = "Recruter des joueurs"},
        ["FIRE"] = {cat = 1, desc = "Virer des joueurs"},
        ["PROMOTE"] = {cat = 1, desc = "Promouvoir un joueur"},
        ["DEMOTE"] = {cat = 1, desc = "Déstituer un joueur"},
        ["GARAGE"] = {cat = 2, desc = "Accéder au garage"},
        ["SAFE"] = {cat = 2, desc = "Accéder au coffre"},
        ["HOME"] = {cat = 2, desc = "Accéder aux locaux (si il y a)"},
    }
}