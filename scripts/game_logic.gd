extends Node2D

onready var player = get_tree().get_root().get_node("game/elements/player")
onready var nearest_enemy_line = get_tree().get_root().get_node("game/nearest_enemy_line/")
onready var stores = $elements/goals/ 

onready var sound_lost = get_tree().get_root().get_node("game/audio/lost")
onready var sound_win = get_tree().get_root().get_node("game/audio/win")
onready var music_star = get_tree().get_root().get_node("game/audio/star_music")
onready var music_main = get_tree().get_root().get_node("game/audio/main_music")

var sports_timer_start = 0

var score = global.level_settings["starting_bonus_score"]
var damage = global.game_settings["player"]["max_health"]

var score_max_distance = 200
var damage_decrement_exponent = global.level_settings["damage_decrement_exponent"]
var damage_multiplier = global.level_settings["damage_multiplier"]
var nearest_distance_minimum = global.game_settings["general"]["nearest_distance_minimum"]
var score_decrement_exponent  = global.level_settings["score_decrement_exponent"]
var score_increment_speed = global.level_settings["score_increment_speed"]

func _ready():
	music.get_node("main_menu").stop()

	if global.level_settings["is_night"]:
		self.get_node("elements/scene/traffic_lights").show()
		self.get_node("night").show()

	if not global.level_settings["is_bike_ride"]:
		self.get_node("sidewalk_limits").queue_free()	

	if global.level_type == "sport":
		self.get_node("interface/grandma").hide()
	else:
		self.get_node("interface/sports_timer_label").hide()
		player.items_needed = global.level_settings["items_needed"]
		player.items_bonus = global.level_settings["items_bonus"]
		
		for store_settings in global.level_settings["store_items"]:
			stores.find_node(store_settings["store"]).get_child(0).store_has_items = store_settings["has_items"]
			setup_grandma()

	setup_per_level_game_limits()
	setup_per_level_game_elements()

	if not global.game_settings["debug"]:
		get_tree().get_root().get_node("game/interface/fps").hide()

	sports_timer_start = OS.get_unix_time()
	add_attestations()	
	add_sanitizer()

func setup_per_level_game_limits():
	var limits = get_node("game_limits_per_level")
	for child in limits.get_children():
		child.hide()

	for game_limit in global.level_settings["game_limits"]:
		limits.get_node(game_limit).show()
	
	for child in limits.get_children():
		if not child.visible:
			child.queue_free()

func setup_per_level_game_elements():
	var limits = get_node("elements/per_level_game_elements")
	for child in limits.get_children():
		child.hide()

	for game_limit in global.level_settings["game_elements"]:
		limits.get_node(game_limit).show()
	
	for child in limits.get_children():
		if not child.visible:
			child.queue_free()
					
	
func setup_grandma():
	var grandma_goals = self.get_node("interface/grandma/items_wanted")

	for item_index in range(global.level_settings["items_needed"].size()):
		var item  = global.level_settings["items_needed"][item_index]

		var holding_slot = grandma_goals.get_child(item_index)
		var item_to_hold = load("res://prefab/holding_"+item+".tscn")

		holding_slot.add_child(item_to_hold.instance())

