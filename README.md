# Dynamic World Events (Qbox)

**Dynamic World** is a production-quality FiveM resource that generates immersive, dynamic server events autonomously. This version is designed for **Qbox** and utilizes **ox_lib** for UI/UX.

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
- **Qbox Integration:** Native support for Qbox permissions, jobs, and player data.
- **Built-in PolyZone:** Internal logic for blacklist/whitelist zones without external dependencies.
- **Admin Menu:** A robust context menu (powered by ox_lib) for managing events.

## Installation

1. Clone or download this repository.
2. Ensure you have the following dependencies installed:
   - [qbx_core](https://github.com/Qbox-project/qbx_core)
   - [ox_lib](https://github.com/overextended/ox_lib)
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

## Admin Tools

- `/eventmenu` - Open the admin management menu (Context Menu).
- `/startevent [type]` - Force start a specific event.
- `/stopevent [id]` - Stop an active event.
- `/eventlist` - List active events in console.

## License

Modified MIT License - Commercial use allowed, redistribution and selling not allowed. See `LICENSE` for details.
