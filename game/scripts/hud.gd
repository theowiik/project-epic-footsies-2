extends Control

@onready var score_label: Label = $ScoreLabel


func _process(delta: float) -> void:
	var all_bulbs: Array[Node] = get_tree().get_nodes_in_group(Constants.BULBS_GROUP)
	var hit_bulbs: int = 0
	var total_bulbs: int = all_bulbs.size()

	for bulb in all_bulbs:
		if bulb.state == "hit":
			hit_bulbs += 1

	score_label.text = "Score: " + str(hit_bulbs) + "/" + str(total_bulbs)
