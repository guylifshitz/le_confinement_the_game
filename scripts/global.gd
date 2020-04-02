extends Node

var items_recovered = []
var bonus_items_recovered = []
var score = -1
var play_audio = "all"
var sports_timer

var level_type
var level_difficulty = "easy"
var language = "french"

var game_settings = {}
var level_settings

func _ready():
	load_local_game_settings()

func load_local_game_settings():
	game_settings = utils_custom.load_json("res://jsons/game_settings.json")

func set_level_settings(level_name, level_type_param):
	level_settings = game_settings[level_name]
	level_type = level_type_param
