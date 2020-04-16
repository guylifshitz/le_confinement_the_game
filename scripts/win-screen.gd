extends Node2D

func _ready():
	$dialog/bonus_score/text.bbcode_text = str(int(global.score))

	if global.level_type == "groceries":
		$dialog/sports_text.hide()
		$dialog/sports_time.hide()
		$dialog/groceries_items.show()
		$dialog/groceries_text.show()
		setup_groceries()
		setup_bonus()

		if global.language == "english":
			$dialog/groceries_text/english.show()
			$dialog/groceries_text/french.hide()
		else:
			$dialog/groceries_text/english.hide()
			$dialog/groceries_text/french.show()
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

func setup_groceries():

	var found_items_holder  = get_node("groceries_items/")
	for item_index in range(global.items_recovered.size()):
		var item = global.items_recovered[item_index]
		var holding_slot = found_items_holder.get_child(item_index)
		var item_to_hold = load("res://prefab/holding_" + item + ".tscn")
		holding_slot.add_child(item_to_hold.instance())



func setup_bonus():
	var found_items_holder  = get_node("bonus_items/")
	for item_index in range(global.bonus_items_recovered.size()):
		var item = global.bonus_items_recovered[item_index]
		var holding_slot = found_items_holder.get_child(item_index)
		var item_to_hold = load("res://prefab/holding_" + item + ".tscn")
		holding_slot.add_child(item_to_hold.instance())
	
	if global.bonus_items_recovered.size() == 0:
		$bonus_items/none.show()
	else:
		$bonus_items/none.hide()



func next_scene():
	get_tree().change_scene("res://level_select.tscn")

