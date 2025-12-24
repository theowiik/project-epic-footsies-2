class_name DoubleJumpModifier
extends MovementModifier

var max_jumps: int = 2


func _init(max_jump_count: int = 2):
	max_jumps = max_jump_count


func modify(context: MovementContext) -> void:
	if (
		context.jump_pressed
		and not context.is_on_floor
		and context.jump_count > 0
		and context.jump_count < max_jumps
	):
		context.jump_requested = true
