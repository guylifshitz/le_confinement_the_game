extends KinematicBody2D

var player_settings = global.game_settings["player"]

var MOTION_SPEED = global.level_settings["player"]["walk_speed"]
var RUN_MOTION_SPEED = global.level_settings["player"]["run_speed"]
var RUN_MOTION_SPEED_FAST = player_settings["debug_run_speed"]
var WALK_PLAYBACK_SPEED = 2
var RUN_PLAYBACK_SPEED = 4

var can_move = true
var running = false
var running_recovering = false

var nearest_enemy

var items_needed = []
var items_bonus = []
var items_holding = []
var items_holding_bonus = []
var has_attestation = false
var has_attestation_time

var should_play_bump_sound = true

var STAMINA_MAX_AMOUNT = player_settings["stamina_max_amount"]

var STAMINA_RECOVER_SPEED = 0.5
var STAMINA_DEPLETION_SPEED = global.level_settings["player"]["stamina_drain_speed"]
var STAMINA_RECOVERY_TIME = 2
var stamina = STAMINA_MAX_AMOUNT

onready var sound_lost = get_tree().get_root().get_node("game/audio/lost")
onready var star_music = get_tree().get_root().get_node("game/audio/star_music")
onready var main_music = get_tree().get_root().get_node("game/audio/main_music")
onready var sound_acquired_attestation = get_tree().get_root().get_node(
	"game/audio/pickup_attestation"
)
onready var sound_acquired_hand_sanitizer = get_tree().get_root().get_node(
	"game/audio/pickup_health"
)
onready var sound_acquired_key = get_tree().get_root().get_node("game/audio/pickup_key")
onready var sound_acquired_key_door = get_tree().get_root().get_node("game/audio/door_open")
onready var sound_bumps = get_tree().get_root().get_node("game/audio/bumps")

var motion = Vector2(0, 0)
var mouse_pressed = false


func _ready():
	if global.level_type == "sport":
		WALK_PLAYBACK_SPEED = RUN_PLAYBACK_SPEED
		RUN_PLAYBACK_SPEED = RUN_PLAYBACK_SPEED * 2

	if global.level_settings["is_bike_ride"]:
		$main_char_node/bike_character.show()
		$main_char_node/main_character.hide()
		if global.level_settings["is_night"]:
			setup_night_bike_lights()
	else:
		$main_char_node/bike_character.hide()
		$main_char_node/main_character.show()

	set_process(true)
	animate_distance_circle()


func setup_night_bike_lights():
	$main_char_node/bike_character/bike_lights.show()
	blink_right_light()
	blink_left_light()
	
func blink_right_light():
	utils_custom.create_timer_2(0.3, self, "blink_right_light")
	var light = $main_char_node/bike_character/bike_lights/right
	light.visible = !light.visible

func blink_left_light():
	utils_custom.create_timer_2(0.4, self, "blink_left_light")
	var light = $main_char_node/bike_character/bike_lights/left
	light.visible = !light.visible

func set_bike_lights_right():
	var light_1 = $main_char_node/bike_character/bike_lights/right
	var light_2 = $main_char_node/bike_character/bike_lights/left
	light_1.modulate = Color(1,1,1,0.5)
	light_2.modulate = Color(1,0,0,0.5)

func set_bike_lights_left():
	var light_1 = $main_char_node/bike_character/bike_lights/right
	var light_2 = $main_char_node/bike_character/bike_lights/left
	light_1.modulate = Color(1,0,0,0.5)
	light_2.modulate = Color(1,1,1,0.5)

func animate_distance_circle():
	var circle_tween = Tween.new()
	add_child(circle_tween)
	circle_tween.interpolate_property(
		$main_char_node/circle,
		"rotation_degrees",
		0,
		360,
		6,
		circle_tween.TRANS_LINEAR,
		circle_tween.EASE_IN_OUT
	)
	circle_tween.set_repeat(true)
	circle_tween.start()


