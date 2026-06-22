-- Internal PolyZone Implementation
PolyZoneManager = {
    Zones = {} -- { name = "Prison", type = "blacklist", points = {}, minZ = 0, maxZ = 100 }
}

---@param points table
---@param x number
---@param y number
---@return boolean
local function isInside(points, x, y)
    local oddNodes = false
    local j = #points
    for i = 1, #points do
        if (points[i].y < y and points[j].y >= y or points[j].y < y and points[i].y >= y) then
            if (points[i].x + (y - points[i].y) / (points[j].y - points[i].y) * (points[j].x - points[i].x) < x) then
                oddNodes = not oddNodes
            end
        end
        j = i
    end
    return oddNodes
end

function PolyZoneManager.IsPointRestricted(coords)
    if #PolyZoneManager.Zones == 0 then return false end

    for _, z in ipairs(PolyZoneManager.Zones) do
        local inside = isInside(z.points, coords.x, coords.y)
        if inside then
            if (not z.minZ or coords.z >= z.minZ) and (not z.maxZ or coords.z <= z.maxZ) then
                if z.type == "blacklist" then return true end
            else
                inside = false -- Out of Z bounds
            end
        end

        -- Logic for whitelisting would go here if needed, but primarily used for blacklisting
    end

    return false
end

function PolyZoneManager.AddZone(name, type, points, options)
    PolyZoneManager.Zones[#PolyZoneManager.Zones+1] = {
        name = name,
        type = type,
        points = points,
        minZ = options.minZ,
        maxZ = options.maxZ
    }
    print(("^2[Dynamic World]^7 Internal Zone Created: %s (%s)"):format(name, type))
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for _, z in ipairs(Config.Zones) do
        PolyZoneManager.AddZone(z.name, z.type, z.points, z.options)
    end
end)
