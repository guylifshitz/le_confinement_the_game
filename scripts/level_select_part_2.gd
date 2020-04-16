extends Node2D


func _ready():
	
	if global.level_type == "groceries":
		for level in global.game_settings["groceries"]:
			var level_name = global.game_settings["groceries"][level]["level_name"]
			var level_difficulty = global.game_settings["groceries"][level]["level_difficulty"]
			get_node("groceries/level_"+level+"/title").bbcode_text = "[center]"+level_name[global.language]
			for i in range(1, level_difficulty+1):
				get_node("groceries/level_"+level+"/difficulty/stars/"+str(i)).modulate = Color(1,1,1)

		show_groceries_levels()
		
	if global.level_type == "sport":
		show_sport_levels()


func _on_back_button_down():
	get_tree().change_scene("res://level_select.tscn")


func _on_help_button_down():
	get_tree().change_scene("res://level_intro.tscn")


func level_clicked(level_number):
	set_level(int(level_number))
	get_tree().change_scene("res://level_intro.tscn")

func show_groceries_levels():
	$groceries.show()
	$sport.hide()


func show_sport_levels():
	$groceries.hide()
	$sport.show()


func set_level(level_number):
	global.set_level_settings(global.level_type, level_number)

