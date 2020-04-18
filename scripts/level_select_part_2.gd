extends Node2D


func _ready():
	# for level in global.game_settings[global.level_type]:
	for level in get_node(global.level_type).get_children():
		
		if level.visible == false:
			continue 
			
		var level_type = global.level_type
		var level_id = level.name
		var level_settings = utils_custom.load_json("res://jsons/level_settings/{ltype}/{id}.json".format({"ltype":level_type, "id":level_id}))
		var level_difficulty = level_settings["level_difficulty"]
		get_node(global.level_type + "/" +level_id + "/title").bbcode_text = (
			"[center]"
			+ level_settings["level_name"][global.language]
		)
		for i in range(1, level_difficulty + 1):
			get_node(global.level_type + "/" + level_id + "/difficulty/stars/" + str(i)).modulate = Color(
				1, 1, 1
			)

	if global.level_type == "groceries":
		show_groceries_levels()

	if global.level_type == "sport":
		show_sport_levels()


func _on_back_button_down():
	get_tree().change_scene("res://level_select.tscn")


func _on_help_button_down():
	get_tree().change_scene("res://level_intro.tscn")


func level_clicked(level_id):
	set_level(level_id)
	get_tree().change_scene("res://level_intro.tscn")


func show_groceries_levels():
	$groceries.show()
	$sport.hide()


func show_sport_levels():
	$groceries.hide()
	$sport.show()


func set_level(level_id):
	global.set_level_settings(global.level_type, level_id)
