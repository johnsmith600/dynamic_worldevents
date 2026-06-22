# Dynamic World Events

**Dynamic World** is a production-quality FiveM resource that generates immersive, dynamic server events autonomously. Built exclusively around the **Ultimate Bridge**, it is fully compatible with ESX Legacy, QBCore (v1.3+), Qbox, and Standalone.

## Features

- **Intelligent Event Scheduler:** Weights, cooldowns, and player-count scaling ensure a fresh experience.
- **Persistence:** Active events and their NPCs/vehicles are saved to the database and resume exactly where they left off after a server restart.
- **Dynamic AI Behavior:** NPCs react realistically to gunshots/explosions, panic, flee, and cluster during events.
- **Diverse Event Categories:**
  - **Emergency:** Fires, gas leaks, crashes, industrial accidents.
  - **Criminal:** Robberies, weapon deals, suspicious persons.
  - **Civilian:** Broken down vehicles, medical emergencies.
  - **Traffic:** Multi-vehicle pileups, roadworks.
  - **Weather:** Heatwaves, storm effects.
  - **Economy:** Fuel shortages, inflation (impacts NPC behavior and prices).
- **Framework Agnostic:** Zero direct dependencies on ESX/QB; all interactions use Ultimate Bridge.
- **PolyZone Integration:** Whitelist or blacklist specific areas of the map for events.
- **Admin Tools:** Commands for starting, stopping, and debugging events in real-time.

## Installation

1. Clone or download this repository.
2. Ensure you have the following dependencies installed:
   - [Ultimate Bridge](https://github.com/johnsmith600/ultimate_bridge)
   - [PolyZone](https://github.com/mkafrin/PolyZone)
   - [oxmysql](https://github.com/overextended/oxmysql)
3. Import `database/schema.sql` into your database.
4. Add `ensure dynamic_world` to your `server.cfg` after its dependencies.
5. Configure the resource in `config/config.lua`.

## Public API

### Exports (Server/Client)
```lua
exports.dynamic_world:StartEvent(type)
exports.dynamic_world:StopEvent(id)
exports.dynamic_world:GetEvents()
exports.dynamic_world:GetEvent(id)
exports.dynamic_world:IsEventRunning(type)
exports.dynamic_world:RegisterEvent(eventTable)
exports.dynamic_world:CompleteEvent(id)
exports.dynamic_world:FailEvent(id)
```

### Events
```lua
AddEventHandler('DynamicWorld:EventStarted', function(event) ... end)
AddEventHandler('DynamicWorld:EventUpdated', function(event) ... end)
AddEventHandler('DynamicWorld:EventFinished', function(event) ... end)
AddEventHandler('DynamicWorld:EventFailed', function(event) ... end)
```

## Admin Commands

- `/startevent [type]` - Force start a specific event.
- `/stopevent [id]` - Stop an active event.
- `/eventlist` - List all currently active events.
- `/eventtp [id]` - Teleport to an active event.
- `/eventdebug` - Toggle debug logs.
- `/reloadevents` - Reload event definitions.

## License

Modified MIT License - Commercial use allowed, redistribution and selling not allowed. See `LICENSE` for details.
