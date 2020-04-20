extends Node2D

var dialog_chunks = []
var dialog_chunk = 0
var accepts_input 
export var dialog_text_english:String
export var dialog_text_french:String

func _ready():

	$girl.show()
	
	if global.language == "french":
		$glass_text_box/caption_text_english.hide()
		$glass_text_box/caption_text_french.show()
		dialog_chunks = [dialog_text_french]
	else:
		$glass_text_box/caption_text_english.show()
		$glass_text_box/caption_text_french.hide()
		dialog_chunks = [dialog_text_english]

	update_text()
	
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
		
		
