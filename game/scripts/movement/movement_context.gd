class_name MovementContext
extends RefCounted

var velocity_y: float = 0.0
var is_on_floor: bool = false
var jump_pressed: bool = false


func _init(vel_y: float = 0.0, on_floor: bool = false, jump: bool = false):
	velocity_y = vel_y
	is_on_floor = on_floor
	jump_pressed = jump
