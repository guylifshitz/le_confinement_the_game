extends Node2D

onready var player = get_tree().get_root().get_node("game/elements/player")
onready var nearest_enemy_line = get_tree().get_root().get_node("game/nearest_enemy_line/")
onready var stores = $elements/goals/

var score = 0
var damage = 100
var game_settings = load_json()
var score_increment_speed = 10
var score_max_distance = 200

func _ready():
	player.items_needed = ["toilet_paper", "bread", "drugs"]	
	player.items_bonus = ["flower"]
	stores.find_node("monoprix").get_child(0).store_has_items = []
	stores.find_node("carrefour").get_child(0).store_has_items = ["toilet_paper"]
	stores.find_node("boulangerie").get_child(0).store_has_items = ["bread"]
	stores.find_node("la_suprette").get_child(0).store_has_items = []
	stores.find_node("pharmacy_1").get_child(0).store_has_items = ["drugs"]
	stores.find_node("pharmacy_2").get_child(0).store_has_items = ["drugs"]
	stores.find_node("flower_market").get_child(0).store_has_items = ["flower"]

func load_json():
	var file = File.new()
	file.open("res://jsons/game_settings.json", file.READ)
	var json_text = file.get_as_text()
	file.close()
	var result_json = JSON.parse(json_text)
	
	if result_json.error == OK:
		return result_json.result
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
		return

func _process(delta):
	if player.nearest_enemy_glob:
		var nearest_distance = player.nearest_enemy_glob.global_position.distance_to(player.global_position)

		nearest_enemy_line.points = [player.global_position, player.nearest_enemy_glob.global_position]
		nearest_enemy_line.default_color = Color(1-(nearest_distance/3/100),0,0, max(1-(nearest_distance/3/100), 0))
		if nearest_distance < 500:
			# nearest_enemy_line.show()
			pass
		else:
			nearest_enemy_line.hide()
	

		var sprite = player.find_node("main_char_node").find_node("main_character")
		var circle = player.find_node("main_char_node").find_node("circle")
		
		var score_ratio = min(pow(nearest_distance/score_max_distance, 2), 1)
		var score_delta =  score_ratio * score_increment_speed * delta
		
		score += score_delta
		if nearest_distance < 100:
			var damage_intensity = (100-nearest_distance) / 100
			damage -= pow(damage_intensity, 2)
			sprite.modulate = Color(1,1-damage_intensity,1-damage_intensity)
			circle.modulate = Color(damage_intensity,0,0)
		else:
			sprite.modulate = Color(1,1,1)
			circle.modulate = Color(0,0,0)

		var distance_bar = $"interface/distance-bar"
		var distance_bar_bg = $"interface/distance-bg"
		var start_pos_dist = distance_bar.points[1]
		var end_pos_dist = distance_bar_bg.points[0]
		end_pos_dist = lerp(start_pos_dist, end_pos_dist, score_ratio)
		distance_bar.points[0] = end_pos_dist

#	var temp = get_tree().get_root().get_node("game/interface/score")
	$interface/interface/score.bbcode_text = "[right]" + str(int(score))
	#get_tree().get_root().get_node("game/interface/interface/damage").text = str(int(damage))
	#get_tree().get_root().get_node("game/interface/health-red").shape
	#print($"interface/health-red".gradient.set_offset(1, 1))

	var health_bar = $"interface/health-bar"
	var health_bar_bg = $"interface/health-bg"
	var start_pos = health_bar.points[1]
	var end_pos = health_bar_bg.points[0]
	end_pos = lerp(start_pos, end_pos, max(damage/100, 0))
	health_bar.points[0] = end_pos


	update()

	get_tree().get_root().get_node("game/interface/interface/fps").set_text("FPS:"+str(Engine.get_frames_per_second()))

