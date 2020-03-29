extends Node2D

var continue_button_enabled = false

func _ready():
	utils_custom.create_timer_2(2, self, "enable_continue_button")

func restart_game():
	get_tree().change_scene("res://level_bastille.tscn")

func enable_continue_button():
	$continue_button.modulate = Color(1,1,1)
	continue_button_enabled = true
	
func _on_continue_button_down():
	if continue_button_enabled:
		restart_game()
