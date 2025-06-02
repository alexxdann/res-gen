@tool
extends ConfirmationDialog
class_name Dialog

@onready var input: LineEdit = $Inputs/Input;
@onready var options: OptionButton = $Inputs/Options;

var btn_size = Vector2(50, 25);

signal component_name_changed(new_text: String);

func _ready() -> void:
	register_text_enter(input);
	get_ok_button().size = btn_size;
	get_cancel_button().size = btn_size;
	
	for type in ClassDB.get_class_list():
		if ClassDB.is_parent_class(type, "Node"):
			options.add_item(type);

func _on_input_text_changed(new_text: String) -> void:
	component_name_changed.emit(new_text);

func get_options_value() -> String:
	return options.get_item_text(options.get_selected_id());

func _on_options_item_selected(index: int) -> void:
	input.grab_focus();
