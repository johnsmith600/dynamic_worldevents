fx_version 'cerulean'
game 'gta5'

description 'Dynamic World Events for FiveM (Qbox)'
version '1.0.0'
author 'Jules'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
    'shared/*.lua',
    'utils/shared.lua',
    'locales/*.lua'
}

client_scripts {
    'client/sync.lua',
    'client/ai.lua',
    'client/ui_wrapper.lua',
    'client/menu.lua',
    'client/main.lua',
    'client/economy.lua',
    'ui/main.lua',
    'utils/coords.lua'
}

server_scripts {
    'server/scheduler.lua',
    'server/persistence.lua',
    'server/world_state.lua',
    'server/entities.lua',
    'server/polyzone.lua',
    'server/dispatch.lua',
    'server/commands.lua',
    'server/admin.lua',
    'server/main.lua'
}

-- Modular Events
server_scripts {
    'events/emergency/*.lua',
    'events/criminal/*.lua',
    'events/civilian/*.lua',
    'events/traffic/*.lua',
    'events/weather/*.lua',
    'events/economy/*.lua'
}

-- Exports
exports {
    'StartEvent',
    'StopEvent',
    'GetEvents',
    'GetEvent',
    'IsEventRunning',
    'RegisterEvent',
    'CompleteEvent',
    'FailEvent'
}

dependencies {
    'qbx_core',
    'ox_lib',
    'oxmysql'
}
