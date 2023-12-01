extends Control

class_name FileTab

signal on_file_changed(bool)

@onready var text_edit: TextEdit = %TextEdit

var newly_created: bool = true
var original_file_content: String = ""

func _ready() -> void:
	text_edit.text_changed.connect(_on_text_changed)
	
func _on_text_changed() -> void: 
	var has_changes = newly_created or text_edit.text != original_file_content
	on_file_changed.emit(has_changes)

func load_from_file(file_path: String) -> void:
	print("Reading file from %s" % file_path)
	newly_created = false

	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	text_edit.text = content
	original_file_content = content
	

func save_to_file(file_path: String) -> void:
	print("Saving file to %s" % file_path)
	newly_created = false
	
	var content = text_edit.text
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	file.store_string(content)
	file.close()
	
	original_file_content = content
	on_file_changed.emit(false)
