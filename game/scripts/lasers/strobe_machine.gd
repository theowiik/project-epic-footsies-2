class_name StrobeMachine
extends Node3D

var on: bool = false

@onready var light: SpotLight3D = $SpotLight3D

var strobe_speed: float = 10.0


func _process(delta: float) -> void:
	if not on:
		return

	var time = Time.get_ticks_msec() / 1000.0
	light.visible = sin(time * strobe_speed * TAU) > 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_J:
			on = !on
