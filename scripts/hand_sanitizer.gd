extends Sprite

var respawn_time = global.level_settings["sanitizer"]["respawn_time"]

func _ready():
	pass # Replace with function body.

func _on_hand_sanitizer_body_entered(body):
	if body.name == "player" and self.get_parent().visible:
		body.acquired_hand_sanitizer()
		self.get_parent().hide()
		if respawn_time > 0:
			utils_custom.create_timer_2(respawn_time, self, "enable_hand_sanitizer")

func enable_hand_sanitizer():
	self.get_parent().show()
