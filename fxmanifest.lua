fx_version 'cerulean'
game 'gta5'

version '1.2.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua',
    '@qbx_core/modules/playerdata.lua'
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua'
}

files {
    'data/*.lua',
    'modules/objectplacer.lua'
}

dependencies {
    'ox_lib',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
