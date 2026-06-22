-- Bush Fire
RegisterEvent({
    name = "Bush Fire",
    weight = 10,
    minimumPlayers = 1,
    radius = 50.0,
    duration = 1800,
    start = function(event)
        TriggerClientEvent('DynamicWorld:Client:StartBushFire', -1, event)
        TriggerEvent('DynamicWorld:Server:Dispatch', event.location, "Bush Fire", "fire", "Large vegetation fire reported.")
    end
})

-- Industrial Explosion
RegisterEvent({
    name = "Industrial Explosion",
    weight = 5,
    minimumPlayers = 5,
    radius = 100.0,
    duration = 1200,
    start = function(event)
        TriggerClientEvent('DynamicWorld:Client:StartExplosion', -1, event)
        TriggerEvent('DynamicWorld:Server:Dispatch', event.location, "Industrial Accident", "fire", "Major explosion reported at industrial site.")
    end
})
