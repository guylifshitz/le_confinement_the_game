extends Node2D

func _ready():
	pass
	# get_tree().change_scene("res://lose-sick.tscn")
	# get_tree().change_scene("res://level_select.tscn")
	# get_tree().change_scene("res://lose-police.tscn")
	# get_tree().change_scene("res://win-screen.tscn")

	# global.set_level_settings("sport_easy", "sport")
	# global.set_level_settings("groceries_easy", "groceries")

	# get_tree().change_scene("res://level_bastille.tscn")
	#$HTTPRequest.request("http://localhost:8082/TEST_settingss.json")
	
func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8()).result
	global.game_settings = json
	
	global.set_level_settings("groceries_easy", "groceries")
	get_tree().change_scene("res://level_bastille.tscn")


func next_scene():
	get_tree().change_scene("res://level_select.tscn")

func _on_start_button_button_down():
	next_scene()


