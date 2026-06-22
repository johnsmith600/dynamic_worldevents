-- Illegal Weapon Deal
RegisterEvent({
    name = "Weapon Deal",
    weight = 10,
    minimumPlayers = 2,
    radius = 30.0,
    duration = 900,
    start = function(event)
        local coords = event.location

        -- Spawn peds
        local dealer = CreatePed(4, `g_m_y_salvagoon_01`, coords.x, coords.y, coords.z, 0.0, true, true)
        local buyer = CreatePed(4, `g_m_y_mexgoon_01`, coords.x + 2.0, coords.y + 1.0, coords.z, 180.0, true, true)

        EntityManager.Track(event.id, dealer, 'ped')
        EntityManager.Track(event.id, buyer, 'ped')

        Persistence.SaveEntity(event.id, 'ped', 'g_m_y_salvagoon_01', GetEntityCoords(dealer), GetEntityHeading(dealer), {health = 200, behavior = 'hostile'})
        Persistence.SaveEntity(event.id, 'ped', 'g_m_y_mexgoon_01', GetEntityCoords(buyer), GetEntityHeading(buyer), {health = 200, behavior = 'hostile'})
    end
})
