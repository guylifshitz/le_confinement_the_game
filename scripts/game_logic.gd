extends Node2D

onready var player = get_tree().get_root().get_node("game/elements/player")
onready var nearest_enemy_line = get_tree().get_root().get_node("game/nearest_enemy_line/")
onready var stores = $elements/goals/

		
onready var sound_lost = get_tree().get_root().get_node("game/audio/lost")
onready var sound_win = get_tree().get_root().get_node("game/audio/win")
onready var music_star = get_tree().get_root().get_node("game/audio/star_music")
onready var music_main = get_tree().get_root().get_node("game/audio/main_music")


var game_settings = utils_custom.load_json("res://jsons/game_settings.json")

var score = game_settings["level_1"]["starting_bonus_score"]
var damage = game_settings["player"]["max_health"]

var score_increment_speed = 10
var score_max_distance = 200
var damage_decrement_exponent = game_settings["level_1"]["damage_decrement_exponent"]
var score_decrement_exponent  = game_settings["level_1"]["score_decrement_exponent"]

func _ready():
	if global.level_type == "sport":
		self.get_node("interface/grandma").hide()
	player.items_needed = game_settings["level_1"]["items_needed"]
	player.items_bonus = game_settings["level_1"]["items_bonus"]
	for store_settings in game_settings["level_1"]["store_items"]:
		stores.find_node(store_settings["store"]).get_child(0).store_has_items = store_settings["has_items"]

	if not game_settings["debug"]:
		get_tree().get_root().get_node("game/interface/fps").hide()

func _process(delta):
	if player.nearest_enemy:
		var sprite_sprite = player.get_node("main_char_node/main_character")
		var circle = player.get_node("main_char_node/circle")

		var nearest_distance = player.nearest_enemy.global_position.distance_to(player.global_position)

		var score_ratio = min(pow(nearest_distance/score_max_distance, score_decrement_exponent), 1)
		var score_delta =  (1-score_ratio) * score_increment_speed * delta
		score -= max(score_delta, 0)

		if nearest_distance < 100:
			var damage_intensity = (100-nearest_distance) / 100
			damage -= pow(damage_intensity, damage_decrement_exponent)
			sprite_sprite.modulate = Color(1,1-damage_intensity,1-damage_intensity)
			circle.modulate = Color(damage_intensity,0,0, max(damage_intensity, 0.15))
		else:
			sprite_sprite.modulate = Color(1,1,1)
			circle.modulate = Color(0,0,0, 0.15)

		update_bar($interface/distance_bar, score_ratio)
		$interface/score_label.bbcode_text = "[right]" + str(int(score))
		update_bar($interface/health_bar, max(damage/game_settings["player"]["max_health"], 0))
		check_player_death()
		draw_nearest_line(nearest_distance)

	update_bar($interface/stamina_bar, max(player.stamina/player.STAMINA_MAX_AMOUNT, 0))

	if game_settings["debug"]:
		get_tree().get_root().get_node("game/interface/fps").set_text("FPS:"+str(Engine.get_frames_per_second()))


func check_player_death():
	if damage < 0:
		if player.can_move:
			# TOOD: add an animation here
			player.can_move = false
			music_main.stop()
			music_star.stop()
			sound_lost.play()
			utils_custom.create_timer_2(2, self, "player_dead")


func player_dead():
	get_tree().change_scene("res://lose-sick.tscn")


func draw_nearest_line(nearest_distance):
	if game_settings["general"]["show_nearest_enemy_line"]:
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


func win_game():
	if player.can_move:
		player.can_move = false
		music_main.stop()
		music_star.stop()
		sound_win.play()
		utils_custom.create_timer_2(2, self, "show_win_screen")


func show_win_screen():
	global.score = score
	global.bonus_items_recovered = player.items_holding_bonus
	get_tree().change_scene("res://win-screen.tscn")

