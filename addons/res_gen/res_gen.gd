@tool
extends EditorPlugin
var plugin_file = preload("res://addons/res_gen/context_menu.gd")
var context_menu: EditorContextMenuPlugin
var editor_filesystem: EditorFileSystem
var accept_dialog: AcceptDialog
var input: LineEdit
var vbox: VBoxContainer
var component_name: String

var path: String

func _enter_tree() -> void:
	editor_filesystem = EditorInterface.get_resource_filesystem();
	
	input = LineEdit.new();
	input.placeholder_text = "component name";
	input.text_changed.connect(_change_component_name);
	
	vbox = VBoxContainer.new();
	vbox.add_child(input);
	
	accept_dialog = AcceptDialog.new();
	accept_dialog.title = "Create component";
	accept_dialog.register_text_enter(input);
	accept_dialog.add_cancel_button("Cancel");
	accept_dialog.confirmed.connect(_accept_confirm);
	accept_dialog.canceled.connect(_cancel_confirm);
	accept_dialog.add_child(vbox);
	add_child(accept_dialog);
	
	context_menu = plugin_file.new();
	context_menu.item_clicked.connect(_open_context_menu);
	add_context_menu_plugin(EditorContextMenuPlugin.ContextMenuSlot.CONTEXT_SLOT_FILESYSTEM, context_menu);
	  
func _open_context_menu(p):
	path = p
	accept_dialog.popup_centered(Vector2(600, 100))
	input.grab_focus()

func _accept_confirm():
	var base_src = path+component_name+"/"+component_name;
	var script = GDScript.new();
	var node_to_save = Node.new();
	var dir=DirAccess.open(path);
	var scene = PackedScene.new();
	
	dir.make_dir(component_name);
	
	script.source_code = "extends Node";
	script.resource_name = component_name;
	script.resource_path = base_src + ".gd";
	ResourceSaver.save(script, script.resource_path);
	
	node_to_save.name = component_name.capitalize();
	node_to_save.set_script(load(script.resource_path));
	scene.resource_name = component_name;
	scene.pack(node_to_save);
	ResourceSaver.save(scene, base_src+".tscn");

	editor_filesystem.scan();
	input.text = "";
	
func _cancel_confirm():
	input.text = "";
	
func _change_component_name(new_text: String):
	component_name = new_text;
	
func _exit_tree() -> void:
	accept_dialog.queue_free();
	remove_context_menu_plugin(context_menu);
