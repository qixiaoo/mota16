extends Control


export(String) var actor_name: String = ""
export(Array, String, MULTILINE) var lines: Array = []


onready var tween = $Tween
onready var rich_text_label = $Panel/MarginContainer/RichTextLabel
onready var actor = $Actor
onready var actor_label = $Actor/Label


var invalid_line_index = -1
var current_line_index = invalid_line_index


func _ready() -> void:
	set_actor()
	current_line_index += 1
	type_a_line(lines[current_line_index])


func _unhandled_input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()
	if (
		event is InputEventKey &&
		event.is_pressed() &&
		!event.is_echo() &&
		!tween.is_active() &&
		current_line_index != invalid_line_index
	):
		if current_line_index < lines.size() - 1:
			current_line_index += 1
			type_a_line(lines[current_line_index])
		else:
			Signal.emit_signal("s_close_dialog")


func set_actor() -> void:
	if actor_name:
		actor_label.text = actor_name
	else:
		actor.visible = false


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
