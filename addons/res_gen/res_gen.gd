@tool
extends EditorPlugin
var plugin_file = preload("res://addons/res_gen/context_menu.gd");
var dialog_scn = preload("res://addons/res_gen/ui/dialog/dialog.tscn");
var context_menu: EditorContextMenuPlugin;
var editor_filesystem: EditorFileSystem;
var toast: EditorToaster;
var dialog: Dialog;
var component_name: String;
var path: String;

func _enter_tree() -> void:
	editor_filesystem = EditorInterface.get_resource_filesystem();
	toast = EditorInterface.get_editor_toaster();
	dialog = dialog_scn.instantiate();
	
	dialog.component_name_changed.connect(_change_component_name);
	dialog.confirmed.connect(_accept_confirm);
	dialog.canceled.connect(_cancel_confirm);
	add_child(dialog);
	
	context_menu = plugin_file.new();
	context_menu.item_clicked.connect(_click_create_component_item);
	add_context_menu_plugin(EditorContextMenuPlugin.ContextMenuSlot.CONTEXT_SLOT_FILESYSTEM, context_menu);
	
func _click_create_component_item(p: String) -> void:
	if DirAccess.open("res://").dir_exists(p):
		open_dialog(p);
	else:
		toast.push_toast(
			"Choose directory, not " + p.get_file(), 
			EditorToaster.SEVERITY_WARNING, 
			p.simplify_path()
		);

func _accept_confirm():
	if component_name.length() > 0:
		var type = dialog.get_options_value();
		var base_src = path.path_join(component_name).path_join(component_name);
		var script = GDScript.new();
		var node_to_save = ClassDB.instantiate(type);
		var dir = DirAccess.open(path);
		var scene = PackedScene.new();
		
		dir.make_dir(component_name);
		
		script.source_code = """extends {type}

func _ready():
	pass""".format({"type": type});
		
		script.resource_name = component_name;
		script.resource_path = base_src + ".gd";
		ResourceSaver.save(script, script.resource_path);
		
		node_to_save.name = component_name.capitalize();
		node_to_save.set_script(load(script.resource_path));
		scene.resource_name = component_name;
		scene.pack(node_to_save);
		ResourceSaver.save(scene, base_src+".tscn");

		editor_filesystem.scan();
		dialog.input.text = "";
	else:
		toast.push_toast(
			"Type component name", 
			EditorToaster.SEVERITY_WARNING
		);

func _cancel_confirm():
	component_name = "";
	dialog.input.text = "";
	pass

func _change_component_name(new_text: String):
	component_name = new_text;
	
func open_dialog(p: String):
	path = p;
	dialog.popup_centered();
	dialog.options.grab_focus();
	
func _exit_tree() -> void:
	dialog.queue_free();
	remove_context_menu_plugin(context_menu);
