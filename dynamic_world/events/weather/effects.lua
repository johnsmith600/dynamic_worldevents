-- Weather Events
RegisterEvent({
    name = "Storm Effects",
    weight = 5,
    weather = "CLEARING",
    duration = 600,
    start = function(event)
        TriggerClientEvent('DynamicWorld:Client:WeatherEvent', -1, 'storm', event.location)
    end
})

RegisterEvent({
    name = "Heatwave",
    weight = 5,
    duration = 3600,
    start = function(event)
        WorldState.SetModifier('Heatwave', 3600, {
            temp = 40,
            fireChance = 0.05
        })
        Bridge.Notify("A severe heatwave is hitting the state! Stay hydrated.", "inform")
    end
})
