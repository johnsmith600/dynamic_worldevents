Config = {}

Config.Locale = 'en'

Config.Events = {
    Interval = {15, 45}, -- Minutes between events
    MaxConcurrent = 2,
    MinimumPlayers = 5,
    Cooldown = 600, -- Seconds
    SavePersistence = true,
}

Config.Debug = true

Config.Dispatch = {
    Default = 'bridge', -- 'cd_dispatch', 'ps-dispatch', 'core_dispatch', 'lb-phone', 'bridge'
}

Config.Economy = {
    FuelShortage = {
        NPCProbability = 0.3,
        PriceMultiplier = 2.0,
    }
}

Config.Zones = {
    {
        name = "Prison",
        type = "blacklist",
        points = {
            vector2(1600.0, 2500.0),
            vector2(1800.0, 2500.0),
            vector2(1800.0, 2700.0),
            vector2(1600.0, 2700.0),
        },
        options = { minZ = 0, maxZ = 100 }
    }
}
