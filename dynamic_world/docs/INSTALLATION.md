# Dynamic World Installation Guide

## Dependencies
- Ultimate Bridge (Required)
- PolyZone (Required)
- A supported database (oxmysql recommended)

## Installation
1. Download `dynamic_world`.
2. Import `database/schema.sql` into your database.
3. Add `ensure dynamic_world` to your `server.cfg` after `ultimate_bridge` and `PolyZone`.
4. Configure `config/config.lua` to your liking.

## API Usage
You can start events from other scripts using:
```lua
exports.dynamic_world:StartEvent('Gas Leak')
```

## Creating Custom Events
Register a new event in any server-side script:
```lua
exports.dynamic_world:RegisterEvent({
    name = "My Custom Event",
    weight = 10,
    start = function(event)
        -- Your logic
    end
})
```
