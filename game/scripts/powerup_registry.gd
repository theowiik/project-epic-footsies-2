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
	"recoil": RecoilDecorator,
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


func create_movement_decorator(name: String, base: MoverInterface) -> MoverInterface:
	if not movement_powerups.has(name):
		return null
	return movement_powerups[name].new(base)


func create_shooting_decorator(
	name: String, base: ShooterInterface, player: CharacterBody3D = null
) -> ShooterInterface:
	if not shooting_powerups.has(name):
		return null

	# Special case: RecoilDecorator needs player reference
	if name == "recoil" and player:
		return shooting_powerups[name].new(base, player)

	return shooting_powerups[name].new(base)
