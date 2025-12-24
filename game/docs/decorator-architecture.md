# Modifier Pattern Architecture

## Overview
This document describes the modifier pattern implementation for the movement and shooting systems in Epic Footsies 2. This architecture separates **modification logic** (what modifiers do) from **execution logic** (what the core systems do), providing clear semantic separation.

## Movement System

```mermaid
classDiagram
    class Mover {
        -JUMP_VELOCITY: float
        -GRAVITY: float
        -speed: float
        +process_movement(input_vector, delta, context) Vector3
    }

    class MovementModifier {
        <<abstract>>
        +modify(context) void
    }

    class DoubleJumpModifier {
        -max_jumps: int
        +modify(context) void
    }

    class PhastModifier {
        -speed_multiplier: float
        +modify(context) void
    }

    class MovementContext {
        +velocity_y: float
        +is_on_floor: bool
        +jump_pressed: bool
        +jump_count: int
        +jump_requested: bool
        +speed_multiplier: float
    }

    MovementModifier <|-- DoubleJumpModifier
    MovementModifier <|-- PhastModifier
    MovementModifier ..> MovementContext : modifies
    Mover ..> MovementContext : uses
```

## Shooting System

```mermaid
classDiagram
    class Shooter {
        -bullet_scene: PackedScene
        -bullet_speed: float
        +shoot_delay: float
        +shoot(context) void
        -spawn_bullet(...) void
    }

    class ShootingModifier {
        <<abstract>>
        +modify(context) void
    }

    class FastBulletsModifier {
        -speed_multiplier: float
        +modify(context) void
    }

    class RapidFireModifier {
        -delay_multiplier: float
        +modify(context) void
    }

    class TripleShotModifier {
        -spread_angle: float
        +modify(context) void
    }

    class ShootingContext {
        +from_position: Vector3
        +direction: Vector3
        +team_color: Color
        +parent: Node
        +bullet_speed: float
        +bullet_scene: PackedScene
        +speed_multiplier: float
        +delay_multiplier: float
        +extra_shots: Array~Dictionary~
    }

    ShootingModifier <|-- FastBulletsModifier
    ShootingModifier <|-- RapidFireModifier
    ShootingModifier <|-- TripleShotModifier
    ShootingModifier ..> ShootingContext : modifies
    Shooter ..> ShootingContext : uses
```

## Player Orchestration

```mermaid
sequenceDiagram
    participant Player
    participant Modifiers
    participant Context
    participant Executor

    Note over Player: Movement/Shooting triggered
    Player->>Context: Create context with base state
    Player->>Modifiers: for each modifier
    Modifiers->>Context: modify(context)
    Player->>Executor: execute with modified context
    Executor->>Player: return result
```

## Semantic Analysis

### Why This Architecture?

The previous decorator pattern had a semantic issue: both decorators and implementations had the same interface (`shoot()`, `process_movement()`), but they did fundamentally different things:
- **Implementations** actually performed actions (spawned bullets, applied physics)
- **Decorators** just modified context and passed through

This created confusion: "If TripleShotDecorator is a Shooter, why doesn't it shoot?"

### The Solution: Separate Interfaces

**Modifiers** and **Executors** now implement different interfaces:

| Component | Interface | Purpose | Semantic Clarity |
|-----------|-----------|---------|------------------|
| **Mover** | `process_movement()` | Actually processes movement with physics | ✅ Clear - it moves things |
| **MovementModifier** | `modify(context)` | Modifies movement parameters | ✅ Clear - it modifies |
| **Shooter** | `shoot(context)` | Actually spawns bullets | ✅ Clear - it shoots |
| **ShootingModifier** | `modify(context)` | Modifies shooting parameters | ✅ Clear - it modifies |

### Naming Conventions

| Old Name | New Name | Rationale |
|----------|----------|-----------|
| `DefaultMover` | `Mover` | Removed "Default" - it's not a fallback, it's the core implementation |
| `DefaultShooter` | `Shooter` | Removed "Default" - it's the only implementation |
| `MoverDecorator` | `MovementModifier` | Renamed to reflect what it does: modifies movement |
| `ShooterDecorator` | `ShootingModifier` | Renamed to reflect what it does: modifies shooting |
| `*Decorator` | `*Modifier` | All powerup decorators renamed to modifiers |

### Movement Modifiers

