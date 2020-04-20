extends Node2D

var dialog_chunks = []
var dialog_chunk = -1

var TEXT_SCROLL_SPEED = 0.05

func _ready():
	if not music.get_node("main_menu").playing:
		music.get_node("main_menu").play()

	dialog_chunks = []
	dialog_chunks = dialog_chunks + global.level_settings["intro_text"][global["language"]]
	if global.level_type == "groceries":
		dialog_chunks = dialog_chunks + utils_custom.load_json("res://jsons/opening_scene_dialog_groceries_generic.json")[global["language"]]
	else:
		dialog_chunks = dialog_chunks + utils_custom.load_json("res://jsons/opening_scene_dialog_groceries_sport.json")[global["language"]]

	# dialog_chunks = dialog_chunks[global.language]
	# TEXT_SCROLL_SPEED = float(dialog_settings["TEXT_SCROLL_SPEED"])
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

		for child in get_node("dialog_icons").get_children():
			child.queue_free()

		dialog_chunk += 1
		if dialog_chunk == dialog_chunks.size():
			go_to_next_scene()
		else:
			$click_button.hide()
			print("AA")
			print(dialog_chunks)
			print("BBB")
			print(dialog_chunks[dialog_chunk])
			$dialog/grandma_dialog.text = dialog_chunks[dialog_chunk]["text"]
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

	# TODO put this back with new image system
	if 	$dialog/grandma_dialog.visible_characters >= $dialog/grandma_dialog.text.length():
		print(dialog_chunks[dialog_chunk])
		var images = dialog_chunks[dialog_chunk]["images"]
		for idx in range(images.size()):
			var image = images[idx]
			show_image(image["path"], image["position"], image["size"])

		
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


func show_image(image_path, image_location, image_size):
	var sprite = Sprite.new()
	sprite.set_texture(load("res://images/"+image_path))
	var iss = sprite.get_texture().get_size()
	print(iss)
	var tw = image_size[0]
	var th = image_size[1]
	var scale = Vector2(tw/iss.x, th/iss.y)
	sprite.scale = scale
	sprite.position = Vector2(image_location[0], image_location[1])
	#get_node("main_char_node/end_level_icons").
	get_node("dialog_icons").add_child(sprite)
