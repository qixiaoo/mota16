extends Panel


onready var container = $ScrollContainer/MarginContainer/GridContainer


func _ready():
	init_ui()


# warning-ignore:unused_argument
func _unhandled_input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()


func _on_SaveButton_pressed():
	Data.create_game_save()
	update_ui()


func _on_CloseButton_pressed():
	Signal.emit_signal("s_close_dialog")


func init_ui() -> void:
	var game_saves: Array = Data.game_saves
	for index in range(game_saves.size()):
		var save = game_saves[index]
		var buttons = create_buttons(save.name, index)
		container.add_child(buttons[0])
		container.add_child(buttons[1])


func reset_ui() -> void:
	for child in container.get_children():
		container.remove_child(child)


func update_ui() -> void:
	reset_ui()
	init_ui()


func create_buttons(label: String, index: int) -> Array:
	var label_button = Button.new()
	label_button.size_flags_horizontal = SIZE_FILL | SIZE_EXPAND
	label_button.text = label
	label_button.connect("pressed", self, "load_game_save", [index])
	var delete_button = Button.new()
	delete_button.rect_min_size = Vector2(25, 25)
	delete_button.text = "x"
	delete_button.connect("pressed", self, "delete_game_save", [index])
	return [label_button, delete_button]


func load_game_save(index: int) -> void:
	Data.load_game_save(index)
	Signal.emit_signal("s_close_dialog")
	Signal.emit_signal("s_fly_to_level", Data.current_level)


func delete_game_save(index: int) -> void:
	Data.delete_game_save(index)
	update_ui()
