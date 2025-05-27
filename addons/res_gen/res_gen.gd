@tool
extends EditorPlugin
var plugin_file = preload("res://addons/res_gen/context_menu.gd")
var context_menu: EditorContextMenuPlugin
var accept: AcceptDialog
var line: LineEdit
var component_name: String
var custom_vbox: VBoxContainer
var editor_filesystem: EditorFileSystem

var path: String

func _enter_tree() -> void:
	editor_filesystem = EditorInterface.get_resource_filesystem()
	
	line = LineEdit.new()
	line.placeholder_text = "component name"
	line.text_changed.connect(_change_component_name)
	custom_vbox = VBoxContainer.new()
	custom_vbox.add_child(line)
	
	accept = AcceptDialog.new()
	accept.title = "Create component"
	accept.register_text_enter(line)
	accept.add_cancel_button("Cancel")
	accept.confirmed.connect(_accept_confirm)
	accept.canceled.connect(_cancel_confirm)
	accept.add_child(custom_vbox)
	add_child(accept)
	
	context_menu = plugin_file.new()
	context_menu.item_clicked.connect(_open_dialog)
	add_context_menu_plugin(EditorContextMenuPlugin.ContextMenuSlot.CONTEXT_SLOT_FILESYSTEM, context_menu)
	pass
	  
func _open_dialog(p):
	path = p
	accept.popup_centered(Vector2(600, 100))
	line.grab_focus()
	pass

func _accept_confirm():
	var dir=DirAccess.open(path)
	dir.make_dir(component_name)
	var base_src = path+component_name+"/"+component_name
	
	var scr = GDScript.new()
	scr.source_code = "extends Node"
	scr.resource_name = component_name
	scr.resource_path = base_src + ".gd"
	
	ResourceSaver.save(scr, scr.resource_path)
	
	var node_to_save = Node.new()
	node_to_save.name = component_name.capitalize()
	node_to_save.set_script(load(scr.resource_path))
	var scene = PackedScene.new()
	scene.resource_name = component_name
	scene.pack(node_to_save)
	ResourceSaver.save(scene, base_src+".tscn")

	editor_filesystem.scan()
	
	line.text = ""
	pass	
	
func _cancel_confirm():
	line.text = ""
	pass
	
func _exit_tree() -> void:
	accept.queue_free()
	remove_context_menu_plugin(context_menu)
	pass
	
func _change_component_name(new_text: String):
	component_name = new_text
