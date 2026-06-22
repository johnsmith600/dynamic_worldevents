-- Server side data for menu
RegisterNetEvent('DynamicWorld:Server:RequestAdminData', function()
    local src = source
    if not Bridge.HasPermission(src, 'admin') then return end

    local eventTypes = {}
    for name, config in pairs(Scheduler.EventTypes) do
        table.insert(eventTypes, {
            name = name,
            weight = config.weight,
            minPlayers = config.minimumPlayers
        })
    end

    local activeEvents = {}
    for id, event in pairs(Scheduler.ActiveEvents) do
        table.insert(activeEvents, {
            id = id,
            type = event.type,
            state = event.state,
            location = event.location
        })
    end

    TriggerClientEvent('DynamicWorld:Client:ReceiveAdminData', src, {
        types = eventTypes,
        active = activeEvents
    })
end)

RegisterCommand('eventmenu', function(source)
    if source ~= 0 and not Bridge.HasPermission(source, 'admin') then return end
    TriggerClientEvent('DynamicWorld:Client:OpenAdminMenu', source)
end)

RegisterNetEvent('DynamicWorld:Server:AdminAction', function(data)
    local src = source
    if not Bridge.HasPermission(src, 'admin') then return end

    if data.action == "start" then
        Scheduler.CreateEvent(data.type)
        Bridge.Notify(src, "Started event: " .. data.type, "success")
    elseif data.action == "stop" then
        StopEvent(data.id)
        Bridge.Notify(src, "Stopped event: " .. data.id, "success")
    elseif data.action == "tp" then
        local event = GetEvent(data.id)
        if event then
            local coords = event.location
            SetEntityCoords(GetPlayerPed(src), coords.x, coords.y, coords.z, false, false, false, true)
        end
    end
end)
