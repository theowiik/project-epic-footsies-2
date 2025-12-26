class_name Main
extends Node3D

@onready var hud: Control = $HUD
@onready var round_manager: RoundManager = $RoundManager


func _ready() -> void:
	round_manager.time_updated.connect(hud.update_time)
	round_manager.round_finished.connect(on_round_finished)
	round_manager.start()


func on_round_finished(winner: Color) -> void:
	print("Round finished! Winner: ", winner)
