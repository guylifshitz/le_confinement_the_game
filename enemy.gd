extends KinematicBody2D

var follows_player = false

var speed = 100
onready var main_char = get_parent().get_parent().get_parent().get_parent().get_node("main_characterKinematic")

func _ready():
	follows_player = true

func _process(delta):
	
	print(main_char)
	print(self.global_position)
	print(main_char.global_position)
	if follows_player:
		var dir = (main_char.global_position - self.global_position).normalized()
		self.move_and_collide(dir * speed * delta)

