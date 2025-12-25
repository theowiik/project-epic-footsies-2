# Recoil Powerup: Why Decorator Pattern is Required

## The Powerup

**Recoil** - When the player shoots, they get knocked back in the opposite direction. This simulates weapon recoil and adds a tactical element to combat positioning.

## Implementation

```gdscript
class_name RecoilDecorator
extends ShooterDecorator

var player: CharacterBody3D
var knockback_strength: float = 3.0

func shoot(context: ShootingContext) -> void:
    # First, delegate to wrapped shooter to actually shoot
    wrapped_shooter.shoot(context)

    # THEN apply knockback as a side effect
    var knockback_direction = -context.direction
    knockback_direction.y = 0  # Only horizontal knockback

    if player:
        player.velocity += knockback_direction.normalized() * knockback_strength
```

## Why This Requires the Decorator Pattern

This powerup demonstrates a capability that the simpler "modify-then-execute" pattern **cannot handle**: **running code AFTER execution**.

### What the Old "Modify-Then-Execute" Pattern Could Do:

```gdscript
# Pattern: Decorators only had modify(context)
class SomeModifier:
    func modify(context):
        context.speed_multiplier *= 2.0  # Pre-configure
        context.extra_shots.append(...)  # Add data

# Player orchestrated:
for modifier in modifiers:
    modifier.modify(context)  # All modifications happen BEFORE
shooter.shoot(context)        # Then execute
```

**This pattern can only:**
- ✅ Modify context fields BEFORE shooting
- ✅ Add data that the shooter reads
- ❌ **Run code AFTER shooting happens** ← Can't do this!

### Why Recoil Needs Post-Execution Code:

The knockback must happen **AFTER** the bullets are spawned because:

1. **Temporal ordering matters**: Bullets spawn, THEN player gets knocked back
2. **Side effect on player**: The decorator needs to modify the player's velocity, not just the shooting context
3. **Cannot be pre-configured**: There's no "knockback field" the shooter reads - this is a direct action on the player

### The Decorator Pattern Solution:

```gdscript
func shoot(context) -> void:
    wrapped_shooter.shoot(context)  # Bullets spawn
    # Now bullets exist in the world
    player.velocity += knockback    # THEN knockback happens
```

The decorator pattern allows us to:
1. Call the wrapped shooter (bullets spawn)
2. **Wait for that to complete**
3. **Then** execute additional code (knockback)

This is **wrapping**, not just modification.

## Other Use Cases Requiring This Pattern

All of these need to run code AFTER execution:

### 1. Muzzle Flash / Sound Effects
```gdscript
func shoot(context) -> void:
    wrapped_shooter.shoot(context)
    play_muzzle_flash_particles()  # After shooting
    play_gun_sound()                # After shooting
```

### 2. Ammo Consumption
```gdscript
func shoot(context) -> void:
    wrapped_shooter.shoot(context)
    ammo -= 1  # Decrement after successful shot
```

### 3. Screen Shake
```gdscript
func shoot(context) -> void:
    wrapped_shooter.shoot(context)
    camera.apply_shake(0.2, 0.1)  # Shake after shooting
```

### 4. Heat/Overheat Tracking
```gdscript
func shoot(context) -> void:
    wrapped_shooter.shoot(context)
    heat += 20  # Add heat after each shot
    if heat > 100:
        start_cooldown_period()
```

### 5. Bullet Trail Effects
```gdscript
func shoot(context) -> void:
    wrapped_shooter.shoot(context)
    # After bullets spawn, find them and add trails
    var bullets = get_recently_spawned_bullets()
    for bullet in bullets:
        bullet.add_trail_effect()
```

## Pre-Execution vs Post-Execution

The decorator pattern supports BOTH:

### Pre-Execution (modify before calling):
```gdscript
func shoot(context) -> void:
    context.speed_multiplier *= 2.0  # Modify
    wrapped_shooter.shoot(context)   # Then delegate
```

### Post-Execution (act after calling):
```gdscript
func shoot(context) -> void:
    wrapped_shooter.shoot(context)   # Delegate first
    player.velocity += knockback      # Then act
```

### Both:
```gdscript
func shoot(context) -> void:
    play_charging_sound()             # Before
    context.speed_multiplier *= 2.0   # Before
    wrapped_shooter.shoot(context)    # Execute
    player.velocity += knockback       # After
    play_recoil_sound()               # After
```

## Conditional Prevention (Bonus)

The decorator pattern also enables preventing execution:

```gdscript
class AmmoDecorator extends ShooterDecorator:
    var ammo: int = 10

    func shoot(context) -> void:
        if ammo <= 0:
            play_empty_click()
            return  # Don't shoot!

        ammo -= 1
        wrapped_shooter.shoot(context)
```

The simpler pattern couldn't do this either - it always calls `shooter.shoot()`.

## Verdict

**Recoil powerup proves we need the decorator pattern** because:
- ✅ It must run code AFTER shooting (knockback)
- ✅ It modifies the player (side effect), not just context
- ✅ The temporal order matters (bullets first, then knockback)

The "modify-then-execute" pattern is simpler but fundamentally cannot handle post-execution side effects, which are essential for many game mechanics.

## How to Use

```gdscript
# In game, apply the recoil powerup
player.apply_powerup("recoil")

# This builds a decorator chain:
# shooter = RecoilDecorator(BaseShooter())

# When player shoots:
# 1. RecoilDecorator.shoot() is called
# 2. It calls BaseShooter.shoot() - bullets spawn
# 3. Then it applies knockback to player
```

The player gets pushed back every time they shoot, creating a tactical trade-off between firepower and positioning.
