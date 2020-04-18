extends Node2D

var waypoint_positions
var waypoint_number = -1
onready var game = get_tree().get_root().get_node("game")

onready var sound_waypoint = get_tree().get_root().get_node(
	"game/audio/pickup_health"
)


func _ready():
	if global.level_type == "sport":
		waypoint_positions = get_parent().get_node("waypoint_positions/"+global.level_settings["waypoint_positions"])
		increment_waypoint()
	else:
		queue_free()

func _on_waypoint_body_entered(body):
	if body.name == "player":
		increment_waypoint()
		
func increment_waypoint():
	waypoint_number += 1
	sound_waypoint.play()

	if waypoint_number >= waypoint_positions.get_children().size():
		game.win_game()
		set_process(false)
	else:
		self.position = waypoint_positions.get_child(waypoint_number).position
		get_node("counter").bbcode_text = "[center]"+str(waypoint_number+1)
	

