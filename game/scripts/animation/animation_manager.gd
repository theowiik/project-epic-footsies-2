class_name AnimationManager
extends RefCounted

enum State { GROUNDED, INITIATE_JUMP, JUMP_UP, JUMP_DOWN, LANDING }

var animation_player: AnimationPlayer
var current_state: State = State.GROUNDED
var was_on_floor: bool = true


func _init(anim_player: AnimationPlayer):
	animation_player = anim_player


func update(velocity_y: float, is_on_floor: bool) -> void:
	var new_state = _determine_state(velocity_y, is_on_floor)

	if new_state != current_state:
		_transition_to(new_state)

	was_on_floor = is_on_floor


func _determine_state(velocity_y: float, is_on_floor: bool) -> State:
	if is_on_floor:
		if current_state == State.JUMP_DOWN:
			return State.LANDING
		if current_state == State.LANDING and animation_player.is_playing():
			return State.LANDING
		return State.GROUNDED

	if current_state == State.GROUNDED and velocity_y > 0:
		return State.INITIATE_JUMP

	if current_state == State.INITIATE_JUMP:
		if animation_player.is_playing():
			return State.INITIATE_JUMP
		return State.JUMP_UP

	if velocity_y > 0:
		return State.JUMP_UP

	return State.JUMP_DOWN


func _transition_to(new_state: State) -> void:
	current_state = new_state

	match new_state:
		State.GROUNDED:
			animation_player.play("walk")
		State.INITIATE_JUMP:
			animation_player.play("initate_jump")
		State.JUMP_UP:
			animation_player.play("jump_up")
		State.JUMP_DOWN:
			animation_player.play("jump_down")
		State.LANDING:
			animation_player.play("jump_land")
