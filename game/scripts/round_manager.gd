class_name RoundManager
extends Node3D

signal round_finished(winner: Color)
signal time_updated(time_remaining: float)

var time_remaining: float = 0.0
var is_active: bool = false


func _process(delta: float) -> void:
	if not is_active:
		return

	time_remaining -= delta
	time_updated.emit(time_remaining)

	if time_remaining <= 0:
		time_remaining = 0
		is_active = false
		round_finished.emit(Color.BLACK)


func start() -> void:
	time_remaining = Constants.ROUND_DURATION
	is_active = true
