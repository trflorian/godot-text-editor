extends Control

class_name FileTab

signal on_file_changed(bool)

@onready var text_edit: TextEdit = %TextEdit

var original_file_content: String = ""

func _ready() -> void:
	text_edit.text_changed.connect(_on_text_changed)
	
func _on_text_changed(): 
	var has_changes = text_edit.text != original_file_content
	on_file_changed.emit(has_changes)

func load_from_file(file_path: String) -> void:
	print("Reading file from %s" % file_path)

	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	
	text_edit.text = content
	original_file_content = content
