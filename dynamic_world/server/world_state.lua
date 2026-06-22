WorldState = {
    ActiveModifiers = {}
}

---@param name string
---@param duration number seconds
---@param data table
function WorldState.SetModifier(name, duration, data)
    WorldState.ActiveModifiers[name] = {
        expires = os.time() + duration,
        data = data
    }
    TriggerClientEvent('DynamicWorld:UpdateWorldState', -1, WorldState.ActiveModifiers)
end

function WorldState.GetModifier(name)
    local mod = WorldState.ActiveModifiers[name]
    if mod and os.time() < mod.expires then
        return mod.data
    end
    return nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        local now = os.time()
        local changed = false
        for name, mod in pairs(WorldState.ActiveModifiers) do
            if now >= mod.expires then
                WorldState.ActiveModifiers[name] = nil
                changed = true
            end
        end
        if changed then
            TriggerClientEvent('DynamicWorld:UpdateWorldState', -1, WorldState.ActiveModifiers)
        end
    end
end)

-- Handle specific economy logic
function WorldState.HandleFuelShortage()
    WorldState.SetModifier('FuelShortage', 3600, {
        npcProbability = Config.Economy.FuelShortage.NPCProbability,
        priceMultiplier = Config.Economy.FuelShortage.PriceMultiplier
    })
end
