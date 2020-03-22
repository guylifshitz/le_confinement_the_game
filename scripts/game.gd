extends Node2D

onready var nav_2d = $Navigation2D
#onready var line_2d : Line2D = 
onready var character = $Walls/main_characterKinematic


#func _unhandled_input(event):
#	if not event is InputEventMouseButton:
#		return 
#	if event.button_index != BUTTON_LEFT or not event.pressed:
#		return 
#
#	var end_pos = event.global_position
#	end_pos = end_pos - Vector2(100,233)
#	var new_path = nav_2d.get_simple_path(character.global_position, end_pos)
#	print("NEW PATH: ", new_path)
#	character.path = new_path
#
#	print("CLICK", event.global_position)
#	print("CLICK char", character.global_position)
#
#func _ready():
##	nav_2d.get_simple_path(character.global_position, Vector(0,0))
#	pass
#
