extends Panel


onready var grid_container = $ScrollContainer/MarginContainer/GridContainer


func _ready() -> void:
	init_ui()


# warning-ignore:unused_argument
func _unhandled_input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()


func init_ui() -> void:
	var max_reached_level: int = int(Data.max_reached_level)
	for level in range(max_reached_level + 1):
		var is_focused = Data.current_level == level
		var button = create_button(level)
		grid_container.add_child(button)
		if is_focused:
			button.call_deferred("grab_focus")


func reset_ui() -> void:
	for child in grid_container.get_children():
		grid_container.remove_child(child)


func create_button(level: int) -> Button:
	var button = Button.new()
	button.text = "%sf" % level
	button.rect_min_size = Vector2(25, 25)
	button.connect("pressed", self, "change_level", [level])
	return button


func change_level(level: int) -> void:
	Signal.emit_signal("s_close_dialog")
	Signal.emit_signal("s_fly_to_level", level)
