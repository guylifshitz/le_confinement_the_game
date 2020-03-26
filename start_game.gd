extends Button


func _on_Button_button_down():
	get_tree().get_root().get_node("menu").update_text()
	#go_to_next_scene()

func go_to_next_scene():
	get_tree().change_scene("res://level_bastille.tscn")
	
