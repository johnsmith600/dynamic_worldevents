AI = {}

---@param ped number
---@param type string 'panic' | 'flee' | 'fight' | 'wait'
---@param target number?
function AI.SetBehavior(ped, type, target)
    ClearPedTasks(ped)
    if type == 'panic' then
        if IsPedInAnyVehicle(ped, false) then
            TaskVehicleTempAction(ped, GetVehiclePedIsIn(ped, false), 6, 2000) -- Brake Hard
        else
            TaskScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE_UPSET", 0, true)
        end
        SetPedKeepTask(ped, true)
    elseif type == 'flee' then
        if target then
            TaskSmartFleePed(ped, target, 100.0, -1, false, false)
        else
            TaskSmartFleeCoord(ped, GetEntityCoords(ped), 100.0, -1, false, false)
        end
    elseif type == 'fight' then
        SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)
        if target then
            TaskCombatPed(ped, target, 0, 16)
        end
    elseif type == 'wait' then
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_WAITING", 0, true)
    end
end

-- Optimized Gunshot and Explosion Detection
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Fast poll but with guard
        local ped = PlayerPedId()

        local shooting = IsPedShooting(ped)
        local explosion = IsExplosionInArea(-1, -4000.0, -4000.0, -100.0, 4000.0, 8000.0, 1000.0)

        if shooting or explosion then
            local coords = GetEntityCoords(ped)
            local peds = GetGamePool('CPed')
            for i=1, #peds do
                local npcPid = peds[i]
                if not IsPedAPlayer(npcPid) and #(coords - GetEntityCoords(npcPid)) < 40.0 then
                    if shooting then
                        AI.SetBehavior(npcPid, 'flee', ped)
                    else
                        AI.SetBehavior(npcPid, 'panic')
                    end
                end
            end
            Citizen.Wait(2000) -- Prevent spam
        else
            Citizen.Wait(250) -- Idle slower
        end
    end
end)
