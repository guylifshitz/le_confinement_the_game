extends Node2D

var settings = load_json()
var dialog_chunks = load_json()["english"]
var dialog_chunk = -1

var TEXT_SCROLL_SPEED = 0.01

func _ready():
	next_page()

func scroll_text():
	show_icons()
	if $grandma_dialog.visible_characters < $grandma_dialog.text.length():
		$grandma_dialog.visible_characters += 1
		utils_custom.create_timer_2(TEXT_SCROLL_SPEED, self, "scroll_text")
	else:
		$click_button.show()

func text_clicked():
	if $grandma_dialog.visible_characters < $grandma_dialog.text.length():
		$grandma_dialog.visible_characters = $grandma_dialog.text.length()
		show_icons()
	else:
		next_page()

func show_icons():
	$icons/groceries.hide()
	$icons/distance_bar.hide()
	$icons/health_bar.hide()
	$icons/attestation.hide()
	$icons/policeman.hide()

	if 	$grandma_dialog.visible_characters >= $grandma_dialog.text.length():
		if settings["show_items_list_text_index"] == dialog_chunk:
			$icons/groceries.show()
		if settings["show_distance_bar_text_index"] == dialog_chunk:
			$icons/distance_bar.show()
		if settings["show_health_bar_text_index"] == dialog_chunk:
			$icons/health_bar.show()
		if settings["show_attestation_text_index"] == dialog_chunk:
			$icons/attestation.show()
		if settings["show_police_text_index"] == dialog_chunk:
			$icons/policeman.show()
			
func next_page():
	dialog_chunk += 1
	if dialog_chunk == dialog_chunks.size():
		go_to_next_scene()
	else:
		$click_button.hide()
		$grandma_dialog.text = dialog_chunks[dialog_chunk]
		$grandma_dialog.visible_characters = 1
		scroll_text()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		text_clicked()

func go_to_next_scene():
	get_tree().change_scene("res://level_bastille.tscn")

func load_json():
	var file = File.new()
	file.open("res://jsons/opening_scene_dialog.json", file.READ)
	var json_text = file.get_as_text()
	file.close()
	var result_json = JSON.parse(json_text)
	
	if result_json.error == OK:
		return result_json.result
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
		return
		
