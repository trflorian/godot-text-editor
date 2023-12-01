extends Node

class_name FileManager

@export var tab_container: TabContainer
@export var tab_file_prefab: PackedScene

@export var file_dialog_open: FileDialog
@export var file_dialog_save: FileDialog

func _ready() -> void:
	pass

func close_current_file() -> void:
	var active_tab = tab_container.get_current_tab_control()
	active_tab.queue_free()

func show_open_file_dialog() -> void:
	file_dialog_open.show()

func show_save_file_dialog() -> void:
	file_dialog_save.show()

func create_new_file() -> void:
	var new_tab = tab_file_prefab.instantiate()
	tab_container.add_child(new_tab)
	
	var idx = tab_container.get_tab_idx_from_control(new_tab)
	tab_container.set_tab_title(idx, "[unnamed]")
	
	tab_container.current_tab = idx
