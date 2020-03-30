extends Node2D

func _ready():
	$dialog/bonus_score/text.bbcode_text = str(int(global.score))

	for bonus_item in global.bonus_items_recovered:
		$dialog/bonus_items.get_node(bonus_item).show()
	if global.bonus_items_recovered.size() == 0:
		$dialog/bonus_items/none.show()

func next_scene():
	get_tree().change_scene("res://level_select.tscn")
