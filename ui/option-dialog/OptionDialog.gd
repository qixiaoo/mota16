extends Control


const OPTION_BUTTON_SCENE = preload("res://ui/option-dialog/OptionButton.tscn")


export(String, MULTILINE) var line: String = ""
export(Array, String) var options: Array = []


onready var tween = $Tween
onready var option_container = $VBoxContainer
onready var rich_text_label = $Panel/MarginContainer/RichTextLabel


func _ready() -> void:
	init_ui()


# warning-ignore:unused_argument
func _unhandled_input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()


func init_ui() -> void:
	type_a_line(line)
	yield(tween, "tween_all_completed")
	for index in range(options.size()):
		var is_focused = index == 0
		var option = OPTION_BUTTON_SCENE.instance()
		option.text = options[index]
		option.connect("pressed", self, "select_option", [index])
		option_container.add_child(option)
		if is_focused:
			option.call_deferred("grab_focus")


func type_a_line(bbcode_text: String) -> void:
	rich_text_label.bbcode_text = bbcode_text
	var character_count = rich_text_label.text.length()
	var duration = character_count * 0.025
	tween.interpolate_property(
		rich_text_label,
		"visible_characters",
		-1,
		character_count,
		duration
	)
	tween.start()


func select_option(index: int) -> void:
	Signal.emit_signal("s_close_dialog")
	Signal.emit_signal("s_select_option", index)
