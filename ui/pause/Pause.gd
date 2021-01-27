extends Control


onready var resume_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Resume


func _ready() -> void:
	resume_button.grab_focus()


# warning-ignore:unused_argument
func _unhandled_input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()


func _on_Resume_pressed() -> void:
	Signal.emit_signal("s_close_dialog")


func _on_Exit_pressed() -> void:
	Signal.emit_signal("s_close_dialog")
	Signal.emit_signal("s_back_to_main_menu")
