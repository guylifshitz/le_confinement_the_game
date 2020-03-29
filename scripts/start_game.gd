extends Button

func _on_Button_button_down():
	go_to_next_scene()

func go_to_next_scene():
	get_tree().change_scene("res://level_bastille.tscn")
