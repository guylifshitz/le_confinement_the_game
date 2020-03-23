extends Node2D

onready var fps_label = get_node('fps')
onready var player = get_tree().get_root().get_node("game/elements/player")
onready var nearest_enemy_line = get_tree().get_root().get_node("game/nearest_enemy_line/")

var score = 0
var damage = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	get_tree().get_root().get_node("game/CanvasLayer/interface/score").text = str(int(score))
	get_tree().get_root().get_node("game/CanvasLayer/interface/damage").text = str(int(damage))
	update()

	get_tree().get_root().get_node("game/CanvasLayer/interface/fps").set_text(str(Engine.get_frames_per_second()))