func _process(delta):
	if player.nearest_enemy:
		var sprite_sprite = player.get_node("main_char_node/main_character")
		var circle = player.get_node("main_char_node/circle")

		var nearest_distance = max(player.nearest_enemy.global_position.distance_to(player.global_position), nearest_distance_minimum)

		var score_ratio = min(pow(nearest_distance/score_max_distance, score_decrement_exponent), 1)
		var score_delta =  (1-score_ratio) * score_increment_speed * delta
		score -= max(score_delta, 0)
		score = max(score, 0)
		
		var nearest_distance_threshold = 80
		if global.level_type == "sport":
			nearest_distance_threshold = 110

		if nearest_distance < nearest_distance_threshold:
			var damage_intensity = (nearest_distance_threshold-nearest_distance) / nearest_distance_threshold + 0.2
			damage -= pow(damage_intensity, damage_decrement_exponent) * damage_multiplier
			sprite_sprite.modulate = Color(1,1-damage_intensity,1-damage_intensity)
			circle.modulate = Color(damage_intensity,0,0, max(damage_intensity, 0.15))
		else:
			sprite_sprite.modulate = Color(1,1,1)
			circle.modulate = Color(0,0,0, 0.15)

		update_bar($interface/distance_bar, score_ratio)
		$interface/score_label.bbcode_text = "[right]" + str(int(score))
		update_bar($interface/health_bar, max(damage/global.game_settings["player"]["max_health"], 0))
		check_player_death()
		draw_nearest_line(nearest_distance)

	update_bar($interface/stamina_bar, max(player.stamina/player.STAMINA_MAX_AMOUNT, 0))
	update_sports_timer()

	if global.game_settings["debug"]:
		get_tree().get_root().get_node("game/interface/fps").set_text("FPS:"+str(Engine.get_frames_per_second()))

func add_attestations():
	var attestations = get_node("elements/pickups/attestations")
	for attestation in attestations.get_children():
		attestation.hide()
	
	for attestation_name in global.level_settings["attestation"]["visible_list"]:
		attestations.get_node(attestation_name).show()

	for attestation in attestations.get_children():
		if not attestation.visible:
			attestation.queue_free()

func add_sanitizer():
	var sanitizers = get_node("elements/pickups/sanitizers")
	for sanitizer in sanitizers.get_children():
		sanitizer.hide()
	
	for sanitizer_name in global.level_settings["sanitizer"]["visible_list"]:
		sanitizers.get_node(sanitizer_name).show()

	for sanitizer in sanitizers.get_children():
		if not sanitizer.visible:
			sanitizer.queue_free()

func check_player_death():
	if damage < 0:
		if player.can_move:
			# TOOD: add an animation here
			player.can_move = false
			music_main.stop()
			music_star.stop()
			sound_lost.play()
			player.show_lose_icon("sick")
			utils_custom.create_timer_2(2, self, "player_dead")


func player_dead():
	get_tree().change_scene("res://lose-sick.tscn")


func draw_nearest_line(nearest_distance):
	if global.game_settings["general"]["show_nearest_enemy_line"]:
		nearest_enemy_line.points = [player.global_position, player.nearest_enemy.global_position]
		nearest_enemy_line.default_color = Color(1-(nearest_distance/3/100),0,0, max(1-(nearest_distance/3/100), 0))
		if nearest_distance < 500:
			nearest_enemy_line.show()
			pass
		else:
			nearest_enemy_line.hide()


func update_bar(bar_prefab, value):
	var bar = bar_prefab.get_node("bar")
	var bg = bar_prefab.get_node("bg")
	var start_pos = bar.points[1]
	var end_pos = bg.points[0]
	end_pos = lerp(start_pos, end_pos, value)
	bar.points[0] = end_pos

func update_sports_timer():
	if global.level_type == "sport":
		var time_now = OS.get_unix_time()
		var elapsed = time_now - sports_timer_start
		var minutes = elapsed / 60
		var seconds = elapsed % 60
		var str_elapsed = "%02d:%02d" % [minutes, seconds]
		$interface/sports_timer_label.bbcode_text = "[center]"+str_elapsed
		global.sports_timer = str_elapsed

func win_game():
	if player.can_move:
		player.show_win_icon()
		player.can_move = false
		music_main.stop()
		music_star.stop()
		sound_win.play()
		utils_custom.create_timer_2(2, self, "show_win_screen")


func show_win_screen():
	global.score = score
	global.bonus_items_recovered = player.items_holding_bonus
	global.items_recovered = player.items_holding
	get_tree().change_scene("res://win-screen.tscn")

