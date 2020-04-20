extends Node2D

var language

func _ready():
	set_language()
	if not music.get_node("main_menu").playing:
		music.get_node("main_menu").play()

func play_groceries():
	get_tree().change_scene("res://level_select_part_2.tscn")
	#get_tree().change_scene("res://level_intro.tscn")

func play_sport():
	get_tree().change_scene("res://level_select_part_2.tscn")
	#get_tree().change_scene("res://level_intro.tscn")
	# get_tree().change_scene("res://level_bastille.tscn")

func _on_groceries_button_down():
	$audio/pop.play()
	$form/option_groceries/checkbox_checked.show()
	$form/signature.show()
	$buttons/sport.disabled = true
	global.level_type = "groceries"
	utils_custom.create_timer_2(1, self, "play_groceries")


func _on_sport_button_down():
	$audio/pop.play()
	# play sound
	$form/option_sport/checkbox_checked.show()
	$form/signature.show()
	$buttons/groceries.disabled = true
	global.level_type = "sport"
	utils_custom.create_timer_2(1, self, "play_sport")


func _on_language_button_down():
	$audio/pop.play()

	if global.language == "english":
		global.language = "french"
	else:
		global.language = "english"
	set_language()


func set_language():
	if global.language == "french":
		$form/french.show()
		$form/english.hide()
		$language/french.show()
		$language/english.hide()
	else:
		$form/french.hide()
		$form/english.show()
		$language/french.hide()
		$language/english.show()
