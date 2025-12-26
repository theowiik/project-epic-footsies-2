class_name Round
extends RefCounted

signal round_finished(winner: Color)
signal time_updated(time_remaining: float)

var time_remaining: float = 0.0
var scores: Dictionary = {}
var is_active: bool = false

func register_team(team_color: Color) -> void:
	if team_color not in scores:
		scores[team_color] = 0

func start() -> void:
	time_remaining = Constants.ROUND_DURATION
	is_active = true

func update(delta: float) -> void:
	if not is_active:
		return
	
	time_remaining -= delta
	time_updated.emit(time_remaining)
	
	if time_remaining <= 0:
		time_remaining = 0
		end_round()

func end_round(winner: Color = Color.BLACK) -> void:
	is_active = false
	if winner != Color.BLACK and winner in scores:
		scores[winner] += 1
	round_finished.emit(winner)

func add_score(team_color: Color, points: int = 1) -> void:
	if team_color in scores:
		scores[team_color] += points

func get_score(team_color: Color) -> int:
	return scores.get(team_color, 0)

func reset_scores() -> void:
	for team_color in scores:
		scores[team_color] = 0
