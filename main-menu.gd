extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	utils_custom.create_timer_2(0.5, self, "go_to_next_scene")#
	
	
func go_to_next_scene():
	get_tree().change_scene("res://level_bastille.tscn")
