extends Node2D

onready var waypoint_positions = get_parent().get_node("waypoint_positions")
var waypoint_number = -1

func _ready():
	if global.level_type == "sport":
		increment_waypoint()
	else:
		self.hide()

func _on_waypoint_body_entered(body):
	if body.name == "player":
		increment_waypoint()
		
func increment_waypoint():
	waypoint_number += 1

	if waypoint_number >= waypoint_positions.get_children().size():
		get_tree().change_scene("res://win-screen.tscn")
		set_process(false)
	else:
		self.position = waypoint_positions.get_child(waypoint_number).position
		get_node("counter").bbcode_text = "[center]"+str(waypoint_number+1)
	
