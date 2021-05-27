version '1.0.0'
author 'Pablo ZAPATA (pablo_1610)'
description 'Gamemode working with es_extended for Los Narcos'
repository 'https://github.com/PABLO-1610/narcos_gamemode'

resource_type 'gametype' { name = 'narcos_gamemode' }

files {
    'core/web/index.html',
    'core/web/*.js',
    'core/web/sounds/*.ogg'
}

shared_scripts {
    "core/shared/main.lua",
    "core/shared/utils/*.lua",
    "components/**/shared/*.lua",
    "addons/**/shared/*.lua"
}

client_scripts {
    "core/client/main.lua",
    "core/client/utils.lua",

    "vendors/RageUI/RMenu.lua",
    "vendors/RageUI/menu/RageUI.lua",
    "vendors/RageUI/menu/Menu.lua",
    "vendors/RageUI/menu/MenuController.lua",
    "vendors/RageUI/components/*.lua",
    "vendors/RageUI/menu/elements/*.lua",
    "vendors/RageUI/menu/items/*.lua",
    "vendors/RageUI/menu/panels/*.lua",
    "vendors/RageUI/menu/windows/*.lua",

    "vendors/PabloUI/client/PabloUI.lua",
    "vendors/PabloUI/client/objects/Panel.lua",

    "components/**/client/*.lua",
    "components/**/client/objects/*.lua",

    "addons/**/client/*.lua",
    "addons/**/client/objects/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "core/server/main.lua",
    "core/server/utils.lua",

    "components/**/server/*.lua",
    "components/**/server/objects/*.lua",

    "addons/**/server/*.lua",
    "addons/**/server/objects/*.lua",
}

game 'common'
fx_version 'adamant'
