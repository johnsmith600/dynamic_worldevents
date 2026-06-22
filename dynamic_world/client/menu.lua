-- Client Side Admin Menu
RegisterNetEvent('DynamicWorld:Client:OpenAdminMenu', function()
    TriggerServerEvent('DynamicWorld:Server:RequestAdminData')
end)

RegisterNetEvent('DynamicWorld:Client:ReceiveAdminData', function(data)
    local menuOptions = {
        {
            header = "Dynamic World Admin Menu",
            isMenuHeader = true
        },
        {
            header = "Active Events",
            txt = "View and manage current events",
            params = {
                event = "DynamicWorld:Client:OpenActiveEventsMenu",
                args = data.active
            }
        },
        {
            header = "Start New Event",
            txt = "Manually trigger a world event",
            params = {
                event = "DynamicWorld:Client:OpenStartEventsMenu",
                args = data.types
            }
        }
    }

    UIWrapper.OpenMenu(menuOptions)
end)

RegisterNetEvent('DynamicWorld:Client:OpenActiveEventsMenu', function(active)
    local options = {
        {
            header = "Dynamic World Admin Menu",
            isMenuHeader = true
        },
        {
            header = "< Back",
            params = {
                event = "DynamicWorld:Client:OpenAdminMenu"
            }
        }
    }

    for _, event in ipairs(active) do
        table.insert(options, {
            header = event.type .. " (" .. event.id .. ")",
            txt = "State: " .. event.state,
            params = {
                event = "DynamicWorld:Client:EventManageMenu",
                args = event
            }
        })
    end

    UIWrapper.OpenMenu(options)
end)

RegisterNetEvent('DynamicWorld:Client:EventManageMenu', function(event)
    local options = {
        {
            header = "Event: " .. event.type,
            isMenuHeader = true
        },
        {
            header = "< Back",
            params = {
                event = "DynamicWorld:Client:OpenActiveEventsMenu"
            }
        },
        {
            header = "Teleport to Event",
            params = {
                isServer = true,
                event = "DynamicWorld:Server:AdminAction",
                args = { action = "tp", id = event.id }
            }
        },
        {
            header = "Stop Event",
            params = {
                isServer = true,
                event = "DynamicWorld:Server:AdminAction",
                args = { action = "stop", id = event.id }
            }
        }
    }

    UIWrapper.OpenMenu(options)
end)

RegisterNetEvent('DynamicWorld:Client:OpenStartEventsMenu', function(types)
    local options = {
        {
            header = "Trigger New Event",
            isMenuHeader = true
        },
        {
            header = "< Back",
            params = {
                event = "DynamicWorld:Client:OpenAdminMenu"
            }
        }
    }

    for _, type in ipairs(types) do
        table.insert(options, {
            header = type.name,
            txt = "Weight: " .. type.weight,
            params = {
                isServer = true,
                event = "DynamicWorld:Server:AdminAction",
                args = { action = "start", type = type.name }
            }
        })
    end

    UIWrapper.OpenMenu(options)
end)
