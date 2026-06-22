Utils = Utils or {}

-- Client-side coordinate helper
if not IsDuplicityVersion() then
    ---@param center vector3
    ---@param radius number
    ---@return vector3|nil
    function Utils.GetRandomSafeCoord(center, radius)
        for i = 1, 20 do
            local angle = math.random() * 2 * math.pi
            local r = radius * math.sqrt(math.random())
            local x = center.x + r * math.cos(angle)
            local y = center.y + r * math.sin(angle)

            local success, groundZ = GetGroundZFor_3dCoord(x, y, 1000.0, false)
            if success then
                local waterSuccess, waterHeight = GetWaterHeight(x, y, groundZ)
                if not waterSuccess then
                    return vector3(x, y, groundZ)
                end
            end
        end
        return nil
    end

    RegisterNetEvent('DynamicWorld:RequestSafeCoord', function(center, radius, cbEvent)
        local coord = Utils.GetRandomSafeCoord(center, radius)
        TriggerServerEvent(cbEvent, coord)
    end)
end
