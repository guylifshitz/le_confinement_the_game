extends Node2D

onready var player = get_tree().get_root().get_node("game/elements/player")
onready var nearest_enemy_line = get_tree().get_root().get_node("game/nearest_enemy_line/")
onready var stores = $elements/goals/

var score = 0
var damage = 100

func _ready():
	player.items_needed = ["toilet_paper", "bread", "drugs"]	
	stores.find_node("monoprix").get_child(0).store_has_items = []
	stores.find_node("carrefour").get_child(0).store_has_items = ["toilet_paper"]
	stores.find_node("boulangerie").get_child(0).store_has_items = ["bread"]
	stores.find_node("la_suprette").get_child(0).store_has_items = []
	stores.find_node("pharmacy_1").get_child(0).store_has_items = ["drugs"]
	stores.find_node("pharmacy_2").get_child(0).store_has_items = ["drugs"]
	pass


func _process(delta):
	if player.nearest_enemy_glob:
		var nearest_distance = player.nearest_enemy_glob.global_position.distance_to(player.global_position)

		nearest_enemy_line.points = [player.global_position, player.nearest_enemy_glob.global_position]
		nearest_enemy_line.default_color = Color(1-(nearest_distance/3/100),0,0, max(1-(nearest_distance/3/100), 0))
		if nearest_distance < 500:
			nearest_enemy_line.show()
		else:
			nearest_enemy_line.hide()
	

		var sprite = player.find_node("main_char_node").find_node("main_character")
		var circle = player.find_node("main_char_node").find_node("circle")
		
		score += nearest_distance / 100
		if nearest_distance < 100:
			var damage_intensity = (100-nearest_distance) / 100
			damage -= pow(damage_intensity, 2)
			sprite.modulate = Color(1,1-damage_intensity,1-damage_intensity)
			circle.modulate = Color(damage_intensity,0,0)
		else:
			sprite.modulate = Color(1,1,1)
			circle.modulate = Color(0,0,0)
#	var temp = get_tree().get_root().get_node("game/interface/score")
	$CanvasLayer/interface/score.bbcode_text = "[right]" + str(int(score))
	#get_tree().get_root().get_node("game/CanvasLayer/interface/damage").text = str(int(damage))
	#get_tree().get_root().get_node("game/CanvasLayer/health-red").shape
	#print($"CanvasLayer/health-red".gradient.set_offset(1, 1))
	var health_bar = $"CanvasLayer/health-red"
	var health_bar_bg = $"CanvasLayer/health-bg"
	var start_pos = health_bar.points[0]
	var end_pos = health_bar_bg.points[1]
	end_pos = lerp(start_pos, end_pos, max(damage/100, 0))
	health_bar.points[1] = end_pos
	update()

	get_tree().get_root().get_node("game/CanvasLayer/interface/fps").set_text(str(Engine.get_frames_per_second()))

