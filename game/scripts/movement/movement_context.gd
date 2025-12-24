class_name MovementContext
extends RefCounted

var velocity_y: float = 0.0
var is_on_floor: bool = false
var jump_pressed: bool = false
var jump_count: int = 0
var jump_requested: bool = false


func _init(vel_y: float = 0.0, on_floor: bool = false, jump: bool = false, jumps: int = 0):
	velocity_y = vel_y
	is_on_floor = on_floor
	jump_pressed = jump
	jump_count = jumps
	jump_requested = false
