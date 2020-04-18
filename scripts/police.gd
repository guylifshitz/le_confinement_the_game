extends  KinematicBody2D

# parameters
var MOVE_SPEED = global.level_settings["police"]["move_speed"]

# objects
onready var player = get_tree().get_root().get_node("game/elements/player")
onready var sound_lost = get_tree().get_root().get_node("game/audio/lost")
onready var music_star = get_tree().get_root().get_node("game/audio/star_music")
onready var music_main = get_tree().get_root().get_node("game/audio/main_music")

# navigation
var navigation
var follows_player = false
var wants_to_control = true
var simple_path = PoolVector2Array()
var following_player_start_position
var remote_path_follow
var remote_transform


func _ready():
	remote_path_follow.offset = randi() % 10000

	if randf() > 0.6:
		$AnimatedSprite.play("no_mask")
	else:
		$AnimatedSprite.play("mask")
	
	navigation = remote_transform.get_parent().get_parent().get_parent().get_parent()


func _process(delta):
	if follows_player:
		var dir = (player.global_position - self.global_position).normalized()
		self.move_and_collide(dir * MOVE_SPEED * delta)
	else:
		if simple_path.size() > 0:
			move_along_path(MOVE_SPEED * delta)
		else:
			remote_path_follow.offset += MOVE_SPEED  * delta
			self.global_position = remote_transform.global_position


func move_along_path(distance):
	if distance == 0:
		return
	var start_point = global_position
	for i in range(simple_path.size()):
		var distance_to_next = start_point.distance_to(simple_path[0])

		if distance < distance_to_next and distance > 0.0:
			global_position = start_point.linear_interpolate(simple_path[0], distance/distance_to_next)
			break
		elif simple_path.size() == 1 && distance >= distance_to_next:
			global_position = simple_path[0]
#			set_process(false)

		distance -= distance_to_next
		start_point = simple_path[0]
		simple_path.remove(0)



func _on_police_body_entered(body):
	if body.name == "player":
		if body.has_attestation:
			if wants_to_control:
				wants_to_control = false
				utils_custom.create_timer_2(5, self, "set_wants_to_control")
				$dialogbox_is_happy.show()
				$dialogbox_wants_attestation.hide()
				$dialogbox_is_angry.hide()
				return_to_path()
		else:
			$dialogbox_is_happy.hide()
			$dialogbox_wants_attestation.hide()
			$dialogbox_is_angry.show()
			player.can_move = false
			player.show_lose_icon("police")
			music_main.stop()
			music_star.stop()
			sound_lost.play()

			utils_custom.create_timer_2(2, self, "kill_player")

func set_wants_to_control():
	wants_to_control = true


func kill_player():
	get_tree().change_scene("res://lose-police.tscn")


func _on_show_dialog_body_entered(body):
	if body.name == "player":
		if wants_to_control:
			if randf() > 0.5:
				$audio/question.play()
			else:
				$audio/question_2.play()
			$dialogbox_wants_attestation.show()
			follows_player = true
			if simple_path.size() == 0:
				following_player_start_position = self.global_position
			
		else:
			$dialogbox_is_happy.show()


func _on_show_dialog_body_exited(body):
	if body.name == "player":
		$dialogbox_wants_attestation.hide()
		$dialogbox_is_happy.hide()
		if follows_player:
			return_to_path()

func return_to_path():
	follows_player = false
	simple_path = navigation.get_simple_path(global_position, following_player_start_position)
