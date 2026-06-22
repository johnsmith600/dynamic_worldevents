local activeWorldState = {}

RegisterNetEvent('DynamicWorld:UpdateWorldState', function(modifiers)
    activeWorldState = modifiers
end)

local gasStations = {
    vector3(49.4, -1745.0, 29.3),
    vector3(265.0, -1261.0, 29.3),
    vector3(620.8, 269.1, 103.0),
    vector3(-70.7, -1761.7, 29.5),
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        local shortage = activeWorldState['FuelShortage']
        if shortage then
            local playerCoords = GetEntityCoords(PlayerPedId())
            for _, station in ipairs(gasStations) do
                if #(playerCoords - station) < 100.0 then
                    local peds = GetGamePool('CPed')
                    for _, ped in ipairs(peds) do
                        if not IsPedAPlayer(ped) and #(GetEntityCoords(ped) - station) < 50.0 then
                            if math.random() < shortage.data.npcProbability then
                                AI.SetBehavior(ped, 'wait')
                                SetDriveTaskDrivingStyle(ped, 786603) -- Aggressive/Panic driving
                            end
                        end
                    end
                end
            end
        end
    end
end)
