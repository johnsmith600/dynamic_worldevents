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
    end
    Bridge.Notify(message, type or 'inform')
end

---@param title string
---@param text string
---@param duration number?
function Utils.TextUI(title, text, duration)
    Bridge.TextUI(title, text)
    if duration then
        Citizen.SetTimeout(duration, function()
            Bridge.HideTextUI()
        end)
    end
end

---@param label string
---@param duration number
---@param useLib boolean?
function Utils.ProgressBar(label, duration, useLib)
    return Bridge.ProgressBar(label, duration)
end

function Utils.GetPlayer(source)
    if not source then return Bridge.GetPlayer() end
    return Bridge.GetPlayer(source)
end

if not IsDuplicityVersion() then
    -- Client specific utils
    function Utils.GetClosestPed(coords, radius)
        local peds = GetGamePool('CPed')
        local closestPed = -1
        local closestDist = radius or 5.0
        for i=1, #peds do
            local pedCoords = GetEntityCoords(peds[i])
            local dist = #(coords - pedCoords)
            if dist < closestDist and not IsPedAPlayer(peds[i]) then
                closestDist = dist
                closestPed = peds[i]
            end
        end
        return closestPed
    end
else
    -- Server specific utils
    function Utils.GetPlayersByJob(job)
        return Bridge.GetPlayersByJob(job)
    end

    function Utils.GetRandomSafeCoord()
        -- On server, use predefined safe zones to avoid needing collision data
        local safeZones = {
            vector3(185.0, -900.0, 30.0),
            vector3(-1000.0, -2500.0, 13.0),
            vector3(1700.0, 3200.0, 40.0),
            vector3(-300.0, 6100.0, 30.0),
            vector3(1100.0, -1500.0, 34.0),
            vector3(-1155.0, -1519.0, 10.0),
            vector3(425.0, -979.0, 30.0),
            vector3(-70.0, -1100.0, 26.0),
        }
        return safeZones[math.random(#safeZones)]
    end
end
