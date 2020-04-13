extends KinematicBody2D

var prev_x = 0
var prev_y = 0
var base_scale = 0.5
var remote_path_follow
var remote_transform

var MOVE_SPEED = global.level_settings["police_car"]["move_speed"]

func _ready():
	pass
	remote_path_follow.offset = randi() % 10000

func _process(delta):
	#self.get_parent().offset += 500 * delta;
	
	#global_position = Vector2(500,500)
	remote_path_follow.offset += MOVE_SPEED  * delta
	self.global_position = remote_transform.global_position
	print(global_position)
#	print9
	if prev_x < self.global_position.x and prev_y > self.global_position.y:
		self.scale = Vector2(base_scale, base_scale)
		$AnimatedSprite.play("up")
	elif prev_x < self.global_position.x and prev_y < self.global_position.y:
		self.scale = Vector2(base_scale, base_scale)
		$AnimatedSprite.play("down")
	elif prev_x > self.global_position.x and prev_y < self.global_position.y:
		self.scale = Vector2(-base_scale, base_scale)
		$AnimatedSprite.play("down")
	else:
		self.scale = Vector2(-base_scale, base_scale)
		$AnimatedSprite.play("up")
	prev_x = global_position.x
	prev_y = global_position.y
