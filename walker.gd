extends KinematicBody2D

const MOTION_SPEED = 200 # Pixels/second.
#const MOTION_SPEED = 600

var nearest_enemy_glob

func _ready():
	set_process(true)
	var circle_tween = Tween.new()
	add_child(circle_tween)
	
	circle_tween.interpolate_property($main_char_node/circle, "rotation_degrees", 0,360,6,circle_tween.TRANS_LINEAR, circle_tween.EASE_IN_OUT)
	circle_tween.set_repeat(true)
	circle_tween.start()
	remove_groceries()
	remove_drugs()
	
func toggle_groceries():
	var groceries = self.find_node("groceries")
	if groceries.is_visible_in_tree():
		groceries.hide()
	else:
		groceries.show()
	
func add_groceries():
	var groceries = self.find_node("groceries")
	groceries.show()
	
func remove_groceries():
	var groceries = self.find_node("groceries")
	groceries.hide()
	
func toggle_drugs():
	var drugs = self.find_node("drugs")
	if drugs.is_visible_in_tree():
		drugs.hide()
	else:
		drugs.show()
	
func add_drugs():
	var drugs = self.find_node("drugs")
	drugs.show()
	
func remove_drugs():
	var drugs = self.find_node("drugs")
	drugs.hide()
	
func _physics_process(_delta):
	get_closest()
	
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y *= 0.5
	motion = motion.normalized() * MOTION_SPEED
	if Input.is_action_pressed("move_left"):
		$main_char_node/main_character/AnimationPlayer.play("left")
	elif Input.is_action_pressed("move_right"):
		$main_char_node/main_character/AnimationPlayer.play("right")
	elif Input.is_action_pressed("move_up"):
		$main_char_node/main_character/AnimationPlayer.play("up")
	elif Input.is_action_pressed("move_down"):
		$main_char_node/main_character/AnimationPlayer.play("down")
	else:
		$main_char_node/main_character/AnimationPlayer.play("idle")
	#warning-ignore:return_value_discarded
	move_and_slide(motion)

func get_closest():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		var nearest_enemy = enemies[0]
	#
		for enemy in enemies:
			if enemy.global_position.distance_to(self.global_position) < nearest_enemy.global_position.distance_to(self.global_position):
				nearest_enemy = enemy
		
		nearest_enemy_glob = nearest_enemy;
		print("Nearest", nearest_enemy.global_position.distance_to(self.global_position))
