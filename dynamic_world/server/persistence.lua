Persistence = {}

---@param event table
function Persistence.SaveEvent(event)
    if not Config.Events.SavePersistence then return end

    local data = json.encode({
        location = event.location,
        radius = event.radius,
        reward = event.reward,
        difficulty = event.difficulty,
        timeRemaining = event.timeRemaining,
        customData = event.customData
    })

    MySQL.prepare('INSERT INTO dynamic_events (id, type, data, state) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE data = ?, state = ?',
    {event.id, event.type, data, event.state, data, event.state})
end

---@param eventId string
---@param entityType string
---@param model string
---@param coords vector3
---@param heading number
---@param metadata table
function Persistence.SaveEntity(eventId, entityType, model, coords, heading, metadata)
    if not Config.Events.SavePersistence then return end

    local coordsStr = json.encode({x = coords.x, y = coords.y, z = coords.z})
    local metaStr = json.encode(metadata)

    MySQL.prepare('INSERT INTO dynamic_event_entities (event_id, entity_type, model, coords, heading, metadata) VALUES (?, ?, ?, ?, ?, ?)',
    {eventId, entityType, model, coordsStr, heading, metaStr})
end

function Persistence.ClearEventEntities(eventId)
    if not Config.Events.SavePersistence then return end
    MySQL.prepare('DELETE FROM dynamic_event_entities WHERE event_id = ?', {eventId})
end

function Persistence.DeleteEvent(eventId)
    if not Config.Events.SavePersistence then return end
    MySQL.prepare('DELETE FROM dynamic_events WHERE id = ?', {eventId})
end

function Persistence.LoadActiveEvents()
    if not Config.Events.SavePersistence then return {} end

    local results = MySQL.query.await('SELECT * FROM dynamic_events WHERE state IN ("Pending", "Active", "Escalated")')
    local events = {}

    for _, row in ipairs(results) do
        local data = json.decode(row.data)
        local event = {
            id = row.id,
            type = row.type,
            state = row.state,
            location = vector3(data.location.x, data.location.y, data.location.z),
            radius = data.radius,
            reward = data.reward,
            difficulty = data.difficulty,
            timeRemaining = data.timeRemaining,
            customData = data.customData,
            entities = {}
        }

        local entities = MySQL.query.await('SELECT * FROM dynamic_event_entities WHERE event_id = ?', {row.id})
        for _, entRow in ipairs(entities) do
            local entCoords = json.decode(entRow.coords)
            table.insert(event.entities, {
                type = entRow.entity_type,
                model = entRow.model,
                coords = vector3(entCoords.x, entCoords.y, entCoords.z),
                heading = entRow.heading,
                metadata = json.decode(entRow.metadata)
            })
        end

        table.insert(events, event)
    end

    return events
end
