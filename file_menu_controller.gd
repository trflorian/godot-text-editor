extends MenuButton

@export var file_manager: FileManager

func _ready() -> void:
	get_popup().index_pressed.connect(_on_menu_item_selected)

func _on_menu_item_selected(id: int) -> void:
	if id == 0: # New File
		file_manager.create_new_file()
	elif id == 1: # Open File
		file_manager.show_open_file_dialog()
	elif id == 2: # Save File
		file_manager.show_save_file_dialog()
	elif id == 3: # Close File:
		file_manager.close_current_file()
	elif id == 5: # Quit
		get_tree().quit()
	else: # unknow menu item
		var item_name = get_popup().get_item_text(id)
		print("Unkown file menu item id=%d, name=%s" % [id, item_name])