func _input(event):
	if event is InputEventMouseButton:
		mouse_pressed = event.pressed

	if event is InputEventScreenDrag or (event is InputEventMouseMotion and mouse_pressed):
		motion.x = (event.position.x - get_viewport_rect().size.x / 2) / get_viewport_rect().size.x
		motion.y = (
			(event.position.y - get_viewport_rect().size.y / 2)
			/ get_viewport_rect().size.y
			/ 2
		)
	else:
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		motion.y *= 0.5


func _physics_process(_delta):
	if Input.is_action_just_released("restart") and global.game_settings["debug"]:
		restart_pressed()

	if can_move:
		if running == false and running_recovering == false:
			stamina += abs(_delta * STAMINA_RECOVER_SPEED)
			stamina = min(stamina, STAMINA_MAX_AMOUNT)

		if Input.is_action_just_released("run"):
			running = false

		if Input.is_action_just_pressed("run") and running_recovering == false:
			running = true
		elif Input.is_action_pressed("run") and running == true:
			if motion.x != 0 or motion.y != 0:
				motion = motion.normalized() * RUN_MOTION_SPEED
				$main_char_node/main_character/AnimationPlayer.playback_speed = RUN_PLAYBACK_SPEED
				stamina -= abs(_delta * STAMINA_DEPLETION_SPEED)
				if stamina < 0:
					stop_running()
		elif Input.is_action_pressed("run_fast") and global.game_settings["debug"]:
			motion = motion.normalized() * RUN_MOTION_SPEED_FAST
			$main_char_node/main_character/AnimationPlayer.playback_speed = RUN_PLAYBACK_SPEED * 2
		else:
			$main_char_node/main_character/AnimationPlayer.playback_speed = WALK_PLAYBACK_SPEED
			motion = motion.normalized() * MOTION_SPEED

		move_and_slide(motion)

		set_animation_by_motion_direction()
		play_bump_sound()
		check_for_vehicle_collisions()
		set_nearest_enemy()


func stop_running():
	running = false
	running_recovering = true
	utils_custom.create_timer_2(STAMINA_RECOVERY_TIME, self, "can_run_again")


func can_run_again():
	running_recovering = false
	stamina = 0.01


func set_animation_by_motion_direction():
	if motion.x == 0 and motion.y == 0:
		$main_char_node/main_character/AnimationPlayer.playback_speed = 0
		$main_char_node/bike_character.playing = false
	elif motion.x < 0:
		$main_char_node/main_character/AnimationPlayer.play("left")
		$main_char_node/bike_character.play("left")
		set_bike_lights_left()
	elif motion.x > 0:
		$main_char_node/main_character/AnimationPlayer.play("right")
		$main_char_node/bike_character.play("right")
		set_bike_lights_right()
	elif motion.y < 0:
		$main_char_node/main_character/AnimationPlayer.play("up")
	elif motion.y > 0:
		$main_char_node/main_character/AnimationPlayer.play("down")


func play_bump_sound():
	if should_play_bump_sound:
		if get_slide_count() != 0:
			for i in range(0, get_slide_count()):
				print(get_slide_collision(i).collider.get_name())
				var a = get_slide_collision(i).collider
				if get_slide_collision(i).collider.get_name().find("Enemy") != -1:
					if should_play_bump_sound:
						sound_bumps.get_child(randi() % sound_bumps.get_child_count()).play()
						utils_custom.create_timer_2(1, self, "set_should_play_bump_sound")
						should_play_bump_sound = false


func check_for_vehicle_collisions():
	for i in range(0, get_slide_count()):
		print(get_slide_collision(i).collider.get_name())
		var a = get_slide_collision(i).collider
		if get_slide_collision(i).collider.get_name().find("vehicle") != -1:
			# TOOD: add an animation here: Skull and bone?
			can_move = false
			main_music.stop()
			star_music.stop()
			sound_lost.play()
			if should_play_bump_sound:
				var bump_sound = sound_bumps.get_child(randi() % sound_bumps.get_child_count())
				bump_sound.volume_db = 20
				bump_sound.play()
				utils_custom.create_timer_2(1, self, "set_should_play_bump_sound")
				should_play_bump_sound = false
			show_lose_icon("accident")
			utils_custom.create_timer_2(2, self, "player_hit_by_car")


func player_hit_by_car():
	get_tree().change_scene("res://lose-hurt.tscn")


