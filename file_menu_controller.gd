extends MenuButton

@export var file_manager: FileManager

func _ready() -> void:
	get_popup().index_pressed.connect(_on_menu_item_selected)
	
	_on_check_file_actions(false)
	file_manager.on_changed_any_file_tab_open.connect(_on_check_file_actions)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("file_new"):
		file_manager.create_new_file_tab()
	if event.is_action_pressed("file_open"):
		file_manager.show_open_file_dialog()
	if event.is_action_pressed("file_save"):
		file_manager.show_save_file_dialog()
	if event.is_action_pressed("file_close"):
		file_manager.close_current_file()

func _on_menu_item_selected(id: int) -> void:
	if id == 0: # New File
		file_manager.create_new_file_tab()
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

func _on_check_file_actions(any_tabs: bool):
	get_popup().set_item_disabled(2, not any_tabs)
	get_popup().set_item_disabled(3, not any_tabs)
