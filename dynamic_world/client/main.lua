local activeEffects = {}

RegisterNetEvent('DynamicWorld:Client:StartGasLeak', function(event)
    local coords = event.location
    local radius = event.radius

    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do Wait(0) end

    UseParticleFxAssetNextCall("core")
    local fx = StartParticleFxLoopedAtCoord("exp_grd_bzgas", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)

    activeEffects[event.id] = fx

    Citizen.CreateThread(function()
        while Scheduler.GetEvent(event.id) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - coords) < radius then
                ApplyDamageToPed(PlayerPedId(), 1, false)
                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.05)
            end
            Citizen.Wait(1000)
        end
        StopParticleFxLooped(fx, false)
    end)
end)

RegisterNetEvent('DynamicWorld:Client:StartVehicleCrash', function(event)
    -- Logic already exists in previous implementation or handled by server spawning entities
end)

RegisterNetEvent('DynamicWorld:Client:StartStoreRobbery', function(event, robberNetId)
    local robber = NetToPed(robberNetId)
    if DoesEntityExist(robber) then
        AI.SetBehavior(robber, 'fight', PlayerPedId())
    end
end)

RegisterNetEvent('DynamicWorld:Client:StartBushFire', function(event)
    local coords = event.location
    StartScriptFire(coords.x, coords.y, coords.z, 25, false)
end)

RegisterNetEvent('DynamicWorld:Client:StartExplosion', function(event)
    AddExplosion(event.location.x, event.location.y, event.location.z, 2, 100.0, true, false, 1.0)
end)
