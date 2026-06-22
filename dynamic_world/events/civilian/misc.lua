-- Broken Down Vehicle
RegisterEvent({
    name = "Broken Down Vehicle",
    weight = 30,
    minimumPlayers = 1,
    radius = 10.0,
    duration = 1800,
    start = function(event)
        local coords = event.location
        local veh = CreateVehicle(`regina`, coords.x, coords.y, coords.z, 0.0, true, true)
        SetVehicleEngineHealth(veh, 0.0)
        SetVehicleDoorOpen(veh, 4, false, false)

        local owner = CreatePed(4, `a_f_y_topless_01`, coords.x + 2.0, coords.y, coords.z, 0.0, true, true)

        EntityManager.Track(event.id, veh, 'vehicle')
        EntityManager.Track(event.id, owner, 'ped')

        Persistence.SaveEntity(event.id, 'vehicle', 'regina', GetEntityCoords(veh), GetEntityHeading(veh), {health = 0})
        Persistence.SaveEntity(event.id, 'ped', 'a_f_y_topless_01', GetEntityCoords(owner), GetEntityHeading(owner), {health = 200, behavior = 'civilian'})
    end
})
