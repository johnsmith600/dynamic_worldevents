fx_version 'cerulean'
game 'gta5'

description 'Dynamic World Events for FiveM'
version '1.0.0'
author 'Jules'

lua54 'yes'

-- Ultimate Bridge Integration
shared_script '@ultimate_bridge/lib/bridge.lua'

shared_scripts {
    'config/config.lua',
    'shared/*.lua',
    'utils/shared.lua',
    'locales/*.lua'
}

client_scripts {
    'client/sync.lua',
    'client/ai.lua',
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
    'server/main.lua'
}

-- Modular Events
-- Server side logic
server_scripts {
    'events/emergency/*.lua',
    'events/criminal/*.lua',
    'events/civilian/*.lua',
    'events/traffic/*.lua',
    'events/weather/*.lua',
    'events/economy/*.lua'
}

-- Client side logic (if any specific ones exist, but usually they register via events)
-- For now, keep them server-side as they mainly register event definitions

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
    'ultimate_bridge',
    'PolyZone',
    'oxmysql'
}
