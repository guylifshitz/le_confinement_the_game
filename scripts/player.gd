extends KinematicBody2D

const MOTION_SPEED = 300 # Pixels/second.
#const RUN_MOTION_SPEED = 600 # Pixels/second.
const RUN_MOTION_SPEED = 600 # Pixels/second.
const RUN_MOTION_SPEED_FAST = 1200 # Pixels/second.
#const MOTION_SPEED = 600

var nearest_enemy_glob

var path = PoolVector2Array() setget set_path

var items_needed = []
var items_holding = []
var has_attestation = false

func _ready():
	set_process(true)
	var circle_tween = Tween.new()
	add_child(circle_tween)
	
	circle_tween.interpolate_property($main_char_node/circle, "rotation_degrees", 0,360,6,circle_tween.TRANS_LINEAR, circle_tween.EASE_IN_OUT)
	circle_tween.set_repeat(true)
	circle_tween.start()
	remove_groceries()
	remove_drugs()

func toggle_groceries():
	var groceries = self.find_node("groceries")
	if groceries.is_visible_in_tree():
		groceries.hide()
	else:
		groceries.show()
	
func add_groceries():
	var groceries = self.find_node("groceries")
	groceries.show()
	
func remove_groceries():
	var groceries = self.find_node("groceries")
	groceries.hide()
	
func toggle_drugs():
	var drugs = self.find_node("drugs")
	if drugs.is_visible_in_tree():
		drugs.hide()
	else:
		drugs.show()
	
func add_drugs():
	var drugs = self.find_node("drugs")
	drugs.show()
	
func remove_drugs():
	var drugs = self.find_node("drugs")
	drugs.hide()
	
func _physics_process(_delta):
	get_closest()
	
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y *= 0.5
	
	if Input.is_action_pressed("run"):
		motion = motion.normalized() * RUN_MOTION_SPEED
		$main_char_node/main_character/AnimationPlayer.playback_speed = 4
	elif Input.is_action_pressed("run_fast"):
		motion = motion.normalized() * RUN_MOTION_SPEED_FAST
		$main_char_node/main_character/AnimationPlayer.playback_speed = 8
	else:
		motion = motion.normalized() * MOTION_SPEED
		$main_char_node/main_character/AnimationPlayer.playback_speed = 2

	if Input.is_action_pressed("move_left"):
		$main_char_node/main_character/AnimationPlayer.play("left")
	elif Input.is_action_pressed("move_right"):
		$main_char_node/main_character/AnimationPlayer.play("right")
	elif Input.is_action_pressed("move_up"):
		$main_char_node/main_character/AnimationPlayer.play("up")
	elif Input.is_action_pressed("move_down"):
		$main_char_node/main_character/AnimationPlayer.play("down")
	else:
		$main_char_node/main_character/AnimationPlayer.play("idle")
	#warning-ignore:return_value_discarded
	move_and_slide(motion)
	
	# TEST PATH HERE
	var move_distance = MOTION_SPEED * _delta
	move_along_path(move_distance)
	
func get_closest():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		var nearest_enemy = enemies[0]
	#
		for enemy in enemies:
			if enemy.global_position.distance_to(self.global_position) < nearest_enemy.global_position.distance_to(self.global_position):
				nearest_enemy = enemy
		
		nearest_enemy_glob = nearest_enemy;

func move_along_path(distance):
	if path.size() > 0:
		global_position = path[-1]
#	var start_point = global_position
#	for i in range(path.size()):
#		var distance_to_next = start_point.distance_to(path[0])
#		if distance <= distance_to_next and distance >= 0.0:
#			global_position = start_point.linear_interpolate(path[0], distance/distance_to_next)
#			break
#		elif distance < 0.0:
#			global_position = path[0]
#			set_process(false)
#			break
#		distance -= distance_to_next
#		start_point = path[0]
#		path.remove(0)

func set_path(value):
	path = value
	if value.size() == 0:
		return
	set_process(true)


func acquired_attestation():
	var root = get_tree().get_root()
	var attestation_slot = get_node("/root/game/interface/attestation_slot")
	var attestation_slot_full = get_node("/root/game/interface/attestation_slot_full")
	attestation_slot.visible = false
	attestation_slot_full.visible = true
	has_attestation = true
