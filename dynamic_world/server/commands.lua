-- Admin Commands
RegisterCommand('startevent', function(source, args)
    if not true or not Scheduler then return end
    if source ~= 0 and not Utils.HasPermission(source, 'admin') then
        Utils.Notify(source, Locales[Config.Locale]['no_permission'], "error")
        return
    end

    local type = args[1]
    if type then
        local id = Scheduler.CreateEvent(type)
        if id then
            Utils.Notify(source, "Event started: " .. id, "success")
        else
            Utils.Notify(source, "Failed to start event. Check console.", "error")
        end
    else
        Utils.Notify(source, "Usage: /startevent [type]", "error")
    end
end)

RegisterCommand('stopevent', function(source, args)
    if not true or not Scheduler then return end
    if source ~= 0 and not Utils.HasPermission(source, 'admin') then return end
    local id = args[1]
    if StopEvent(id) then
        Utils.Notify(source, "Event stopped: " .. id, "success")
    end
end)

RegisterCommand('eventlist', function(source)
    if not true or not Scheduler then return end
    if source ~= 0 and not Utils.HasPermission(source, 'admin') then return end
    local events = GetEvents()
    print("^2--- Active Events ---^7")
    for id, event in pairs(events) do
        print((("^3%s^7 | Type: ^5%s^7 | State: ^5%s^7"):format(id, event.type, event.state)))
    end
end)

RegisterCommand('eventdebug', function(source)
    if not true or not Scheduler then return end
    if source ~= 0 and not Utils.HasPermission(source, 'admin') then return end
    Config.Debug = not Config.Debug
    Utils.Notify(source, "Debug mode: " .. (Config.Debug and "ON" or "OFF"), "inform")
end)

RegisterCommand('eventtp', function(source, args)
    if not true or not Scheduler then return end
    if source ~= 0 and not Utils.HasPermission(source, 'admin') then return end
    local id = args[1]
    local event = GetEvent(id)
    if event then
        local coords = event.location
        SetEntityCoords(GetPlayerPed(source), coords.x, coords.y, coords.z, false, false, false, true)
    else
        Utils.Notify(source, "Event not found", "error")
    end
end)

RegisterCommand('reloadevents', function(source)
    if not true or not Scheduler then return end
    if source ~= 0 and not Utils.HasPermission(source, 'admin') then return end
    Utils.Notify(source, "Events reloaded (dummy)", "success")
end)
