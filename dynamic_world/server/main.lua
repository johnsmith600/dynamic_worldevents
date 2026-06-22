function StartEvent(type)
    return Scheduler.CreateEvent(type)
end

function StopEvent(id)
    local event = Scheduler.ActiveEvents[id]
    if event then
        event.state = 'Expired'
        Persistence.SaveEvent(event)
        TriggerClientEvent('DynamicWorld:EventFinished', -1, event)
        TriggerEvent('DynamicWorld:EventFinished', event)
        return true
    end
    return false
end

function GetEvents()
    return Scheduler.ActiveEvents
end

function GetEvent(id)
    return Scheduler.ActiveEvents[id]
end

function IsEventRunning(type)
    for _, event in pairs(Scheduler.ActiveEvents) do
        if event.type == type then return true end
    end
    return false
end

function RegisterEvent(eventTable)
    Scheduler.RegisterEventType(eventTable)
end

function CompleteEvent(id)
    local event = Scheduler.ActiveEvents[id]
    if event then
        event.state = 'Resolved'
        Persistence.SaveEvent(event)
        TriggerClientEvent('DynamicWorld:EventFinished', -1, event)
        TriggerEvent('DynamicWorld:EventFinished', event)
        return true
    end
    return false
end

function FailEvent(id)
    local event = Scheduler.ActiveEvents[id]
    if event then
        event.state = 'Failed'
        Persistence.SaveEvent(event)
        TriggerClientEvent('DynamicWorld:EventFailed', -1, event)
        TriggerEvent('DynamicWorld:EventFailed', event)
        return true
    end
    return false
end

RegisterNetEvent('DynamicWorld:RequestSync', function()
    local src = source
    TriggerClientEvent('DynamicWorld:SyncEvents', src, Scheduler.ActiveEvents)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    local savedEvents = Persistence.LoadActiveEvents()
    for _, eventData in ipairs(savedEvents) do
        Scheduler.ActiveEvents[eventData.id] = eventData
        local config = Scheduler.EventTypes[eventData.type]
        if config and config.resume then
            config.resume(eventData)
        end
    end

    Scheduler.Start()
end)
