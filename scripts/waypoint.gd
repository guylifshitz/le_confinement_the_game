extends Node2D

var waypoint_positions
var waypoint_number = -1
var cumulative_distance = 0
var course_length
var course_length_scale

onready var game = get_tree().get_root().get_node("game")

onready var sound_waypoint = get_tree().get_root().get_node("game/audio/pickup_health")


func _ready():
	if global.level_type == "sport":
		waypoint_positions = get_parent().get_node(
			"waypoint_positions/" + global.level_settings["waypoint_positions"]
		)
		setup_loops()
		increment_waypoint()
		increment_waypoint()
		if "course_length_in_km" in global.level_settings:
			get_length_of_course()
	else:
		queue_free()


func _on_waypoint_body_entered(body):
	if body.name == "player":
		increment_waypoint()


func setup_loops():
	if not "waypoint_loops" in  global.level_settings:
		return 
	var loop_count = global.level_settings["waypoint_loops"]["loop_count"]
	var last_waypoint = waypoint_positions.get_children()[-1]
	var last_waypoint_copy = last_waypoint.duplicate(true)
	last_waypoint.queue_free()

	var waypoint_positions_original_count = waypoint_positions.get_children().size()
	for i in range(0, loop_count):
		for child_idx in range(1, waypoint_positions_original_count):
			var waypoint = waypoint_positions.get_child(child_idx)
			waypoint_positions.add_child(waypoint.duplicate())
	waypoint_positions.add_child(last_waypoint_copy)


func get_length_of_course():
	course_length = 0
	for child_idx in range(1, waypoint_positions.get_children().size()):
		course_length += waypoint_positions.get_child(child_idx).global_position.distance_to(
			waypoint_positions.get_child(child_idx - 1).global_position
		)
	var course_length_in_km = float(global.level_settings["course_length_in_km"])
	course_length_scale = course_length_in_km / course_length


func increment_waypoint():
	waypoint_number += 1
	sound_waypoint.play()

	if waypoint_number > 1:
		if "course_length_in_km" in global.level_settings:
			compute_distance()

	if waypoint_number >= waypoint_positions.get_children().size():
		game.win_game()
		set_process(false)
	else:
		self.position = waypoint_positions.get_child(waypoint_number).position
		get_node("counter").bbcode_text = "[center]" + str(waypoint_number)


func compute_distance():
	cumulative_distance += waypoint_positions.get_child(waypoint_number - 1).global_position.distance_to(
		waypoint_positions.get_child(waypoint_number - 2).global_position
	)
	var cumulative_distance_km = str("%.1f" % (cumulative_distance * course_length_scale))
	game.get_node("interface/sports_distance").bbcode_text = (
		"[center]"
		+ cumulative_distance_km
		+ "KM"
	)
