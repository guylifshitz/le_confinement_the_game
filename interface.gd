extends Node2D


onready var fps_label = get_node('fps')

var score = 0
var damage = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var main_char = self.get_parent().get_parent().get_parent().find_node("main_characterKinematic")
	if main_char.nearest_enemy_glob:
		var nearest_distance = main_char.nearest_enemy_glob.global_position.distance_to(main_char.global_position)
	
		var sprite = main_char.find_node("main_char_node").find_node("main_character")
		var circle = main_char.find_node("main_char_node").find_node("circle")
		
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
