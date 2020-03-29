extends Node2D


onready var fps_label = get_node('fps')
onready var player = get_tree().get_root().get_node("game/elements/player")

var score = 0
var damage = 100

func _ready():
	pass


func _process(delta):
	if player.nearest_enemy:
		var nearest_distance = player.nearest_enemy.global_position.distance_to(player.global_position)
	
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

	$score.text = str(int(score))
	$damage.text = str(int(damage))
	update()

	fps_label.set_text(str(Engine.get_frames_per_second()))


	update()
