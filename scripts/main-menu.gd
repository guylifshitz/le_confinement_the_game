extends Node2D

var dialog_settings = utils_custom.load_json("res://jsons/opening_scene_dialog.json")
var dialog_chunks = dialog_settings["english"]
var dialog_chunk = -1

var TEXT_SCROLL_SPEED = float(dialog_settings["TEXT_SCROLL_SPEED"])

func _ready():
	# DEBUG: skip to the scene that we are testing
	# get_tree().change_scene("res://win-screen.tscn")
	# get_tree().change_scene("res://level_bastille.tscn")
	get_tree().change_scene("res://lose-sick.tscn")
	next_page()

func next_page():
		$audio/pop.play()

		dialog_chunk += 1
		if dialog_chunk == dialog_chunks.size():
			go_to_next_scene()
		else:
			$click_button.hide()
			$dialog/grandma_dialog.text = dialog_chunks[dialog_chunk]
			$dialog/grandma_dialog.visible_characters = 1
			scroll_text()

func go_to_next_scene():
	get_tree().change_scene("res://level_bastille.tscn")

func scroll_text():
	if $dialog/grandma_dialog.visible_characters < $dialog/grandma_dialog.text.length():
		$dialog/grandma_dialog.visible_characters += 1
		utils_custom.create_timer_2(TEXT_SCROLL_SPEED, self, "scroll_text")
	else:
		$click_button.show()
	show_page_icons()

func show_page_icons():
	$dialog/icons/groceries.hide()
	$dialog/icons/distance_bar.hide()
	$dialog/icons/health_bar.hide()
	$dialog/icons/attestation.hide()
	$dialog/icons/policeman.hide()

	if 	$dialog/grandma_dialog.visible_characters >= $dialog/grandma_dialog.text.length():
		if dialog_settings["show_items_list_text_index"] == dialog_chunk:
			$dialog/icons/groceries.show()
		if dialog_settings["show_distance_bar_text_index"] == dialog_chunk:
			$dialog/icons/distance_bar.show()
		if dialog_settings["show_health_bar_text_index"] == dialog_chunk:
			$dialog/icons/health_bar.show()
		if dialog_settings["show_attestation_text_index"] == dialog_chunk:
			$dialog/icons/attestation.show()
		if dialog_settings["show_police_text_index"] == dialog_chunk:
			$dialog/icons/policeman.show()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		text_clicked()

func text_clicked():
	if $dialog/grandma_dialog.visible_characters < $dialog/grandma_dialog.text.length():
		$dialog/grandma_dialog.visible_characters = $dialog/grandma_dialog.text.length()
		show_page_icons()
	else:
		next_page()

