class_name CrystalRegistry
extends RefCounted

static var MOVEMENT_CRYSTALS = {
	"phast": PhastDecorator,
	"double_jump": DoubleJumpDecorator,
}

static var SHOOTING_CRYSTALS = {
	"rapid_fire": RapidFireDecorator,
	"triple_shot": TripleShotDecorator,
	"fast_bullets": FastBulletsDecorator,
	"recoil": RecoilDecorator,
}


static func get_all_crystals() -> Array[String]:
	var all: Array[String] = []
	all.append_array(MOVEMENT_CRYSTALS.keys())
	all.append_array(SHOOTING_CRYSTALS.keys())
	return all


static func is_movement_crystal(crystal_name: String) -> bool:
	return MOVEMENT_CRYSTALS.has(crystal_name)


static func is_shooting_crystal(crystal_name: String) -> bool:
	return SHOOTING_CRYSTALS.has(crystal_name)


static func create_movement_decorator(crystal_name: String, base: MoverInterface) -> MoverInterface:
	if not MOVEMENT_CRYSTALS.has(crystal_name):
		return null
	return MOVEMENT_CRYSTALS[crystal_name].new(base)


static func create_shooting_decorator(
	crystal_name: String, base: ShooterInterface
) -> ShooterInterface:
	if not SHOOTING_CRYSTALS.has(crystal_name):
		return null

	return SHOOTING_CRYSTALS[crystal_name].new(base)
