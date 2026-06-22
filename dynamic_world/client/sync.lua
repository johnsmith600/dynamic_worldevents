-- Event definitions
Scheduler = Scheduler or {}
Scheduler.ActiveEvents = {}

function Scheduler.GetEvent(id)
    return Scheduler.ActiveEvents[id]
end

RegisterNetEvent('DynamicWorld:SyncEvents', function(events)
    Scheduler.ActiveEvents = events
end)

RegisterNetEvent('DynamicWorld:EventStarted', function(event)
    Scheduler.ActiveEvents[event.id] = event
    UI.ShowEventNotification(event)
end)

RegisterNetEvent('DynamicWorld:EventUpdated', function(event)
    Scheduler.ActiveEvents[event.id] = event
end)

RegisterNetEvent('DynamicWorld:EventFinished', function(event)
    Scheduler.ActiveEvents[event.id] = nil
end)

RegisterNetEvent('DynamicWorld:EventFailed', function(event)
    Scheduler.ActiveEvents[event.id] = nil
end)

Citizen.CreateThread(function()
    TriggerServerEvent('DynamicWorld:RequestSync')
end)
