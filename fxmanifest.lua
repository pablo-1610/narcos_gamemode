version '1.0.0'
author 'Pablo ZAPATA (pablo_1610)'
description 'Gamemode working with es_extended for Los Narcos'
repository 'https://github.com/PABLO-1610/narcos_gamemode'

resource_type 'gametype' { name = 'Narcos RolePlay' }

shared_scripts {
    "core/shared/main.lua",
    "core/shared/utils/*.lua",
    "components/**/shared/*.lua",
    "addons/**/shared/*.lua"
}

client_scripts {
    "core/client/main.lua",
    "core/client/utils.lua",

    "components/**/client/*.lua",
    "components/**/client/objects/*.lua",

    "addons/**/client/*.lua",
    "addons/**/client/objects/*.lua",

    "services/RageUI/client/RMenu.lua",
    "services/RageUI/client/menu/RageUI.lua",
    "services/RageUI/client/menu/Menu.lua",
    "services/RageUI/client/menu/MenuController.lua",
    "services/RageUI/client/components/*.lua",
    "services/RageUI/client/menu/elements/*.lua",
    "services/RageUI/client/menu/items/*.lua",
    "services/RageUI/client/menu/panels/*.lua",
    "services/RageUI/client/menu/windows/*.lua",
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
