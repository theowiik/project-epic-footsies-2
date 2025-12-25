class_name CrystalRegistry
extends RefCounted

var movement_crystals = {
	"phast": PhastDecorator,
	"double_jump": DoubleJumpDecorator,
}

var shooting_crystals = {
	"rapid_fire": RapidFireDecorator,
	"triple_shot": TripleShotDecorator,
	"fast_bullets": FastBulletsDecorator,
	"recoil": RecoilDecorator,
}


func get_all_crystals() -> Array[String]:
	var all: Array[String] = []
	all.append_array(movement_crystals.keys())
	all.append_array(shooting_crystals.keys())
	return all


func is_movement_crystal(name: String) -> bool:
	return movement_crystals.has(name)


func is_shooting_crystal(name: String) -> bool:
	return shooting_crystals.has(name)


func create_movement_decorator(name: String, base: MoverInterface) -> MoverInterface:
	if not movement_crystals.has(name):
		return null
	return movement_crystals[name].new(base)


func create_shooting_decorator(
	name: String, base: ShooterInterface, config: ShooterDecoratorConfig = null
) -> ShooterInterface:
	if not shooting_crystals.has(name):
		return null

	return shooting_crystals[name].new(base, config)
