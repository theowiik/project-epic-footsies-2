extends Control

@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	for bulb in get_tree().get_nodes_in_group(Constants.BULBS_GROUP):
		bulb.bulb_hit.connect(recalculate_scores)
	get_tree().node_added.connect(_on_node_added)
	recalculate_scores()


func _on_node_added(node: Node) -> void:
	if node.is_in_group(Constants.BULBS_GROUP):
		node.bulb_hit.connect(recalculate_scores)
		recalculate_scores()


func recalculate_scores(_color: Color = Color.WHITE) -> void:
	var counts: Dictionary = {}

	for bulb in get_tree().get_nodes_in_group(Constants.BULBS_GROUP):
		var color: Color = bulb.get_color()
		counts[color] = counts.get(color, 0) + 1

	var texts: Array[String] = []
	for color in counts.keys():
		texts.append("%s: %d" % [color.to_html(false), counts[color]])

	score_label.text = " | ".join(texts)
