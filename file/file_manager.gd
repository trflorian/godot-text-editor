extends Node

class_name FileManager

@export var tab_container: TabContainer
@export var tab_file_prefab: PackedScene

@export var file_dialog_open: FileDialog
@export var file_dialog_save: FileDialog

signal on_changed_any_file_tab_open(bool)

func _ready() -> void:
	file_dialog_open.file_selected.connect(_on_open_file)
	file_dialog_save.file_selected.connect(_on_save_file)
	
	tab_container.tab_changed.connect(_on_focus_tab)

func _on_focus_tab(id: int) -> void:
	var file_tab = tab_container.get_tab_control(id) as FileTab
	file_tab.on_tab_selected()

func _tab_count() -> int:
	return tab_container.get_child_count()

func _any_file_tabs() -> bool:
	return _tab_count() > 0

func close_current_file() -> void:
	if not _any_file_tabs():
		return
		
	if _tab_count() == 1:
		on_changed_any_file_tab_open.emit(false)
		
	var active_tab = tab_container.get_current_tab_control()
	active_tab.queue_free()

func show_open_file_dialog() -> void:
	file_dialog_open.show()

func show_save_file_dialog() -> void:
	if not _any_file_tabs():
		return
		
	file_dialog_save.show()

func create_new_file_tab() -> int:
	var new_tab = tab_file_prefab.instantiate() as FileTab
	tab_container.add_child(new_tab)
	
	var idx = tab_container.get_tab_idx_from_control(new_tab)
	tab_container.set_tab_title(idx, "[unnamed]*")
	
	tab_container.current_tab = idx
	
	new_tab.on_file_changed.connect(func(has_changes): _mark_file_changes(new_tab, has_changes))
	
	_check_file_actions()
	
	return idx

func clear_content_current_file() -> void:
	var active_tab = tab_container.get_current_tab_control() as FileTab
	active_tab.clear_content()

func _mark_file_changes(file_tab: Control, has_changes: bool) -> void:
	var idx = tab_container.get_tab_idx_from_control(file_tab)
	var title = tab_container.get_tab_title(idx)
	var title_changes = title.ends_with("*")
	
	if not title_changes and has_changes:
		tab_container.set_tab_title(idx, title + "*")
	elif title_changes and not has_changes:
		var title_without_changes = title.substr(0, title.length()-1)
		tab_container.set_tab_title(idx, title_without_changes)

func _on_open_file(path: String) -> void:
	var file_name = path.split("/")[-1]
	print("Opening file %s in %s" % [file_name, path])
	
	var idx = create_new_file_tab()
	tab_container.set_tab_title(idx, file_name)
	
	var file_tab = tab_container.get_tab_control(idx) as FileTab
	file_tab.load_from_file(path)
	
	# convenience when opening save file dialog, it is at the same path
	file_dialog_save.current_path = path
	
	_check_file_actions()

func _on_save_file(path: String) -> void:
	var file_name = path.split("/")[-1]
	print("Saving file %s in %s" % [file_name, path])
	
	var idx = tab_container.current_tab
	tab_container.set_tab_title(idx, file_name)
	
	var file_tab = tab_container.get_tab_control(idx) as FileTab
	file_tab.save_to_file(path)

	# convenience when opening open file dialog, it is at the same path
	file_dialog_open.current_path = path

func _check_file_actions() -> void:
	on_changed_any_file_tab_open.emit(_any_file_tabs())
