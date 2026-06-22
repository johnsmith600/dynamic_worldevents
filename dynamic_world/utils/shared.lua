---@diagnostic disable: duplicate-set-field
Utils = {}

---@param message string
---@param type string?
---@param title string?
function Utils.Notify(message, type, title)
    if not IsDuplicityVersion() then
        if GetResourceState('17mov_Phone') == 'started' then
            exports["17mov_Phone"]:CreateNotification({
                app = "MESSAGES",
                title = title or "World Event",
                message = message
            })
            return
        end
        lib.notify({
            title = title or 'Dynamic World',
            description = message,
            type = type or 'inform'
        })
    else
        -- Server side notify depends on player source, handled elsewhere or via trigger
    end
end

---@param title string
---@param text string
---@param duration number?
function Utils.TextUI(title, text, duration)
    lib.showTextUI(text, {
        position = "right-center",
        icon = 'info',
        style = {
            borderRadius = 0,
            backgroundColor = '#48BB78',
            color = 'white'
        }
    })
    if duration then
        Citizen.SetTimeout(duration, function()
            lib.hideTextUI()
        end)
    end
end

---@param label string
---@param duration number
function Utils.ProgressBar(label, duration)
    if lib.progressBar({
        duration = duration,
        label = label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
    }) then
        return true
    else
        return false
    end
end

if IsDuplicityVersion() then
    -- Server specific utils
    function Utils.HasPermission(source, permission)
        if source == 0 then return true end
        return exports.qbx_core:HasPermission(source, permission)
    end

    function Utils.GetPlayersByJob(job)
        local players = exports.qbx_core:GetDutyCount(job) -- This is count, we need list
        -- Qbox/QBCore usually have different ways to get player list by job
        local jobPlayers = {}
        local allPlayers = exports.qbx_core:GetQBPlayers()
        for _, v in pairs(allPlayers) do
            if v.PlayerData.job.name == job and v.PlayerData.job.onduty then
                table.insert(jobPlayers, v.PlayerData.source)
            end
        end
        return jobPlayers
    end

    function Utils.GetPlayer(source)
        return exports.qbx_core:GetPlayer(source)
    end

    function Utils.NotifyPlayer(source, message, type, title)
        TriggerClientEvent('ox_lib:notify', source, {
            title = title or 'Dynamic World',
            description = message,
            type = type or 'inform'
        })
    end
end
