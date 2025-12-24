class_name PowerUpRegistry
extends RefCounted

var movement_powerups = {
	"phast": PhastDecorator,
	"double_jump": DoubleJumpDecorator,
}

var shooting_powerups = {
	"rapid_fire": RapidFireDecorator,
	"triple_shot": TripleShotDecorator,
	"fast_bullets": FastBulletsDecorator,
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


func create_movement_decorator(name: String) -> MovementDecorator:
	if not movement_powerups.has(name):
		return null
	return movement_powerups[name].new()


func create_shooting_decorator(name: String) -> ShootingDecorator:
	if not shooting_powerups.has(name):
		return null
	return shooting_powerups[name].new()
