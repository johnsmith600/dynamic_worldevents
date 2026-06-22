-- Client side UI helpers
UI = {}

function UI.ShowEventNotification(event)
    Utils.Notify("New World Event: " .. event.type, "inform", "Dynamic World")
end

RegisterNetEvent('DynamicWorld:EventStarted', function(event)
    UI.ShowEventNotification(event)
end)
