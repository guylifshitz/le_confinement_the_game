extends Node2D

func _ready():
	utils_custom.create_timer_2(5, self, "restart_game")

func restart_game():
	get_tree().change_scene("res://level_bastille.tscn")
