-- Fuel Shortage Economy Event
RegisterEvent({
    name = "Fuel Shortage",
    weight = 5,
    minimumPlayers = 10,
    duration = 3600,
    start = function(event)
        WorldState.HandleFuelShortage()
        Utils.Notify("City-wide fuel shortage reported! Prices are rising.", "error")
    end
})
