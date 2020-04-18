extends Node

var items_recovered = []
var bonus_items_recovered = []
var score = -1
var play_audio = "all"
var sports_timer

var level_type
var level_id = 1

var level_difficulty = "easy"
var language = "french"

var game_settings = {}
var level_settings


func _ready():
	load_local_game_settings()


func load_local_game_settings():
	game_settings = utils_custom.load_json("res://jsons/game_settings.json")


func load_level_settings_json(level_type, level_id):
	level_settings = utils_custom.load_json(
		"res://jsons/level_settings/{l_type}/{l_id}.json".format(
			{"l_type": level_type, "l_id": level_id}
		)
	)


func set_level_settings(level_type_param, level_id_param):
	#level_type = level_type_param
	# levelid = str(levelid).pad_zeros(2)
	# level_settings = game_settings[level_type_param][levelid]
	level_id = level_id_param
	load_level_settings_json(level_type_param, level_id)
