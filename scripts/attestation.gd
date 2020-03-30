extends Sprite

onready var star_music = get_tree().get_root().get_node("game/audio/star_music")
onready var main_music = get_tree().get_root().get_node("game/audio/main_music")

var game_settings = utils_custom.load_json("res://jsons/game_settings.json")


func _ready():
	pass # Replace with function body.



func _on_attestation_body_entered(body):
	if body.name == "player" and self.get_parent().visible:
		self.get_parent().hide()
		utils_custom.create_timer_2(game_settings["level_1"]["attestation_respawn_time"], self, "enable_attestation")
		
		body.acquired_attestation()
		star_music.stream_paused = false
		main_music.stream_paused = true

func enable_attestation():
	self.get_parent().show()
