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
var running = false
var running_recovering = false
var should_play_bump = true

onready var game_settings = get_tree().get_root().get_node("game").game_settings
onready var STAMINA_MAX_AMOUNT =  game_settings["player"]["stamina_max_amount"]

var STAMINA_RECOVER_SPEED = 0.5
var STAMINA_DEPLETION_SPEED = 2
var STAMINA_RECOVERY_TIME = 2
var stamina 

onready var star_music = get_tree().get_root().get_node("game/audio/star_music")
onready var main_music = get_tree().get_root().get_node("game/audio/main_music")
onready var sound_attestation = get_tree().get_root().get_node("game/audio/pickup_attestation")
onready var sound_bumps = get_tree().get_root().get_node("game/audio/bumps")


func _ready():
	set_process(true)
	var circle_tween = Tween.new()
	add_child(circle_tween)

	stamina = STAMINA_MAX_AMOUNT

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
		
		if running == false and running_recovering == false:
			stamina += abs(_delta * STAMINA_RECOVER_SPEED)
			stamina = min(stamina, STAMINA_MAX_AMOUNT)

		if Input.is_action_just_released("run"):
			running = false

		if Input.is_action_just_pressed("run") and running == false and running_recovering == false:
			running = true
		elif Input.is_action_pressed("run") and running == true:
			#if motion.x != 0 or motion.y != 0:
				motion = motion.normalized() * RUN_MOTION_SPEED
				$main_char_node/main_character/AnimationPlayer.playback_speed = 4
				stamina -= abs(_delta * STAMINA_DEPLETION_SPEED)
				if stamina < 0:
					stop_running()
		elif Input.is_action_pressed("run_fast"):
			motion = motion.normalized() * RUN_MOTION_SPEED_FAST
			$main_char_node/main_character/AnimationPlayer.playback_speed = 8
		else:
			$main_char_node/main_character/AnimationPlayer.playback_speed = 2
			motion = motion.normalized() * MOTION_SPEED

		if motion.x == 0 and motion.y == 0:
			$main_char_node/main_character/AnimationPlayer.playback_speed = 0
			running = false

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
		if should_play_bump:
			if get_slide_count() != 0 :
				for i in range (0,get_slide_count()) :
					if get_slide_collision(i).collider.get_name() == "Enemy":
						if should_play_bump:
							sound_bumps.get_child(randi()%sound_bumps.get_child_count()).play()
							utils_custom.create_timer_2(1,self,"set_should_play_bump")
							should_play_bump = false

func set_should_play_bump():
	should_play_bump = true

func stop_running():
	running = false 
	running_recovering = true
	utils_custom.create_timer_2(STAMINA_RECOVERY_TIME, self, "can_run_again")
		
func can_run_again():
	running_recovering = false
	stamina = 0.01

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
	sound_attestation.play()
	if has_attestation == false:
		utils_custom.create_timer_2(1, self, "decrement_attestation_timer")

	has_attestation = true
	has_attestation_time = game_settings["police"]["attestation_length"]
	
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








