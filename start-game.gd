extends Area2D

func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		go_to_next_scene()

func go_to_next_scene():
	get_tree().change_scene("res://level_bastille.tscn")

func _on_Button_button_down():
	go_to_next_scene()
