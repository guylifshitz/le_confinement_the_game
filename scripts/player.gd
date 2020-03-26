extends KinematicBody2D

const MOTION_SPEED = 300 # Pixels/second.
#const RUN_MOTION_SPEED = 600 # Pixels/second.
const RUN_MOTION_SPEED = 600 # Pixels/second.
const RUN_MOTION_SPEED_FAST = 1200 # Pixels/second.
#const MOTION_SPEED = 600

var nearest_enemy_glob

var items_needed = []
var items_bonus = []
var items_holding = []
var items_holding_bonus = []
var has_attestation = false
var has_attestation_time

var can_move = true

onready var star_music = get_tree().get_root().get_node("game/audio/star_music")
onready var main_music = get_tree().get_root().get_node("game/audio/main_music")


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
	
	if can_move:
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
		move_and_slide(motion)
		
	
func get_closest():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		var nearest_enemy = enemies[0]
	#
		for enemy in enemies:
			if enemy.global_position.distance_to(self.global_position) < nearest_enemy.global_position.distance_to(self.global_position):
				nearest_enemy = enemy
		
		nearest_enemy_glob = nearest_enemy;


func acquired_attestation():

	if has_attestation == false:
		utils_custom.create_timer_2(1, self, "decrement_attestation_timer")

	has_attestation = true
	has_attestation_time = 2
	
	var attestation_timer = get_node("/root/game/interface/attestation_timer")
	
	attestation_timer.get_node("timer_label").text = str(has_attestation_time)
	attestation_timer.show()

	var attestation_slot = get_node("/root/game/interface/attestation_slot")
	var attestation_slot_full = get_node("/root/game/interface/attestation_slot_full")
	attestation_slot.hide()
	attestation_slot_full.show()

	

func decrement_attestation_timer():
	var attestation_timer_label = get_node("/root/game/interface/attestation_timer/timer_label")
	has_attestation_time = has_attestation_time - 1
	attestation_timer_label.text = str(has_attestation_time)
	
	if has_attestation_time < 0:
		has_attestation = false
		var attestation_slot = get_node("/root/game/interface/attestation_slot")
		var attestation_slot_full = get_node("/root/game/interface/attestation_slot_full")
		var attestation_timer = get_node("/root/game/interface/attestation_timer")

		attestation_slot.show()
		attestation_slot_full.hide()
		attestation_timer.hide()

		has_attestation_time = 5
		
		main_music.stream_paused = false
		star_music.stream_paused = true
				
	else:
		utils_custom.create_timer_2(1, self, "decrement_attestation_timer")








