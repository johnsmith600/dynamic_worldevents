-- Store Robbery (AI)
RegisterEvent({
    name = "AI Store Robbery",
    weight = 20,
    minimumPlayers = 1,
    radius = 15.0,
    duration = 600,
    start = function(event)
        local pedModel = `mp_m_shopkeep_01`
        local coords = event.location

        -- Create the entities on the server (using CreatePed/CreateVehicle which is synced)
        local robber = CreatePed(4, `mp_m_freemode_01`, coords.x + 1.0, coords.y + 1.0, coords.z, 0.0, true, true)
        while not DoesEntityExist(robber) do Wait(0) end

        EntityManager.Track(event.id, robber, 'ped')
        Persistence.SaveEntity(event.id, 'ped', 'mp_m_freemode_01', GetEntityCoords(robber), GetEntityHeading(robber), {health = 200, behavior = 'robber'})

        TriggerClientEvent('DynamicWorld:Client:StartStoreRobbery', -1, event, NetworkGetNetworkIdFromEntity(robber))

        Citizen.SetTimeout(10000, function()
            TriggerEvent('DynamicWorld:Server:Dispatch', event.location, "Store Robbery", "police", "Silent alarm triggered at a local store.")
        end)
    end,
    resume = function(event)
        for _, ent in ipairs(event.entities) do
            local handle = CreatePed(4, GetHashKey(ent.model), ent.coords.x, ent.coords.y, ent.coords.z, ent.heading, true, true)
            EntityManager.Track(event.id, handle, 'ped')
            -- Apply metadata like health
            SetEntityHealth(handle, ent.metadata.health or 200)
        end
    end
})
