extends MenuButton

@export var file_manager: FileManager

func _ready() -> void:
	get_popup().index_pressed.connect(_on_menu_item_selected)
	
func _on_menu_item_selected(id: int) -> void:
	if id == 0: # Clear file content
		file_manager.clear_content_current_file()
	else: # unknow menu item
		var item_name = get_popup().get_item_text(id)
		print("Unkown file menu item id=%d, name=%s" % [id, item_name])
