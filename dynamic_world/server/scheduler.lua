Scheduler = {
    ActiveEvents = {},
    EventTypes = {},
    LastEventTime = 0,
    Cooldowns = {}
}

function Scheduler.RegisterEventType(config)
    Scheduler.EventTypes[config.name] = config
    print(("^2[Dynamic World]^7 Registered event type: %s"):format(config.name))
end

function Scheduler.Start()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(60000) -- Check every minute

            local playerCount = #GetPlayers()
            if playerCount >= Config.Events.MinimumPlayers then
                Scheduler.Process()
            end
        end
    end)
end

function Scheduler.GetActiveCount()
    local count = 0
    for _ in pairs(Scheduler.ActiveEvents) do count = count + 1 end
    return count
end

function Scheduler.Process()
    local currentTime = os.time()

    -- Clean up finished events
    for id, event in pairs(Scheduler.ActiveEvents) do
        if event.state == 'Resolved' or event.state == 'Failed' or event.state == 'Expired' then
            Scheduler.ActiveEvents[id] = nil
        end
    end

    if Scheduler.GetActiveCount() >= Config.Events.MaxConcurrent then return end

    local timeSinceLast = (currentTime - Scheduler.LastEventTime) / 60
    local interval = math.random(Config.Events.Interval[1], Config.Events.Interval[2])

    if timeSinceLast >= interval then
        Scheduler.AttemptSpawnEvent()
    end
end

function Scheduler.AttemptSpawnEvent()
    local availableEvents = {}
    local totalWeight = 0
    local currentTime = os.time()

    for name, config in pairs(Scheduler.EventTypes) do
        local onCooldown = Scheduler.Cooldowns[name] and (currentTime < Scheduler.Cooldowns[name])
        local minPlayers = config.minimumPlayers or 0

        if not onCooldown and #GetPlayers() >= minPlayers then
            -- Additional checks: weather, time
            local weatherMatch = not config.weather or config.weather == GetPrevWeatherType()
            -- Simplified time check

            if weatherMatch then
                table.insert(availableEvents, config)
                totalWeight = totalWeight + (config.weight or 10)
            end
        end
    end

    if #availableEvents == 0 then return end

    local roll = math.random(1, totalWeight)
    local currentWeight = 0
    local selectedEvent = nil

    for _, config in ipairs(availableEvents) do
        currentWeight = currentWeight + (config.weight or 10)
        if roll <= currentWeight then
            selectedEvent = config
            break
        end
    end

    if selectedEvent then
        Scheduler.CreateEvent(selectedEvent.name)
    end
end

function Scheduler.CreateEvent(typeName, customData)
    local config = Scheduler.EventTypes[typeName]
    if not config then return end

    local players = GetPlayers()
    if #players == 0 then return end

    local randomPlayer = players[math.random(#players)]
    local playerCoords = GetEntityCoords(GetPlayerPed(randomPlayer))

    local id = typeName .. "_" .. os.time() .. "_" .. math.random(100, 999)

    -- Request safe coord from client
    local location = nil
    local p = promise.new()

    TriggerClientEvent('DynamicWorld:RequestSafeCoord', randomPlayer, playerCoords, 500.0, 'DynamicWorld:Callback:SafeCoord' .. id)

    local handler = RegisterNetEvent('DynamicWorld:Callback:SafeCoord' .. id, function(coord)
        if p then p:resolve(vector3(coord.x, coord.y, coord.z)) end
    end)

    -- Timeout after 5 seconds
    Citizen.SetTimeout(5000, function()
        if p then p:resolve(nil) end
    end)

    location = Citizen.Await(p)
    p = nil
    RemoveEventHandler(handler)

    if not location or Scheduler.IsInRestrictedZone(location) then
        print("^1[Dynamic World] Failed to find safe location for event: " .. typeName)
        return
    end

    local event = {
        id = id,
        type = typeName,
        location = location,
        radius = config.radius or 50.0,
        state = 'Pending',
        timeStarted = os.time(),
        timeRemaining = config.duration or 1800,
        reward = config.reward or 0,
        difficulty = #GetPlayers() / 10, -- Scale difficulty
        customData = customData or {}
    }

    Scheduler.ActiveEvents[id] = event
    Scheduler.LastEventTime = os.time()
    Scheduler.Cooldowns[typeName] = os.time() + (config.cooldown or Config.Events.Cooldown)

    -- Trigger start logic
    if config.start then
        config.start(event)
    end

    Persistence.SaveEvent(event)
    TriggerEvent('DynamicWorld:EventStarted', event)

    return id
end

-- Polyzone integration placeholder
-- Polyzone integration
function Scheduler.IsInRestrictedZone(coords)
    return PolyZoneManager.IsPointRestricted(coords)
end
