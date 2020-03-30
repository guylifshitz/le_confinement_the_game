extends Node2D


func next_scene():
	# get_tree().change_scene("res://level_select.tscn")
	global.level_type = "groceries"
	get_tree().change_scene("res://level_bastille.tscn")

func _on_start_button_button_down():
	next_scene()
