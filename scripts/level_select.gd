extends Node2D

var level_difficulty
var language

func _ready():
	set_language()
	_on_difficulty_button_down()
	if not music.get_node("main_menu").playing:
		music.get_node("main_menu").play()

func play_groceries():
	get_tree().change_scene("res://level_intro.tscn")

func play_sport():
	get_tree().change_scene("res://level_intro.tscn")
	# get_tree().change_scene("res://level_bastille.tscn")

func _on_groceries_button_down():
	# play sound
	$form/option_groceries/checkbox_checked.show()
	$form/signature.show()
	$buttons/sport.disabled = true
	global.set_level_settings("groceries_" + level_difficulty, "groceries")
	utils_custom.create_timer_2(1, self, "play_groceries")


func _on_sport_button_down():
	# play sound
	$form/option_sport/checkbox_checked.show()
	$form/signature.show()
	$buttons/groceries.disabled = true
	utils_custom.create_timer_2(1, self, "play_sport")
	global.set_level_settings("sport_" + level_difficulty, "sport")


func _on_difficulty_button_down():
	$difficulty/easy.hide()
	$difficulty/medium.hide()
	$difficulty/hard.hide()
	if level_difficulty == "easy":
		$difficulty/medium.show()
		level_difficulty = "medium"
	elif level_difficulty == "medium":
		$difficulty/hard.show()
		level_difficulty = "hard"
	else:
		$difficulty/easy.show()
		level_difficulty = "easy"


func _on_language_button_down():
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
