class_name PowerUpRegistry
extends RefCounted

var movement_powerups = {
	"phast": PhastModifier,
	"double_jump": DoubleJumpModifier,
}

var shooting_powerups = {
	"rapid_fire": RapidFireModifier,
	"triple_shot": TripleShotModifier,
	"fast_bullets": FastBulletsModifier,
}


func get_all_powerups() -> Array[String]:
	var all: Array[String] = []
	all.append_array(movement_powerups.keys())
	all.append_array(shooting_powerups.keys())
	return all


func is_movement_powerup(name: String) -> bool:
	return movement_powerups.has(name)


func is_shooting_powerup(name: String) -> bool:
	return shooting_powerups.has(name)


func create_movement_modifier(name: String) -> MovementModifier:
	if not movement_powerups.has(name):
		return null
	return movement_powerups[name].new()


func create_shooting_modifier(name: String) -> ShootingModifier:
	if not shooting_powerups.has(name):
		return null
	return shooting_powerups[name].new()
