-- Gas Leak Event
RegisterEvent({
    name = "Gas Leak",
    weight = 15,
    minimumPlayers = 1,
    radius = 30.0,
    duration = 1200,
    start = function(event)
        print("Gas leak started at " .. event.location)
        -- In a real scenario, this would trigger client side effects
        TriggerClientEvent('DynamicWorld:Client:StartGasLeak', -1, event)

        -- Automatic alert to Fire/EMS
        local message = "Reported gas leak detected in the area."
        TriggerEvent('DynamicWorld:Server:Dispatch', event.location, "Gas Leak", "fire", message)
    end,
    resume = function(event)
        TriggerClientEvent('DynamicWorld:Client:StartGasLeak', -1, event)
    end
})

-- Vehicle Crash
RegisterEvent({
    name = "Vehicle Crash",
    weight = 25,
    minimumPlayers = 2,
    radius = 20.0,
    duration = 900,
    start = function(event)
        local coords = event.location
        local veh = CreateVehicle(`blista`, coords.x, coords.y, coords.z, 0.0, true, true)
        while not DoesEntityExist(veh) do Wait(0) end

        EntityManager.Track(event.id, veh, 'vehicle')
        Persistence.SaveEntity(event.id, 'vehicle', 'blista', coords, 0.0, {health = 200})

        TriggerEvent('DynamicWorld:Server:Dispatch', event.location, "Vehicle Accident", "police", "Serious vehicle accident reported.")
    end,
    resume = function(event)
        for _, ent in ipairs(event.entities) do
            if ent.type == 'vehicle' then
                local handle = CreateVehicle(GetHashKey(ent.model), ent.coords.x, ent.coords.y, ent.coords.z, ent.heading, true, true)
                EntityManager.Track(event.id, handle, 'vehicle')
            end
        end
    end
})
