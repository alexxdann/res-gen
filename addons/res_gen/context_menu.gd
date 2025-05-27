extends EditorContextMenuPlugin

signal item_clicked(path: String)

func _popup_menu(path:PackedStringArray):
	const ICON = preload("res://icon.svg")
	add_context_menu_item("Create component", handle, ICON)
	
func handle(res:PackedStringArray):
	var path = res[0];
	item_clicked.emit(path)
	pass
