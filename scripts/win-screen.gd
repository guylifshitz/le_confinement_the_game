extends Node2D

func _ready():
	$dialog/bonus_score/text.bbcode_text = str(int(global.score))

	if global.level_type == "groceries":
		$dialog/sports_text.hide()
		$dialog/sports_time.hide()
		$dialog/groceries_items.show()
		$dialog/groceries_text.show()

		if global.language == "english":
			$dialog/groceries_text/english.show()
			$dialog/groceries_text/french.hide()
		else:
			$dialog/groceries_text/english.hide()
			$dialog/groceries_text/french.show()

		for bonus_item in global.bonus_items_recovered:
			$dialog/bonus_items.get_node(bonus_item).show()
		if global.bonus_items_recovered.size() == 0:
			$dialog/bonus_items/none.show()
	else:
		$dialog/groceries_items.hide()
		$dialog/groceries_text.hide()
		$dialog/sports_time.show()
		$dialog/sports_text.show()
		if global.language == "english":
			$dialog/sports_text/english.show()
			$dialog/sports_text/french.hide()
		else:
			$dialog/sports_text/english.hide()
			$dialog/sports_text/french.show()

		$dialog/sports_time.text = global.sports_timer

func next_scene():
	get_tree().change_scene("res://level_select.tscn")
