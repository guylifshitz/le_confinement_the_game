extends Sprite

onready var star_music = get_tree().get_root().get_node("game/audio/star_music")
onready var main_music = get_tree().get_root().get_node("game/audio/main_music")

func _ready():
	pass # Replace with function body.



func _on_attestation_body_entered(body):
	if body.name == "player":
		self.get_parent().queue_free()
		body.acquired_attestation()

		star_music.stream_paused = false
		main_music.stream_paused = true

