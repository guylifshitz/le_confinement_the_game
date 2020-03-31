extends Node2D

var dialog_chunks = ["*Cough*Cough*"]
var dialog_chunk = 0
var accepts_input 

func _ready():
	update_text()

#	randomize()
#	if randf() > 0.5:
	$glass_text_box/grandma_sick_text.show()
	$grandma.show()
	$girl.hide()
	$glass_text_box/girl_sick_text.hide()
#	else:
#	$glass_text_box/grandma_sick_text.hide()
#	$grandma.hide()
#	$girl.show()
#	$glass_text_box/girl_sick_text.show()

	accepts_input = false
	utils_custom.create_timer_2(3, self, "accept_input")


func accept_input():
	$continue_button.modulate = Color(1,1,1)
	$exit.modulate = Color(1,1,1)
	accepts_input = true
	
func update_text():
	if dialog_chunk == dialog_chunks.size():
		pass
	else:
		$dialog/dialog_text.text = dialog_chunks[dialog_chunk]
		utils_custom.create_timer_2(1, self, "update_text")
	dialog_chunk += 1


func _process(_delta):
	if accepts_input:
		if Input.is_action_just_pressed("ui_accept"):
			player_clicked()

func player_clicked():
	if accepts_input:
		change_scene()
	
func change_scene():
	get_tree().change_scene("res://level_bastille.tscn")

func _on_continue_button_down():
	if accepts_input:
		change_scene()


func _on_exit_button_down():
	if accepts_input:
		get_tree().change_scene("res://level_select.tscn")
		
		
