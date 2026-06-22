---@class DynamicEvent
---@field id string
---@field type string
---@field location vector3
---@field radius number
---@field state string
---@field timeStarted number
---@field timeRemaining number
---@field reward number
---@field difficulty number
---@field customData table

EventStates = {
    PENDING = 'Pending',
    ACTIVE = 'Active',
    ESCALATED = 'Escalated',
    RESOLVED = 'Resolved',
    FAILED = 'Failed',
    EXPIRED = 'Expired'
}

-- Shared event logic if any
