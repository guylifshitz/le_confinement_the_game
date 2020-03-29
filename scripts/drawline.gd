extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	update()
	
func _draw():
	var main_char = self.get_parent().find_node("player")
	if main_char.nearest_enemy:
		draw_line(main_char.global_position, main_char.nearest_enemy.global_position, Color(255, 0, 0), 1)
