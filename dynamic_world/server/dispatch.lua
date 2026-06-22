-- Dispatch Wrapper
RegisterNetEvent('DynamicWorld:Server:Dispatch', function(coords, title, job, message)
    local source = source
    local dispatchType = Config.Dispatch.Default

    if dispatchType == 'bridge' then
        local players = Utils.GetPlayersByJob(job)
        for _, playerId in ipairs(players) do
            Utils.NotifyPlayer(playerId, ("[%s] %s: %s"):format(title, job:upper(), message), "inform")
        end
    elseif dispatchType == 'ps-dispatch' then
        exports['ps-dispatch']:CustomAlert({
            coords = coords,
            message = message,
            dispatchCode = title,
            description = message,
            radius = 0,
            sprite = 64,
            color = 1,
            scale = 1.0,
            length = 3000,
        })
    end
end)

-- NPC Request Dispatch
RegisterNetEvent('DynamicWorld:RequestDispatch', function(coords, message)
    -- Map NPC requests to the main dispatch logic
    TriggerEvent('DynamicWorld:Server:Dispatch', coords, "NPC Report", "police", message)
end)
