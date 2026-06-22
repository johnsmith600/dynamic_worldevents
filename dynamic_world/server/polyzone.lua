-- PolyZone Integration Logic
PolyZoneManager = {
    Zones = {} -- { name = "Blacklist1", type = "blacklist", zone = polyzoneObject }
}

function PolyZoneManager.IsPointRestricted(coords)
    if #PolyZoneManager.Zones == 0 then return false end

    for _, z in ipairs(PolyZoneManager.Zones) do
        if z.type == "blacklist" and z.zone:isPointInside(coords) then
            return true
        end
    end

    local hasWhitelist = false
    local inWhitelist = false
    for _, z in ipairs(PolyZoneManager.Zones) do
        if z.type == "whitelist" then
            hasWhitelist = true
            if z.zone:isPointInside(coords) then
                inWhitelist = true
                break
            end
        end
    end

    if hasWhitelist and not inWhitelist then return true end

    return false
end

-- Example of adding a zone
function PolyZoneManager.AddZone(name, type, points, options)
    local zone = nil
    -- Since direct inclusion failed, we rely on PolyZone being a separate resource
    -- and we'll use a safer approach for initialization.
    -- If PolyZone is not available as a global, we can't create zones this way.
    -- In production, the user should ensure PolyZone is loaded before this.

    pcall(function()
        if _G.PolyZone then
            zone = _G.PolyZone:Create(points, options)
        end
    end)

    if zone then
        PolyZoneManager.Zones[#PolyZoneManager.Zones+1] = {
            name = name,
            type = type,
            zone = zone
        }
    else
        print(("^1[Dynamic World] Warning: Could not create PolyZone '%s'. PolyZone might not be loaded.^7"):format(name))
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    -- Delay initialization to ensure other resources (PolyZone) are ready
    Citizen.SetTimeout(1000, function()
        for _, z in ipairs(Config.Zones) do
            PolyZoneManager.AddZone(z.name, z.type, z.points, z.options)
        end
    end)
end)
