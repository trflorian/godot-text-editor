extends Control

signal on_file_changed

@onready var text_edit: TextEdit = %TextEdit

func load_from_file(file_path: String) -> void:
	print("Reading file from %s" % file_path)

	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	
	text_edit.text = content
