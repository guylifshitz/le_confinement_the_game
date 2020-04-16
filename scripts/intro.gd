extends Node2D

var dialog_settings
var dialog_chunks
var dialog_chunk = -1

var TEXT_SCROLL_SPEED# = float(dialog_settings["TEXT_SCROLL_SPEED"])

func _ready():
	if not music.get_node("main_menu").playing:
		music.get_node("main_menu").play()

	if global.level_type == "groceries":
		dialog_settings = utils_custom.load_json("res://jsons/opening_scene_dialog_groceries.json")
		setup_groceries()
	else:
		dialog_settings = utils_custom.load_json("res://jsons/opening_scene_dialog_sport.json")

	dialog_chunks = dialog_settings[global.language]
	TEXT_SCROLL_SPEED = float(dialog_settings["TEXT_SCROLL_SPEED"])
	next_page()

func setup_groceries():
	var found_items_holder = get_node("dialog/icons/groceries")
	for item_index in range(global.level_settings["items_needed"].size()):
		var item = global.level_settings["items_needed"][item_index]
		var holding_slot = found_items_holder.get_child(item_index)
		var item_to_hold = load("res://prefab/holding_" + item + ".tscn")
		holding_slot.add_child(item_to_hold.instance())
	
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
	for child in $dialog/icons/.get_children():
		child.hide()

	if 	$dialog/grandma_dialog.visible_characters >= $dialog/grandma_dialog.text.length():
		for key in dialog_settings["show_item_index"]:
			if dialog_settings["show_item_index"][key] == dialog_chunk:
				$dialog/icons.get_node(key).show()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		text_clicked()

func text_clicked():
	if $dialog/grandma_dialog.visible_characters < $dialog/grandma_dialog.text.length():
		$dialog/grandma_dialog.visible_characters = $dialog/grandma_dialog.text.length()
		show_page_icons()
	else:
		next_page()



func _on_back_button_down():
	# get_tree().change_scene("res://level_select.tscn")
	get_tree().change_scene("res://level_select_part_2.tscn")
