extends Node2D

var dialog_chunks = ["*Cough*Cough*"]
var dialog_chunk = 0
var accepts_input 

func _ready():
	update_text()

	randomize()
	if randf() > 0.5:
		$"grandma-sick-text".show()
		$grandma.show()
		$girl.hide()
		$"girl-sick-text".hide()
	else:
		$"grandma-sick-text".hide()
		$grandma.hide()
		$girl.show()
		$"girl-sick-text".show()

	accepts_input = false
	utils_custom.create_timer_2(3, self, "accept_input")


func accept_input():
	accepts_input = true
	
func update_text():
	if dialog_chunk == dialog_chunks.size():
		#utils_custom.create_timer_2(1, self, "change_scene")
		pass
	else:
		$RichTextLabel.text = dialog_chunks[dialog_chunk]
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