| Modifier | Purpose | Semantic Accuracy |
|-----------|---------|-------------------|
| **DoubleJumpModifier** | Enables multiple jumps by setting `jump_requested` flag | ✅ Modifies jump behavior |
| **PhastModifier** | Increases speed by multiplying `speed_multiplier` | ✅ Modifies speed |

### Shooting Modifiers

| Modifier | Purpose | Semantic Accuracy |
|-----------|---------|-------------------|
| **FastBulletsModifier** | Increases bullet speed via `speed_multiplier` | ✅ Modifies bullet speed |
| **RapidFireModifier** | Reduces delay via `delay_multiplier` | ✅ Modifies fire rate |
| **TripleShotModifier** | Adds extra shots to `extra_shots` array | ✅ Modifies shot pattern |

## Design Pattern: Modifier Pattern

This is NOT the classic Decorator pattern. It's a **Modifier pattern** with these characteristics:

1. **Separate Interfaces**: Modifiers and executors implement different interfaces
2. **Context Object**: Shared state container for modifications
3. **Orchestrated Execution**: Player coordinates: modify → execute
4. **No Wrapping**: Modifiers don't wrap executors; they're separate objects

### Pattern Structure

```gdscript
# In Player
var mover: Mover                              # The executor
var movement_modifiers: Array[MovementModifier]  # The modifiers

func _process_movement(delta):
    # 1. Create context
    var context = MovementContext.new(...)

    # 2. Apply all modifiers
    for modifier in movement_modifiers:
        modifier.modify(context)

    # 3. Execute with modified context
    velocity = mover.process_movement(input, delta, context)
```

## Context Objects

### MovementContext
Acts as a data transfer object that:
- Carries state from Player to Mover (velocity_y, is_on_floor, jump_pressed, jump_count)
- Allows modifiers to set flags (jump_requested) and multipliers (speed_multiplier)
- Returns updated state to Player (jump_count)

### ShootingContext
Acts as a data transfer object that:
- Carries shooting parameters (position, direction, team_color)
- Accumulates modifications (speed_multiplier, delay_multiplier, extra_shots)
- Provides configuration to Shooter for bullet spawning

## Implementation Flow

### Movement System
1. **Player** creates `MovementContext` with current state
2. **Each MovementModifier** modifies the context:
   - `DoubleJumpModifier`: May set `jump_requested = true`
   - `PhastModifier`: Multiplies `speed_multiplier`
3. **Mover** processes movement using modified context
4. **Player** receives updated velocity and state

### Shooting System
1. **Player** creates `ShootingContext` with position/direction
2. **Each ShootingModifier** modifies the context:
   - `TripleShotModifier`: Adds entries to `extra_shots`
   - `FastBulletsModifier`: Multiplies `speed_multiplier`
   - `RapidFireModifier`: Multiplies `delay_multiplier`
3. **Shooter** spawns all bullets based on modified context
4. **Player** sets cooldown using `shooter.shoot_delay * context.delay_multiplier`

## Order Independence

Unlike the decorator pattern, modifier order is **mostly independent**:

### Movement Modifiers
- Modifiers set independent context fields
- Multiple speed multipliers compound multiplicatively (commutative)
- Jump modifiers set boolean flags (order doesn't matter)

### Shooting Modifiers
- Each modifies orthogonal context fields
- Speed multipliers compound multiplicatively (commutative)
- Extra shots accumulate in array (order only affects array order, not behavior)
- Delay multipliers compound multiplicatively (commutative)

## Adding New Modifiers

### Create a Movement Modifier
```gdscript
class_name MyMovementModifier
extends MovementModifier

func modify(context: MovementContext) -> void:
    # Modify context fields as needed
    context.speed_multiplier *= 2.0
```

### Create a Shooting Modifier
```gdscript
class_name MyShootingModifier
extends ShootingModifier

func modify(context: ShootingContext) -> void:
    # Modify context fields as needed
    context.speed_multiplier *= 1.5
```

### Register in PowerUpRegistry
```gdscript
var movement_powerups = {
    "my_powerup": MyMovementModifier,
}
```

## Benefits Over Decorator Pattern

1. **Semantic Clarity**: Modifiers modify, executors execute - no ambiguity
2. **Simpler Construction**: No nested wrapping chains to manage
3. **Easy to Inspect**: Array of modifiers is easier to debug than nested wrappers
4. **Order Independence**: Most modifiers can be applied in any order
5. **Single Responsibility**: Each component has one clear purpose
6. **Explicit Flow**: Player orchestration makes the pipeline obvious
