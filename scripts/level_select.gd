extends Node2D

var language

func _ready():
	set_language()
	show_right_difficulty()
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
	# play sound
	$form/option_groceries/checkbox_checked.show()
	$form/signature.show()
	$buttons/sport.disabled = true
	global.set_level_settings("groceries_" + global.level_difficulty, "groceries")
	utils_custom.create_timer_2(1, self, "play_groceries")


func _on_sport_button_down():
	$audio/pop.play()
	# play sound
	$form/option_sport/checkbox_checked.show()
	$form/signature.show()
	$buttons/groceries.disabled = true
	utils_custom.create_timer_2(1, self, "play_sport")
	global.set_level_settings("sport_" + global.level_difficulty, "sport")


func show_right_difficulty():
	$difficulty/easy.hide()
	$difficulty/medium.hide()
	$difficulty/hard.hide()
	if global.level_difficulty == "easy":
		$difficulty/easy.show()
	elif global.level_difficulty == "medium":
		$difficulty/medium.show()
	else:
		$difficulty/hard.show()


func _on_difficulty_button_down():
	$audio/pop.play()
	if global.level_difficulty == "easy":
		global.level_difficulty = "medium"
	elif global.level_difficulty == "medium":
		global.level_difficulty = "hard"
		# global.level_difficulty = "easy"
	else:
		global.level_difficulty = "easy"
	show_right_difficulty()

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
