extends Node2D

func _ready():
	if global.level_type == "groceries":
		show_groceries_levels()
	if global.level_type == "sport":
		show_sport_levels()
	
	
func _on_back_button_down():
	get_tree().change_scene("res://level_select.tscn")


func _on_help_button_down():
	get_tree().change_scene("res://level_intro.tscn")

func _on_level_1_button_down():
	get_tree().change_scene("res://level_intro.tscn")

func show_groceries_levels():
		$groceries.show()
		$sport.hide()

func show_sport_levels():
	$groceries.hide()
	$sport.show()
	