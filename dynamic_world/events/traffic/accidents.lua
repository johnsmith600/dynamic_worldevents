-- Traffic Pileup
RegisterEvent({
    name = "Traffic Pileup",
    weight = 15,
    minimumPlayers = 3,
    radius = 50.0,
    duration = 1200,
    start = function(event)
        local coords = event.location
        for i=1, 3 do
            local veh = CreateVehicle(`emperor`, coords.x + (i*5), coords.y, coords.z, 0.0, true, true)
            SetVehicleDamage(veh, 0.0, 0.0, 0.3, 1000.0, 100.0, true)
            EntityManager.Track(event.id, veh, 'vehicle')
        end
        TriggerEvent('DynamicWorld:Server:Dispatch', event.location, "Traffic Pileup", "police", "Multiple vehicle pileup reported.")
    end
})
