class_name Main
extends Node3D

var round: Round

@onready var hud: Control = $HUD

func _ready() -> void:
	round = Round.new()
	round.time_updated.connect(hud.update_time)
	round.start()

func _process(delta: float) -> void:
	round.update(delta)
