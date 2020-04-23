extends Node2D

func _ready():
	$start_button.visible = false
	utils_custom.create_timer_2(1, self, "enable_start_button")
	pass
	# get_tree().change_scene("res://lose-sick.tscn")
	# get_tree().change_scene("res://level_select.tscn")
	
	# LEVEL SELECT 2
	# global.level_type = "groceries"
	# global.level_type = "sport"
	# get_tree().change_scene("res://level_select_part_2.tscn")
	# global.language = "english"
	global.language = "french"
	# global.set_level_settings("groceries", "daily_bread")
	# global.set_level_settings("groceries", "doliprane")
	# global.set_level_settings("groceries", "toilet_paper")
	# global.set_level_settings("groceries", "night_pharma")
	# global.set_level_settings("groceries", "hidden_pasta")
	# global.set_level_settings("groceries", "full_cart_1")
	# global.set_level_settings("groceries", "full_cart_3")
	# global.set_level_settings("groceries", "test")

	global.set_level_settings("sport", "near_home")
	# global.set_level_settings("sport", "marathon_21k")
	# global.set_level_settings("sport", "marathon_42k")
	# global.set_level_settings("sport", "marathon_21k")
	# global.set_level_settings("sport", "jogging_2")
	# global.set_level_settings("sport", "canal_1")
	# global.set_level_settings("sport", "canal_2")
	# global.set_level_settings("sport", "test")
	# global.set_level_settings("sport", "night_bike")

	# get_tree().change_scene("res://level_bastille.tscn")
	get_tree().change_scene("res://level_intro.tscn")
	#$;	HTTPRequest.request("http://localhost:8082/TEST_settingss.json")
	
func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8()).result
	global.game_settings = json
	
	global.set_level_settings("groceries_easy", "groceries")
	get_tree().change_scene("res://level_bastille.tscn")


func next_scene():
	get_tree().change_scene("res://level_select.tscn")

func _on_start_button_button_down():
	$audio/pop.play()
	utils_custom.create_timer_2(0.2, self, "next_scene")

func enable_start_button():

	$start_button.visible = true
