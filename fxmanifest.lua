version '1.0.0'
author 'Pablo ZAPATA (pablo_1610)'
description 'Gamemode working with es_extended for Los Narcos'
repository 'https://github.com/PABLO-1610/narcos_gamemode'

resource_type 'gametype' { name = 'narcos_gamemode' }

ui_page 'core/web/index.html'

loadscreen 'loadscreen/index.html'

files {
    'core/web/index.html',
    'core/web/*.js',
    'core/web/sounds/*.ogg',

    'core/web/css/index.css',
    'core/web/js/config.default.js',
    'core/web/js/config.js',
    'core/web/js/App.js',
    'core/web/js/Message.js',
    'core/web/js/Suggestions.js',
    'core/web/vendor/vue.2.3.3.min.js',
    'core/web/vendor/flexboxgrid.6.3.1.min.css',
    'core/web/vendor/animate.3.5.2.min.css',
    'core/web/vendor/latofonts.css',
    'core/web/vendor/fonts/LatoRegular.woff2',
    'core/web/vendor/fonts/LatoRegular2.woff2',
    'core/web/vendor/fonts/LatoLight2.woff2',
    'core/web/vendor/fonts/LatoLight.woff2',
    'core/web/vendor/fonts/LatoBold.woff2',
    'core/web/vendor/fonts/LatoBold2.woff2',
    'core/web/css/style.css',

    'loadscreen/index.html',
    'loadscreen/style.css',
    'loadscreen/default.mp4',
    'loadscreen/music.mp3',
    'loadscreen/logo.png'
}

shared_scripts {
    "core/shared/main.lua",
    "core/shared/utils/*.lua",
    "components/**/shared/*.lua",
    "addons/**/shared/*.lua"
}

client_scripts {
    "core/config/client.lua",
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

    --[[
    "vendors/PabloUI/client/PabloUI.lua",
    "vendors/PabloUI/client/objects/Panel.lua",
    --]]

    "components/**/client/*.lua",
    "components/**/client/objects/*.lua",

    "addons/**/client/*.lua",
    "addons/**/client/objects/*.lua",

    "jobs/**/client/*.lua",
    "jobs/**/client/objects/*.lua"
}

server_scripts {
    "core/config/server.lua",
    "core/server/main.lua",
    "core/server/utils.lua",
    "core/sql_connector/server/mysql-async.js",

    "components/**/server/*.lua",
    "components/**/server/objects/*.lua",

    "addons/**/server/*.lua",
    "addons/**/server/objects/*.lua",

    "jobs/**/server/*.lua",
    "jobs/**/server/objects/*.lua"
}

chat_theme 'gtao' {
    styleSheet = 'style.css',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}

game 'common'
fx_version 'adamant'
