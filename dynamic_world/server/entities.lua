EntityManager = {
    TrackedEntities = {} -- [eventId] = { peds = {}, vehicles = {} }
}

function EntityManager.Track(eventId, entityHandle, type)
    if not EntityManager.TrackedEntities[eventId] then
        EntityManager.TrackedEntities[eventId] = { peds = {}, vehicles = {}, objects = {} }
    end

    if type == 'ped' then
        table.insert(EntityManager.TrackedEntities[eventId].peds, entityHandle)
    elseif type == 'vehicle' then
        table.insert(EntityManager.TrackedEntities[eventId].vehicles, entityHandle)
    end
end

function EntityManager.Cleanup(eventId)
    local entities = EntityManager.TrackedEntities[eventId]
    if not entities then return end

    for _, handle in ipairs(entities.vehicles) do
        if DoesEntityExist(handle) then
            DeleteEntity(handle)
        end
    end

    for _, handle in ipairs(entities.peds) do
        if DoesEntityExist(handle) then
            DeleteEntity(handle)
        end
    end

    EntityManager.TrackedEntities[eventId] = nil
    Persistence.ClearEventEntities(eventId)
end

-- Hook into event lifecycle
AddEventHandler('DynamicWorld:EventFinished', function(event)
    EntityManager.Cleanup(event.id)
end)

AddEventHandler('DynamicWorld:EventFailed', function(event)
    EntityManager.Cleanup(event.id)
end)
