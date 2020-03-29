extends Node2D

func play_groceries():
	get_tree().change_scene("res://groceries_intro.tscn")

func play_sport():
	get_tree().change_scene("res://groceries_intro.tscn")


func _on_groceries_button_down():
	# play sound
	$form/option_groceriess/checkbox_checked.show()
	$form/signature.show()
	$buttons/sport.disabled = true
	utils_custom.create_timer_2(1, self, "play_groceries")


func _on_sport_button_down():
	# play sound
	$form/option_sport/checkbox_checked.show()
	$form/signature.show()
	$buttons/groceries.disabled = true
	utils_custom.create_timer_2(1, self, "play_sport")
