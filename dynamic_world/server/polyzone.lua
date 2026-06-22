-- PolyZone Integration Logic
PolyZoneManager = {
    Zones = {} -- { name = "Blacklist1", type = "blacklist", zone = polyzoneObject }
}

function PolyZoneManager.IsPointRestricted(coords)
    for _, z in ipairs(PolyZoneManager.Zones) do
        if z.type == "blacklist" and z.zone:isPointInside(coords) then
            return true
        end
    end

    -- If there are whitelists, point MUST be in at least one
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
    if PolyZone then
        zone = PolyZone:Create(points, options)
    end

    if zone then
        PolyZoneManager.Zones[#PolyZoneManager.Zones+1] = {
            name = name,
            type = type,
            zone = zone
        }
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for _, z in ipairs(Config.Zones) do
        PolyZoneManager.AddZone(z.name, z.type, z.points, z.options)
    end
end)