func set_should_play_bump_sound():
	should_play_bump_sound = true


func set_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		nearest_enemy = enemies[0]

		for enemy in enemies:
			if (
				enemy.global_position.distance_to(self.global_position)
				< nearest_enemy.global_position.distance_to(self.global_position)
			):
				nearest_enemy = enemy


func acquired_key():
	sound_acquired_key.play()
	sound_acquired_key_door.play()

	get_tree().get_root().get_node("game/elements/door/wooden-door").hide()
	get_tree().get_root().get_node("game/elements/door/wooden-door-open").show()

	get_tree().get_root().get_node("game/interface/key").show()
	var blocked_passage = get_tree().get_root().get_node("game/game_limits/small-road-key-locked")
	blocked_passage.queue_free()


func acquired_hand_sanitizer():
	sound_acquired_hand_sanitizer.play()
	get_tree().get_root().get_node("game").damage += global.level_settings["sanitizer"]["healing_points"]
	get_tree().get_root().get_node("game").damage = min(
		get_tree().get_root().get_node("game").damage, global.game_settings["player"]["max_health"]
	)


func acquired_attestation():
	sound_acquired_attestation.play()

	if has_attestation == false:
		utils_custom.create_timer_2(1, self, "decrement_attestation_timer")

	has_attestation = true

	has_attestation_time = global.level_settings["attestation"]["duration"]
	var attestation_timer = get_node("/root/game/interface/attestation_timer")
	var attestation_slot_empty = get_node("/root/game/interface/attestation_slot_empty")
	var attestation_slot_full = get_node("/root/game/interface/attestation_slot_full")
	attestation_timer.get_node("timer_label").text = str(has_attestation_time)
	attestation_timer.show()
	attestation_slot_empty.hide()
	attestation_slot_full.show()


func decrement_attestation_timer():
	var attestation_timer_label = get_node("/root/game/interface/attestation_timer/timer_label")
	has_attestation_time = has_attestation_time - 1
	attestation_timer_label.text = str(has_attestation_time)

	if has_attestation_time < 0:
		has_attestation = false

		var attestation_slot_empty = get_node("/root/game/interface/attestation_slot_empty")
		var attestation_slot_full = get_node("/root/game/interface/attestation_slot_full")
		var attestation_timer = get_node("/root/game/interface/attestation_timer")
		attestation_slot_empty.show()
		attestation_slot_full.hide()
		attestation_timer.hide()

		main_music.stream_paused = false
		star_music.stream_paused = true

	else:
		utils_custom.create_timer_2(1, self, "decrement_attestation_timer")


func restart_pressed():
	# $HTTPRequest.request("http://localhost:8082/TEST_settingss.json")
	get_tree().change_scene("res://level_bastille.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8()).result
	global.game_settings = json

	# TODO keep the current level 
	# global.set_level_settings("groceries_easy", "groceries")
	global.set_level_settings("sport_easy", "sport")
	get_tree().change_scene("res://level_bastille.tscn")


func show_lose_icon(cause):
	var sprite = Sprite.new()

	if get_node("main_char_node/end_level_icons").get_children().size() == 0:
		var image_to_show_choices
		if cause == "accident":
			image_to_show_choices = ["x_eyes", "hurt", "skull_and_cross", "angry", "angry_00"]
		elif cause == "sick":
			image_to_show_choices = [
				"face-with-thermometer",
				"x_eyes",
			]
		elif cause == "police":
			image_to_show_choices = ["x_eyes", "angry_00"]

		randomize()
		var image_to_show = image_to_show_choices[randi() % image_to_show_choices.size()]
		sprite.set_texture(load("res://images/interface/end_level_icons/" + image_to_show + ".png"))
		get_node("main_char_node/end_level_icons").add_child(sprite)


func show_win_icon():
	randomize()
	var sprite = Sprite.new()
	var image_to_show_choices = global.level_settings["win_icons"]
	var image_to_show = image_to_show_choices[randi() % image_to_show_choices.size()]
	sprite.set_texture(load("res://images/interface/end_level_icons/" + image_to_show + ".png"))
	get_node("main_char_node/end_level_icons").add_child(sprite)
